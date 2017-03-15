//
//  Extensions.swift
//  Extensions
//
//  Created by James Rochabrun on 3/14/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//MARK - Array extensions

extension Array {
    
    //most common string in array
    func mostCommonNameIn(array: [String]) -> String {
        
        //1 GET THE COUNT FOR EACH ITEM IN THE ARRAY
        var nameCountDictionary = [String: Int]()
        for name in array {
            if let count = nameCountDictionary[name] {
                nameCountDictionary[name] = count + 1
            } else {
                nameCountDictionary[name] = 1
            }
        }
        //2 RETURN THE MOST COMMON NAME
        var mostCommonName = ""
        
        for key in nameCountDictionary.keys {
            if mostCommonName == "" {
                mostCommonName = key
            } else {
                if let count = nameCountDictionary[key] {
                    if count > nameCountDictionary[mostCommonName]! {
                        mostCommonName = key
                    }
                }
            }
        }
        return mostCommonName
    }
    
    func reverse() -> Array<Any> {
        
        var reverseArray = [Any]()
        for i in 0..<self.count {
            reverseArray.append(self[(self.count - 1) - i] as Any)
        }
        return reverseArray
    }
    
//    func convertInArray() -> Array<Any> {
//        return self.characters.map { String($0) }
//    }
    
}

//MARK - STRING extensions
extension String {
    
    func reverse() -> String {
        return  (String(self.characters.reversed()))
    }
    
    func length() -> Int {
        return self.characters.count
    }
    
    func convertInArray() -> Array<Any> {
        return self.characters.map { String($0) }
    }
    
    func isPalindrome() -> Bool {
        var isPalindrome = false
        let array = self.convertInArray()
        
        for i in 0 ..< array.count / 2 {
            
            if array[i] as? String == array[((array.count - 1) - i)] as? String {
                isPalindrome = true
            } else {
                isPalindrome = false
                break
            }
        }
        return isPalindrome
    }
    
    //pass the width of the view and the font used on it, perfect for layout cells height and textviews.
    func estimatedSizeBasedOn(width: CGFloat, and font: UIFont) -> CGSize {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return CGSize(width: width, height: estimatedFrame.height + 20)
    }
    
    
}

//MARK: - Date Extensions

extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func getAllDaysInMonth() -> [Date] {
        
        let calendar = Calendar.current
        let normalizeStartDate = self.startOfMonth()
        let normalizedEndDate = self.endOfMonth()
        var dates = [normalizeStartDate]
        var date = normalizeStartDate
        repeat {
            date = calendar.date(byAdding: .day,
                                 value: 1,
                                 to: date)!
            
            dates.append(date as Date)
            
        } while !calendar.isDate(date as Date,
                                 inSameDayAs: normalizedEndDate)
        return dates
    }
    
    func getCurrentYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}






