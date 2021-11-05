//
//  Utils.swift
//  Genshin Stater
//
//  Created by KAMIKU on 11/1/21.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title:String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func alertWithConfrim(title:String, msg: String, callback: @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: callback))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

func loadImage(imgName: String) -> Data? {
    if FileManager.default.fileExists(atPath: imgName.appending(".jpg")) {
        let url = NSURL(string: imgName)
        let data = NSData(contentsOf: url! as URL)
        return data as Data?
    }
    return nil
}

func saveImage(img: UIImage, name: String){
    let fileManager = FileManager.default
    let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let filePath = "\(rootPath)/\(name).jpg"
    let imageData = img.jpegData(compressionQuality: 1.0)
    fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
}

