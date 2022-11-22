//
//  CustomError.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation

/// Define CustomError Type
enum CustomError: Error {
    case noInternet
    case noFavouriteRecord
    case noData
    case serverError
    case invalidResponse
    case invalidRequest
    case invalidURL
    
    /// Generate corresponding error message
    var errorMessage: String {
        switch(self) {
        case .noData:
            return "No Record Found."
        case .noFavouriteRecord:
            return "Empty favourite list. Please add favourite & check here"
        case .noInternet:
            return "It seems like you are offline. Please check your internet connection."
        case .serverError:
            return "Something went wrong. Please try again."
        case .invalidResponse:
            return "Something went wrong with data parsing."
        case .invalidRequest:
            return "Request is invalid."
        case .invalidURL:
            return "API URL is invalid."
        }
    }
}
