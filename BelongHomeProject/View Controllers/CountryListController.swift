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
            tableView.reloadData()
        }
    }
    
    private var didFetch: Bool = false

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCellIndexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "toDetail", let dest = segue.destination as? CountryDetailController {
                dest.country = countries[selectedCellIndexPath.row]
            }
        }
    }
    
    // MARK: - Methods

    private func fetchCountries() {
        CountryManager.fetchCountries { [weak self] result in
            switch result {
                case .success(let countries):
                    self?.countries = countries
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    // MARK: - User Interaction
    
    @IBAction func addTapped(_ sender: Any) {
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
