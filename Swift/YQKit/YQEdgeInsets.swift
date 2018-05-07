//
//  UIInsetsExtension.swift
//  BiuBiu
//
//  Created by meizu on 2018/3/30.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQ {
    struct EdgeInsets {
        static func uprightInsets(_ upright: CGFloat) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: upright, left: upright, bottom: upright, right: upright)
        }
        
        static func symmetryInsets(leftRight: CGFloat, topBottom: CGFloat) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
        }
    }
}
