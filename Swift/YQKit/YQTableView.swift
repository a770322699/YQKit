//
//  YQTableView.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/9.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQValue where Value == UITableView {
    func insertRows(_ rows: [Int], at section: Int, with: UITableViewRowAnimation = .none) {
        var indexPaths = [IndexPath]()
        for index in rows {
            indexPaths.append(IndexPath.init(row: index, section: section))
        }
        value.insertRows(at: indexPaths, with: with)
    }
}
