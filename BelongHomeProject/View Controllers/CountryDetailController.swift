//
//  CountryDetailController.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import UIKit

class CountryDetailController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    /// Extra :)
    @IBOutlet weak var populationLabel: UILabel!
    
    // MARK: - Properties
    
    public var country: Country!
    public var flagImage: UIImage?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        archiveCountry()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyDesign()
    }
    
    // MARK: - Configuration
    
    private func configureScene() {
        title = country.name
        populationLabel.text = "Population: \(country.populationString)"
        flagImageView.image = CacheService.shared.get(forKey: country.flagURL ?? "") ?? AppConstants.defaultFlagImage
    }
    
    private func applyDesign() {
        flagImageView.layer.cornerRadius = 8.0
    }
    
    // MARK: - Archiving
    
    /// Saves the country locally if it isn't already saved.
    private func archiveCountry() {
        do {
            try LocalDatabaseManager.addCountry(self.country)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
