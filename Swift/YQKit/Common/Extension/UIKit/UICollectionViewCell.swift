//
//  UICollectionViewCell.swift
//  MultifunctionCalculator
//
//  Created by maygolf on 2017/10/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

import Foundation
import UIKit

fileprivate let yq_bgViewKey = "yq_bgViewKey"
fileprivate let yq_selectedBgViewKey = "yq_selectedBgViewKey"
fileprivate let yq_bgImageViewKey = "yq_bgImageViewKey"
fileprivate let yq_selelectedBgImageViewKey = "yq_selelectedBgImageViewKey"

extension UICollectionViewCell{

    private var yq_bgView: UIView{
        if let view = objc_getAssociatedObject(self, yq_bgViewKey) {
            return view as! UIView
        }
        
        let view = UIView()
        objc_setAssociatedObject(self, yq_bgViewKey, view, .OBJC_ASSOCIATION_RETAIN)
        return view
    }
    
    private var yq_selectedBgView: UIView{
        if let view = objc_getAssociatedObject(self, yq_selectedBgViewKey) {
            return view as! UIView
        }
        
        let view = UIView()
        objc_setAssociatedObject(self, yq_selectedBgViewKey, view, .OBJC_ASSOCIATION_RETAIN)
        return view
    }
    
    private var yq_bgImageView: UIImageView{
        if let view = objc_getAssociatedObject(self, yq_bgImageViewKey) {
            return view as! UIImageView
        }
        
        let view = UIImageView()
        objc_setAssociatedObject(self, yq_bgImageViewKey, view, .OBJC_ASSOCIATION_RETAIN)
        return view
    }
    
    private var yq_selectedBgImageView: UIImageView{
        if let view = objc_getAssociatedObject(self, yq_selelectedBgImageViewKey) {
            return view as! UIImageView
        }
        
        let view = UIImageView()
        objc_setAssociatedObject(self, yq_selelectedBgImageViewKey, view, .OBJC_ASSOCIATION_RETAIN)
        return view
    }
    
    var yq_bgColor: UIColor?{
        get{
            return backgroundView?.backgroundColor
        }
        set{
            if let color = newValue{    // 有颜色
                backgroundView = yq_bgView
                backgroundView?.backgroundColor = color
            }else if yq_bgImage == nil{    // 无颜色、无图片
                backgroundView = nil
            }
        }
    }
    
    var yq_selectedBgColor: UIColor?{
        get{
            return selectedBackgroundView?.backgroundColor
        }
        set{
            if let color = newValue{    // 有颜色
                selectedBackgroundView = yq_selectedBgView
                selectedBackgroundView?.backgroundColor = color
            }else if yq_selectedBgImage  == nil{    // 无颜色、无图片
                selectedBackgroundView = nil
            }
        }
    }
    
    var yq_bgImage: UIImage?{
        get{
            return (backgroundView as? UIImageView)?.image
        }
        set{
            if let image = newValue { // 有图片
                yq_bgImageView.image = image
                backgroundView = yq_bgImageView
            }else if yq_bgColor == nil || yq_bgColor == UIColor.clear{  // 无图片、无颜色
                backgroundView = nil
            }
        }
    }
    
    var yq_selectedBgImage: UIImage?{
        get{
            return (selectedBackgroundView as? UIImageView)?.image
        }
        set{
            if let image = newValue { // 有图片
                yq_selectedBgImageView.image = image
                selectedBackgroundView = yq_selectedBgImageView
            }else if yq_selectedBgColor == nil || yq_selectedBgColor == UIColor.clear{  // 无图片、无颜色
                selectedBackgroundView = nil
            }
        }
    }
    
}
