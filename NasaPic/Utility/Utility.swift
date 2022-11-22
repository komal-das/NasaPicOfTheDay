//
//  Utility.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation

class Utility {
    
    class func splitDateString(strDate: String) -> (year: String, month: String, day: String) {
        let strArray = strDate.components(separatedBy: "-")
        guard strArray.count == 3 else { return ("","","") }
        return (strArray[0], getMonthFromDateString(strDate), strArray[2])
    }
    
    private class func getMonthFromDateString(_ strDate: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = AppConstant.DateFormat.yearMonthDay
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = AppConstant.DateFormat.monthName
        return outputDateFormatter.string(from: inputDateFormatter.date(from: strDate) ?? Date())
    }
    
    class func getCurrentDateString() -> String {
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = AppConstant.DateFormat.yearMonthDay
        return outputDateFormatter.string(from: Date())
    }
}

