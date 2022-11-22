//
//  HomeViewModel.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didSuccessWithResponse(isLastShownData: Bool)
    func didFailWithError(error: CustomError)
}

class HomeViewModel {
    
    var apodData: [Apod] = []
    weak var delegate: HomeViewModelDelegate?
    
    /// Fetch APOD API
    /// - Parameter selectedDate: selectedDate
    func fetchAPOD(_ selectedDate: String) {
        apodData.removeAll()
        guard let url = URL(string: "\(AppConstant.API.apodUrl)&start_date=\(selectedDate)&end_date=\(selectedDate)&thumbs=true") else {
            self.delegate?.didFailWithError(error: CustomError.invalidURL)
            return
        }
        NetworkHelper.sharedInstance.request(of: [Apod].self,
                                             url: url,
                                             method: .GET,
                                             parameters: nil ) { [weak self] (apodList, error) in
            guard let self = self else { return }
            
            guard let customError = error else {
                if let apodList = apodList {
                    CoreDataHelper.shared.syncApod(apodList, completion: { isSuccess in
                        if isSuccess {
                            self.fromCache(selectedDate, error: CustomError.noData)
                        } else {
                            self.delegate?.didFailWithError(error: CustomError.noData)
                        }
                    })
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.didFailWithError(error: CustomError.serverError)
                    }
                }
                return
            }
            
            if customError == .noInternet {
                self.fromCache(selectedDate, error: customError)
                return
            }
            DispatchQueue.main.async {
                self.delegate?.didFailWithError(error: customError)
            }
        }
    }
    
    /// Retrive data from COREDATA using selected date if exist else return error
    /// - Parameters:
    ///   - selectedDate: selectedDate
    ///   - error: CustomError type
    private func fromCache(_ selectedDate: String, error: CustomError) {
        CoreDataHelper.shared.getApod(forSelectedDate: selectedDate, completion: { item in
            if let item = item {
                self.apodData.append(item)
                DispatchQueue.main.async {
                    self.delegate?.didSuccessWithResponse(isLastShownData: false)
                }
            } else {
                self.fetchLastShownDatafromCache(error)
            }
        })
    }
    
    /// Retrive data from COREDATA using selected date if exist else return error
    /// - Parameters:
    ///   - error: CustomError type
    private func fetchLastShownDatafromCache(_ error: CustomError) {
        CoreDataHelper.shared.getLastShownApod(completion: { item in
            if let item = item {
                self.apodData.append(item)
                DispatchQueue.main.async {
                    self.delegate?.didSuccessWithResponse(isLastShownData: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error: error)
                }
            }
        })
    }
}
