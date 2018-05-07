//
//  YQCircleImage.swift
//  BiuBiu
//
//  Created by meizu on 2018/4/3.
//  Copyright © 2018年 meizu. All rights reserved.
//

import Foundation
import UIKit

extension YQ {
    struct CircleImage {
        let maxCount = 4
        var images: [UIImage]?
        var size: CGFloat?
        var boardWidth: CGFloat = 2
        var boardColor: UIColor = UIColor.white
        var crossWidth: CGFloat = 10
        var direction: Direction = .clockwise
        
        init(images aImages: [UIImage]?, aSize: CGFloat?) {
            images = aImages
            size = aSize
        }
        
        private func subImageRect(at index: Int) -> CGRect? {
            guard let size = size else {
                return nil
            }
            
            let count = min(images?.count ?? 0, maxCount)
            guard count > 0 else {
                return nil
            }
            
            guard index >= 0 && index < count else {
                return nil
            }
            
            if count == 1 {
                return CGRect.init(origin: CGPoint.zero, size: YQ.Size.uprightSize(size))
            } else if count == 2 {
                let subSize = size / 2 + crossWidth / 2
                let y = (size - subSize) / 2
                switch index {
                case 0:
                    return CGRect.init(origin: CGPoint.init(x: 0, y: y), size: YQ.Size.uprightSize(subSize))
                case 1:
                    let x = (size - crossWidth) / 2
                    return CGRect.init(origin: CGPoint.init(x: x, y: y), size: YQ.Size.uprightSize(subSize))
                default:
                    break
                }
            }else if count == 3 {
                let subSize = (2 * CGFloat(sqrtf(3)) - 3) * size + (1 / (2 + CGFloat(sqrtf(3)))) * crossWidth * 2
                var original = CGPoint.zero
                switch index {
                case 0:
                    original = CGPoint.init(x: (size - subSize) / 2, y: 0)
                case 1:
                    original = CGPoint.init(x: (CGFloat(sqrtf(3)) + 2) / 4 * size - (2 + CGFloat(sqrtf(3))) / 2 * subSize / 2, y: 0.75 * size - 1.5 * subSize / 2)
                case 2:
                    original = CGPoint.init(x:(2 - CGFloat(sqrtf(3))) / 4 * size + (CGFloat(sqrtf(3)) - 2) / 2 * subSize / 2 , y: 0.75 * size - 1.5 * subSize / 2)
                default:
                    return nil
                }
                return CGRect.init(origin: original, size: YQ.Size.uprightSize(subSize))
            }else if count == 4 {
                let subSize = size / 2 + crossWidth / 2
                let behindO = (size - crossWidth) / 2
                switch index {
                case 0:
                    return CGRect.init(x: 0, y: 0, width: subSize, height: subSize)
                case 1:
                    return CGRect.init(x: behindO, y: 0, width: subSize, height: subSize)
                case 2:
                    return CGRect.init(x: behindO, y: behindO, width: subSize, height: subSize)
                case 3:
                    return CGRect.init(x: 0, y: behindO, width: subSize, height: subSize)
                default:
                    break
                }
            }
            return nil
        }
        
        private func subImageAngleClockwise(at index: Int) -> SubAngle?{
            guard let rect = subImageRect(at: index) else {
                return nil
            }
            
            let angle = acos(1 - crossWidth / rect.width)
            let start = -angle
            let end = angle
            
            let count = min(images!.count, maxCount)
            if count == 1 {
                return SubAngle.init(start: 0, end: CGFloat.pi * 2, rotate: 0)
            } else if count == 2 {
                switch index {
                case 0:
                    return SubAngle.init(start: 0, end: CGFloat.pi * 2, rotate: 0)
                case 1:
                    return SubAngle.init(start: start, end: end, rotate: CGFloat.pi)
                default:
                    break
                }
            } else if count == 3 {
                var rote: CGFloat = 0
                switch index {
                case 0:
                    rote = -CGFloat.pi * 2 / 3
                case 1:
                    rote = CGFloat.pi * 2 / 3
                case 2:
                    rote = 0
                default:
                    return nil
                }
                return SubAngle.init(start: start, end: end, rotate: rote)
            } else if count == 4 {
                var rote: CGFloat = 0
                switch index {
                case 0:
                    rote = -CGFloat.pi / 2
                case 1:
                    rote = CGFloat.pi
                case 2:
                    rote = CGFloat.pi / 2
                case 3:
                    rote = 0
                default:
                    return nil
                }
                return SubAngle.init(start: start, end: end, rotate: rote)
            }
            return nil
        }
        
        
        private func subImageAngleClockwise(at index: Int, direction: Direction) -> SubAngle? {
            if direction == .clockwise {
                return subImageAngleClockwise(at: index)
            }
            
            // 暂时只支持顺时针
            return nil
        }
        
        fileprivate func subImage(at index: Int) -> UIImage? {
            guard let rect = subImageRect(at: index) else {
                return nil
            }
            
            guard let angle = subImageAngleClockwise(at: index, direction: direction) else {
                return nil
            }
            
            let size = rect.height
            let radius = size / 2
            
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
            let context = UIGraphicsGetCurrentContext()
            
            context?.saveGState()
            context?.translateBy(x: radius, y: radius)
            context?.rotate(by: -angle.rotate)
            
            context?.addArc(center: CGPoint.init(x: 0, y: 0), radius: radius, startAngle: angle.start, endAngle: angle.end, clockwise: true)
            if angle.start != 0 {
                context?.addArc(center: CGPoint.init(x: size * 2 - crossWidth - radius * 2, y: 0), radius: radius, startAngle: angle.start + CGFloat.pi, endAngle: angle.end + CGFloat.pi, clockwise: false)
            }
            context?.clip()
            
            context?.rotate(by: angle.rotate)
            let image = images![index]
            let imageRect = CGRect.init(origin: CGPoint.init(x: -radius, y: -radius), size: rect.size)
            image.draw(in: imageRect)
            
            context?.rotate(by: -angle.rotate)
            context?.addArc(center: CGPoint.init(x: 0, y: 0), radius: radius - boardWidth / 2, startAngle: angle.start, endAngle: angle.end, clockwise: true)
            if angle.start != 0 {
                context?.addArc(center: CGPoint.init(x: size * 2 - crossWidth - radius * 2, y: 0), radius: radius - boardWidth / 2, startAngle: angle.start + CGFloat.pi, endAngle: angle.end + CGFloat.pi, clockwise: false)
            }
            
            context?.setStrokeColor(boardColor.cgColor)
            context?.setLineWidth(boardWidth)
            context?.strokePath()
            
            context?.restoreGState()
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resultImage
        }
        
        var circleImage: UIImage?{
            guard let images = images, !images.isEmpty else {
                return nil
            }
            
            guard let size = size, size != 0 else {
                return nil
            }
            
            UIGraphicsBeginImageContextWithOptions(YQ.Size.uprightSize(size), false, 1)
            for index in 0...min(maxCount, images.count) {
                let image = subImage(at: index)
                image?.draw(in: subImageRect(at: index)!)
            }
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resultImage
        }
        
    }
}

extension YQ.CircleImage {
    enum Direction {
        case clockwise      // 顺时针
        case anticlockwise  // 逆时针
    }
    
    fileprivate struct SubAngle {
        var start: CGFloat = 0
        var end: CGFloat = 0
        var rotate: CGFloat = 0
    }
}
