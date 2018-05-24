//
//  YQTreeSet.swift
//  Demo
//
//  Created by meizu on 2018/5/22.
//  Copyright © 2018年 yiquan. All rights reserved.
//

import Foundation
import UIKit

extension YQ {
    class Tree: NSObject {
        let type: Int?
        let model: Any?
        var compareSub: ((Tree, Tree) -> Bool)?{
            didSet{
                sortSubTree()
            }
        }
        var subs: [Tree]?{
            didSet {
                sortSubTree()
            }
        }
        
        init(type aType: Int? = nil, model aModel: Any? = nil) {
            type = aType
            model = aModel
        }
        
        static func tressFrom(models: [Any]?) -> [Tree]?{
            guard let models = models else {
                return nil
            }
            
            var result = [Tree]()
            for model in models {
                result.append(Tree.init(model: model))
            }
            
            return result
        }
        
        subscript(chain: IndexChain?) -> Tree?{
            var result: Tree? = nil
            var chain = chain
            
            if chain != nil {
                result = self
            }
            
            while result != nil && chain != nil {
                result = result!.subs?[chain!.value]
                chain = chain?.next
            }
            
            return result
        }
        
        subscript(index: Int) -> Tree? {
            return self[[index]]
        }
        
        subscript(indexPath: IndexPath) -> Tree?{
            return self[[indexPath.section, indexPath.row]]
        }
        
        var subsCount: Int{
            return subs?.count ?? 0
        }
        
        func indexFor(subType type: Int) -> Int? {
            for index in 0..<subsCount {
                let sub = subs![index]
                if sub.type == type {
                    return index
                }
            }
            return nil
        }
        
        func indexChainFor(subTree: Tree) -> IndexChain? {
            for index in 0..<subsCount {
                let sub = subs![index]
                if sub === subTree {
                    return [index]
                }else if let subIndexChain = sub.indexChainFor(subTree: subTree) {
                    return [index] + subIndexChain
                }
            }
            return nil
        }
        
        // 在 at 节点上添加子节点， 如果at为nil， 在本身上添加，
        // 返回值为 at + 添加的索引， 空标识添加失败
        func appendTree(_ tree: Tree, at: IndexChain?) -> IndexChain? {
            var supperTree: Tree? = self
            if at != nil {
                supperTree = self[at]
            }
            
            guard supperTree != nil else {
                return nil
            }
            
            var index: Int? = nil
            if let subTrees = supperTree?.subs {
                if let compare = supperTree?.compareSub {
                    for i in 0..<subTrees.count{
                        let subTree = subTrees[i]
                        if compare(tree, subTree) {
                            index = i
                            break
                        }
                    }
                }
                
                if index != nil {
                    supperTree?.subs?.insert(tree, at: index!)
                }else {
                    supperTree?.subs?.append(tree)
                    index = supperTree!.subs!.count - 1
                }
            } else {
                supperTree?.subs = [tree]
                index = 0
            }
            
            if at == nil {
                return [index!]
            }else {
                return at! + [index!]
            }
        }
        
        func remove(at: IndexChain) -> Bool {
            let index = at.last.value
            
            var currentTree: Tree? = self
            if at.removeLast() {
                currentTree = self[at]
            }
            
            return currentTree?.subs?.remove(at: index) != nil
        }
    }
}

private extension YQ.Tree{
    func sortSubTree() {
        guard let compareSub = compareSub else {
            return
        }
        
        subs?.sort(by: compareSub)
    }
}

extension YQ.Tree {
    class IndexChain: ExpressibleByArrayLiteral {
        typealias ArrayLiteralElement = Int
        
        var value = 0
        var next: IndexChain?
        
        init(chain: [Int]) {
            guard let aValue = chain.first else {
                return
            }
            
            value = aValue
            var subChain = chain
            subChain.removeFirst()
            next = IndexChain.init(chain: subChain)
        }
        
        required convenience init(arrayLiteral elements: YQ.Tree.IndexChain.ArrayLiteralElement...) {
            self.init(chain: elements)
        }
        
        var last: IndexChain{
            var last = self
            while last.next != nil {
                last = last.next!
            }
            return last
        }
        
        static func + (left: IndexChain, right: IndexChain) -> IndexChain {
            var last: IndexChain = left
            while last.next != nil {
                last = last.next!
            }
            
            last.next = right
            
            return left
        }
        
        // 至少有2个节点才会删除成功
        func removeLast() -> Bool {
            var current = self
            while nil != current.next?.next {
                current = current.next!
            }
            
            if current.next == nil {
                return false
            } else {
                current.next = nil
                return true
            }
        }
    }
}

extension IndexPath{
    init?(indexChain: YQ.Tree.IndexChain?) {
        let section = indexChain?.value
        let row = indexChain?.next?.value
        if section != nil && row != nil {
            self.init(row: row!, section: section!)
        } else {
            return nil
        }
    }
}

class Test: NSObject, UITableViewDelegate, UITableViewDataSource{
    var data: YQ.Tree!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.subsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section]?.subsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelTree = data[indexPath]
        let type = modelTree?.type
        let model = modelTree?.model
        return UITableViewCell()
    }
}


