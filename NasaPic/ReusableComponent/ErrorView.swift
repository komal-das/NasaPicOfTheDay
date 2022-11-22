//
//  ErrorView.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import UIKit

/// display error UI in view controllers
final class ErrorView: UIView {
    
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var errorDescriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    /// Function to configure description
    func configure(description: String?) {
        errorDescriptionLabel.text = description
    }

    // MARK:- Custom methods
    /// Load nib view for no internet connection
    private func loadView() {
        Bundle.main.loadNibNamed(AppConstant.ViewIdentifier.errorViewNibName,
                                 owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
