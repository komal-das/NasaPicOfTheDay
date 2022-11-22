//
//  ViewController.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var apodTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    
    /// ViewModel
    let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchApodApi(Utility.getCurrentDateString())
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let top = view.safeAreaInsets.top
        titleViewHeightConstraint.constant = top + 60
    }
}

private extension HomeViewController {
    /// Initial set up
    func setUp() {
        self.navigationItem.title = "Picture Of The Day"
        homeViewModel.delegate = self
        errorView.isHidden = true
        registerCells()
        apodTableView.estimatedRowHeight = AppConstant.HomeViewConstant.estimatedRowHeight
        apodTableView.rowHeight = UITableView.automaticDimension
    }
    
    /// Register Tableview Cell
    func registerCells() {
        apodTableView.register(UINib(nibName: AppConstant.ViewIdentifier.apodTableViewCell,
                                     bundle: nil),
                                forCellReuseIdentifier: AppConstant.ViewIdentifier.apodTableViewCell)
    }
    
    /// Fetch API
    /// - Parameter selectedDate: selectedDate
    func fetchApodApi(_ selectedDate: String) {
        handleLoader(isLoaded: false)
        homeViewModel.fetchAPOD(selectedDate)
    }
    
    /// Handle Loader
    /// - Parameter isLoaded: isLoaded
    func handleLoader(isLoaded: Bool) {
        activityIndicator.isHidden = isLoaded
        apodTableView.isHidden = !isLoaded
        errorView.isHidden = true
        view.isUserInteractionEnabled = isLoaded
    }
    
    /// Handle Error
    /// - Parameter error: errorType
    func handleError(error: CustomError) {
        errorView.isHidden = false
        if error == .invalidRequest {
            errorView.configure(description: AppConstant.HomeViewConstant.somethingWentWrong)
        } else {
            errorView.configure(description: error.errorMessage)
        }
        
    }
}

// MARK: - TableView Methods
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeViewModel.apodData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApodTableViewCell", for: indexPath) as? ApodTableViewCell
        cell?.apodData = homeViewModel.apodData[indexPath.row]
        return cell ?? UITableViewCell()
    }
}

// MARK: - HomeViewModelDelegate Methods
extension HomeViewController: HomeViewModelDelegate {
    func didSuccessWithResponse(isLastShownData: Bool) {
        handleLoader(isLoaded: true)
        apodTableView.reloadData()
        if isLastShownData {
            errorView.isHidden = false
            errorView.configure(description: AppConstant.HomeViewConstant.lastShownDataInfo)
        }
    }
    
    func didFailWithError(error: CustomError) {
        handleLoader(isLoaded: true)
        handleError(error: error)
    }
}
