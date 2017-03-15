//
//  UIExtensions.swift
//  Extensions
//
//  Created by James Rochabrun on 3/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    //extension accepts a HEX string and returns the associated UIColor
    static func hexStringToUIColor(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK: - UIButton extensions

extension UIButton {
    
    func with(title: String ,target:Any, selector:(Selector), cornerRadius: CGFloat, font: String, fontSize: CGFloat, color: String, titleColor: String) {
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(UIColor.hexStringToUIColor(titleColor), for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = UIFont(name: font, size: fontSize)
        self.addTarget(target, action: selector, for: .touchUpInside)
        self.backgroundColor = UIColor.hexStringToUIColor(color)
        self.layer.masksToBounds = true
    }
}


//MARK: - UItextView extensions

extension UITextView {
    
    func with(text: String, font: String, fontSize: CGFloat, textColor: String) {
        self.font = UIFont(name: font, size: fontSize)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor.hexStringToUIColor(textColor)
        self.isUserInteractionEnabled = false
        self.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
}


//MARK: - UILabel extensions

extension UILabel {
    
    func with(text: String, font: String, fontSize: CGFloat, textColor: String) {
        
        self.font = UIFont(name: font, size: fontSize)
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor.hexStringToUIColor(textColor)
        self.adjustsFontSizeToFitWidth = true
        self.text = text
    }
}

//MARK - UIVIEWS

extension UIView {
    
    func rootViewOf() -> UIView {
        var view = self
        while view.superview != nil {
            view = view.superview!
        }
        return view
    }
    
    func oneLevelUp() -> [Int] {
        var view = self
        var indexes = [Int]()
        while view.superview != nil {
            if let oneLevelUp = view.superview,
                let index = oneLevelUp.subviews.index(of: view) {
                indexes.append(index)
                view = oneLevelUp
            }
        }
        return indexes
    }
    
    func oneLevelDown(_ indexes: Array<Int>) -> UIView {
        
        var view = self
        for i in indexes.reversed() {
            let oneLevelDown = view.subviews[i]
            view = oneLevelDown
        }
        return view
    }
}

//MARK UIImageView extension cache
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
