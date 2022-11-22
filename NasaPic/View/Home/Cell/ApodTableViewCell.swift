//
//  ApodTableViewCell.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import UIKit

class ApodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nasaImageView: UIImageView!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    var apodData: Apod? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUp()
    }
    
    /// Initial set up of view
    private func setUp() {
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        dateStackView.layer.borderWidth = 2
        dateStackView.layer.borderColor = UIColor.systemBlue.cgColor
        dateStackView.layer.cornerRadius = 8
        dateStackView.clipsToBounds = true
    }
    
    /// configureCell
    func configureCell() {
        guard let item = apodData else { return }
        var imageUrl: String?
        if item.mediaType == .video {
            imageUrl = item.thumbnailUrl
        } else {
            imageUrl = item.url
        }
        if let imageStr = imageUrl, let url = URL(string: imageStr) {
            nasaImageView.load(url: url, placeholder: UIImage(named: "placeholder"))
        } else {
            nasaImageView.image = UIImage(named: "placeholder")
        }
        titleLabel.text = item.title
        descriptionLabel.text = item.explanation
        titleLabel.text = item.title
        let date = Utility.splitDateString(strDate: item.date)
        yearLabel.text = date.year
        monthLabel.text = date.month
        dayLabel.text = date.day
    }
    
}
