//
//  YQViewController.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/25.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQ{
    struct ViewController {
        static var topPresentedViewController: UIViewController?{
            var controller = UIApplication.shared.keyWindow?.rootViewController
            while let presentedVC = controller?.presentedViewController {
                controller = presentedVC
            }
            return controller
        }
    }
}
