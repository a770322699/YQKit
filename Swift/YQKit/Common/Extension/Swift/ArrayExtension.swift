//
//  ArrayExtension.swift
//  MultifunctionCalculator
//
//  Created by maygolf on 2017/10/24.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation

extension Array where Element: Equatable{
    func yq_replaceElment(_ oldElment: Element, with newElment: Element) -> [Element]{
        var result = self
        
        guard contains(oldElment) else {
            return self
        }
        
        result.replaceSubrange(Range.init(NSRange.init(location: index(of: oldElment)!, length: 1))!, with: [newElment])
        
        return result
    }
}
