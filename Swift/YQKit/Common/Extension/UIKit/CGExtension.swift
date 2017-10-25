//
//  CGExtension.swift
//  Demo
//
//  Created by maygolf on 2017/9/26.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation
import UIKit

extension CGRect{
    func containt(point: CGPoint, boundary: Bool) -> Bool {
        if boundary {
            return point.x >= origin.x
                && point.x <= origin.x + size.width
                && point.y >= origin.y
                && point.y <= origin.y + size.height
        }else{
            return point.x > origin.x
                && point.x < origin.x + size.width
                && point.y > origin.y
                && point.y < origin.y + size.height
        }
    }
}
