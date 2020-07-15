//
//  CountryListController.swift
//  BelongHomeProject
//
//  Created by Eilon Krauthammer on 15/07/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import UIKit

class CountryListController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    private let cellIdentifier = "CountryCell"
    
    private var countries: [Country] = .init() {
        didSet {
            self.filteredCountries = countries
        }
    }
    
    private var filteredCountries: [Country] = .init() {
        didSet {
            modifyNoCountries(emptyBefore: oldValue.count == 0)
            tableView.reloadData()
        }
    }
    
    private var didFetch: Bool = false
    
    private lazy var noCountriesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.frame.size = .init(width: view.frame.width * 0.75, height: 100)
        label.text = "No countries yet :( \n Tap the Play button at the top to load countries from the internet!"
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        return label
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocalCountries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCellIndexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "toDetail", let dest = segue.destination as? CountryDetailController {
                dest.country = filteredCountries[selectedCellIndexPath.row]
            }
        }
    }
    
    // MARK: - Country Fetching
    
    private func loadLocalCountries() {
        countries = (try? LocalDatabaseManager.getLocalCountries()) ?? []
    }
    
    private func fetchCountries() {
        CountryManager.fetchCountries { [weak self] result in
            guard let self = self else { return }
            let _countries = self.countries
            switch result {
                case .success(let countries):
                    // Only append countries that are not saved locally
                    
                    /* Option 1
                    for country in countries where !_countries.contains(country) {
                        _countries.append(country)
                    }
                    self.countries = _countries

                    */
                
                    /* Option 2 */
                    self.countries += countries.filter { !_countries.contains($0) }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    // MARK: - UI Handling
    
    private func modifyNoCountries(emptyBefore: Bool) {
        if filteredCountries.count > 0 && emptyBefore {
            guard noCountriesLabel.isDescendant(of: view) else { return }
            noCountriesLabel.removeFromSuperview()
        } else if filteredCountries.count == 0 && !noCountriesLabel.isDescendant(of: view) {
            view.addSubview(noCountriesLabel)
            noCountriesLabel.center = .init(x: view.center.x, y: 200.0)
        }
    }
    
    // MARK: - User Interaction
    
    @IBAction func loadTapped(_ sender: Any) {
        guard !didFetch else { return }
        didFetch = true
        fetchCountries()
    }
    
}

// MARK: - Table View Delegates

extension CountryListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CountryCell
        guard let country = filteredCountries[safe: indexPath.row] else { fatalError() }
        cell.provide(country, cellIndex: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Search Bar Delegate

extension CountryListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else { filteredCountries = countries; return }
        filteredCountries = countries.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
