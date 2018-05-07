//
//  UIImageExtension.swift
//  BiuBiu
//
//  Created by meizu on 2018/3/29.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQ {
    struct Image {
        // 合成环形图
        static func circleImage(_ image: YQ.CircleImage?) -> UIImage? {
            return image?.circleImage
        }
        
        static func renderingOriginalImage(_ name: String?) -> UIImage?{
            guard let name = name else {
                return nil
            }
            return UIImage.init(named: name)?.withRenderingMode(.alwaysOriginal)
        }
    }
}
