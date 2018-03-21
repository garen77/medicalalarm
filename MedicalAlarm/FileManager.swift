//
//  FileManager.swift
//  MedicalAlarm
//
//  Created by Crescenzo Garofalo on 16/03/18.
//  Copyright © 2018 Crescenzo Garofalo. All rights reserved.
//

import Foundation
import UIKit


class FilesManager {
    
    static var sharedInstance : FilesManager {
        return FilesManager()
    }
    
    private init() {
        
    }
    
    func saveImage(imageName: String, image: UIImage, frontCamera: Bool) {
        
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent("\(imageName).png")
        
        let imageToSave = image.fixImageOrientation(frontCamera: frontCamera)
        
        do{
            if let pngImageData = UIImagePNGRepresentation(imageToSave!){
                
                try pngImageData.write(to : filePath , options : .atomic)
            }
            
        }catch{
            print("couldn't write image")
            
        }
    }
    
    func loadImage(imageName: String) -> UIImage {
        
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let filePath = docDir.appendingPathComponent("\(imageName).png");
        
        if FileManager.default.fileExists(atPath: filePath.path){
            if let containOfFilePath = UIImage(contentsOfFile : filePath.path){
                return containOfFilePath;
            }
        }
        
        return UIImage();
    }
    
    
}
