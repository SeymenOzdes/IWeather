//
//  ViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 5.03.2025.
//

import UIKit

class HomeScreenVC: UIViewController {

    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a city or airport"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Weather"
        self.navigationItem.searchController = searchController
    }
    
    func setUp() {

    }


}

