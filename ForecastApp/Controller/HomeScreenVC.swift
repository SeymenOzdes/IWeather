//
//  ViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 5.03.2025.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    weak var collectionView: UICollectionView!
    private let weatherModel = WeatherModel.mockWeatherData
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a city or airport"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    // loadview ekran ilk yüklendiğinde çağrılır. init method gibi glb. Temel view'leri oluşturmak için kullanılır. View hiyerarşisine eklenen viewlar galiba.
    override func loadView() {
        super.loadView() // load view uygulamanın otomatik uiview nesnesi oluşturmasını sağlar eğer bunu yazmazsak uiview nesnesi oluşturmamız gerekir yoksa siyah ekran alırız.
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        self.collectionView = collectionView
    }
    
    // loadview sonrasında çağrılır. view üzerinde değişiklik yapabiliriz.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Weather"
        self.navigationItem.searchController = searchController
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
    }
}

extension HomeScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < weatherModel.count else {
            print("HATA: Geçersiz indexPath.item: \(indexPath.item), weatherModel.count: \(weatherModel.count)")
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCollectionViewCell
        let weather = weatherModel[indexPath.item]
        cell.configure(with: weather)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 24, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
}
