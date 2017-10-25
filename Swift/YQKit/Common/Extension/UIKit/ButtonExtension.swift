//
//  ButtonExtension.swift
//  Demo
//
//  Created by maygolf on 2017/9/25.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    enum YQImagePosition {
        case left, right, top, bottom
    }
    
    /**
     *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
     *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
     *
     *  @param spacing 图片和文字的间隔
     */
    func yq_setImagePosition(_ position: YQImagePosition, space: CGFloat) {
        let imageWidth = self.imageView?.image?.size.width ?? 0
        let imageHeight = self.imageView?.image?.size.height ?? 0
        let labelSize = (self.titleLabel?.text as NSString?)?.size(withAttributes: [NSAttributedStringKey.font: self.titleLabel!.font!]) ?? CGSize.zero

        let imageOffsetX = (imageWidth + labelSize.width) / 2 - imageWidth / 2
        let imageOffsetY = imageWidth / 2 + space / 2
        let labelOffsetX = (imageWidth + labelSize.width / 2) - (imageWidth + labelSize.width) / 2
        let labelOffsetY = labelSize.height / 2 + space / 2
        
        switch position {
            
        case .left:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -space / 2, bottom: 0, right: space / 2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: space / 2, bottom: 0, right: -space / 2)
            
        case .right:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelSize.width + space / 2, bottom: 0, right: -(labelSize.width + space / 2))
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageHeight + space / 2), bottom: 0, right: imageHeight + space / 2)
                
        case .top:
            self.imageEdgeInsets = UIEdgeInsets.init(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets.init(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            
        case .bottom:
            self.imageEdgeInsets = UIEdgeInsets.init(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets.init(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
        }
    }
}
