//
//  UTils.swift
//  LetsTeamApp
//
//  Created by admin on 8/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class Utills {
    
    
    
    static let shared = Utills()
    
    
   
    func dateToFlatString() -> String {
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyy"
        
        
        return  df.string(from: date)
        
    } 
    func dateToString(date:Date) -> String {
        
       
        //let df = DateFormatter()
        //df.dateFormat = "yyyy-mm-ddThh:mm:ss.ffffff"
       
        //var timeStampSTR = date.timeIntervalSince1970
        return  date.iso8601 //String(timeStampSTR)
        
    }
    
    func stringToDate(date:String) -> Date {
        
        //let df = DateFormatter()
        //df.dateFormat = "yyyy-mm-ddThh:mm:ss.ffffff"
        
        
        return  date.dateFromISO8601! //df.date(from: date)!
        
    }
    
    func ISOstringToDate(date:String) -> Date {
        
        let df = ISO8601DateFormatter()
        //df.dateFormat = "yyyy-mm-ddThh:mm:ss.ffffff"
        
        
        return  df.date(from: date)!
        
    }
    
    func getStringFromTimeStamp(timetamp: NSNumber) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timetamp.doubleValue/1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.current.identifier) as Locale!
        let dateString = dateFormatter.string(from: date)
        
        return dateString
        
    }
    
   
}
extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension UIButton {
    func loadingIndicator(show: Bool) {
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            for view in self.subviews {
                if let indicator = view as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
    }
}
