//
//  extensions.swift
//  MedicalAlarm
//
//  Created by Crescenzo Garofalo on 25/02/18.
//  Copyright © 2018 Crescenzo Garofalo. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    static func localized(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension UIImageView {
    
    func setRounded() {
        let radius = (self.frame.width) / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func resetRounded() {
        let radius = 0
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }

    
}

extension UIImage {
    
    func fixImageOrientation(frontCamera: Bool) -> UIImage? {
        
        
        if (self.imageOrientation == .up) {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        
        if (!frontCamera && (self.imageOrientation == .left || self.imageOrientation == .leftMirrored) ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        } else if ( self.imageOrientation == .right || self.imageOrientation == .rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        } else if ( self.imageOrientation == .down || self.imageOrientation == .downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        } else if ( self.imageOrientation == .upMirrored || self.imageOrientation == .downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        } else if (!frontCamera && (self.imageOrientation == .leftMirrored || self.imageOrientation == .rightMirrored)) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        } else if (frontCamera && self.imageOrientation == .leftMirrored) {
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0))
        }
        
        
        if let context: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                              bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                              space: self.cgImage!.colorSpace!,
                                              bitmapInfo: self.cgImage!.bitmapInfo.rawValue) {
            
            context.concatenate(transform)
            
            if (self.imageOrientation == UIImageOrientation.left ||
                self.imageOrientation == UIImageOrientation.leftMirrored ||
                self.imageOrientation == UIImageOrientation.right ||
                self.imageOrientation == UIImageOrientation.rightMirrored) {
                context.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
            } else {
                context.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            }
            
            if let contextImage = context.makeImage() {
                
                return UIImage(cgImage: contextImage)
                
            }
            
        }
        
        return nil
    }
}
