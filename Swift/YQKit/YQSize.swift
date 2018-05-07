//
//  CGSizeExtension.swift
//  BiuBiu
//
//  Created by meizu on 2018/3/30.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    var yq: YQValue<CGSize>{
        return YQValue(value: self)
    }
}

extension YQ {
    struct Size {
        static func uprightSize(_ upright: CGFloat) -> CGSize {
            return CGSize.init(width: upright, height: upright)
        }
    }
}

extension YQValue where Value == CGSize {
    var minValue: CGFloat{
        return min(value.width, value.height)
    }
    var maxValue: CGFloat{
        return max(value.width, value.height)
    }
}

// MARK: math
extension YQValue where Value == CGSize {
    func multiply(_ value: CGFloat) -> CGSize {
        return CGSize.init(width: self.value.width * value, height: self.value.height * value)
    }
}

