//
//  AppConstant.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation

struct AppConstant {
    
    struct API {
        static let apodUrl = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
    }
    
    struct HomeViewConstant {
        static let estimatedRowHeight = 300.0
        static let somethingWentWrong = "Something went wrong"
        static let lastShownDataInfo = "You are not connected to the internet, showing you the last image we have."
    }
    
    struct ViewIdentifier {
        static let errorViewNibName = "ErrorView"
        static let apodTableViewCell = "ApodTableViewCell"
        
    }
    
    struct DateFormat {
        static let yearMonthDay = "YYYY-MM-dd"
        static let monthName = "MMM"
    }
}
