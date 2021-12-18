//
//  Generator.swift
//  Watermark
//
//  Created by David 🤴 on 2021/12/3.
//

import Foundation
import Cocoa

class ViewControllerSwift: NSObject {
    @objc func generateResultSwift(picture: NSImage,watermark: NSImage) -> NSImage {
        let c = ViewController()
        let CGpicture:CGImage = c.ns2CG(picture).takeUnretainedValue()
        let CGwatermark:CGImage = c.ns2CG(watermark).takeUnretainedValue()
        let context:CGContext? = CGContext.init(data: nil, width: Int(picture.size.width*2), height: Int(picture.size.height*2), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context?.draw(CGpicture, in: NSMakeRect(0, 0, picture.size.width*2, picture.size.height*2))
        context?.draw(CGwatermark, in: NSMakeRect(0, 0, watermark.size.width*2, watermark.size.height*2))
        let CGImg:CGImage? = context?.makeImage()
        let Image:NSImage = c.cg2NS(CGImg)
        return Image
        //2021.12.05 重构完成，用户可自行选择使用C或Swift的实现方法
    }
}
