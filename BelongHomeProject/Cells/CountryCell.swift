//
//  CountryCell.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    // MARK: - Properties
    
    private var country: Country! {
        didSet { configure() }
    }
    
    private var cellIndex: Int!

    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        self.flagImageView.image = AppConstants.defaultFlagImage
        self.countryNameLabel.text = country.name
        try? CountryManager.flagImage(forCountry: country, index: self.cellIndex) { [weak self] (image, index) in
            // Make sure that the index is identical to the one we started with - so we don't end up displaying the wrong flag upon a fast scroll.
            guard self?.cellIndex == index else { return }
            self?.flagImageView.image = image
        }
    }
    
    private func applyDesign() {
        flagImageView.layer.cornerRadius = flagImageView.frame.height / 2
    }
    
    // MARK: - Public Methods
    
    public func provide(_ country: Country, cellIndex: Int) {
        self.cellIndex = cellIndex
        self.country = country
    }
}
