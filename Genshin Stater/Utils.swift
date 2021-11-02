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
