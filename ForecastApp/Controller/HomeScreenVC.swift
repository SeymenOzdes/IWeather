//
//  ViewController.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 5.03.2025.
//

import UIKit
import CoreLocation

final class HomeScreenVC: UIViewController {
    weak var collectionView: UICollectionView!
    private let locationService = LocationService()
    private let networkManager = NetworkManager()
    private var weatherModel: [WeatherModel] = []
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a city or airport"
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func loadView() {
        super.loadView()
        
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
        
        view.backgroundColor = .mainBackgroundColor

        self.navigationItem.title = "Weather"
        self.navigationItem.searchController = searchController
        collectionView.backgroundColor = .white
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        locationService.delegate = self
        
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        
        locationService.requestLocationPermission()
    }
}

extension HomeScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        cell.configureLabel(with: weather, temp_Min: weather.main.temp_min, temp_Max: weather.main.temp_max)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = weatherModel[indexPath.item]
        let weatherDetailScreen = WeatherDetailVC(weatherModel: weather)
        navigationController?.pushViewController(weatherDetailScreen, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 24, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
}

extension UIColor {
    static let themeColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    static let mainBackgroundColor = UIColor(red: 240/255, green: 244/255, blue: 250/255, alpha: 1)
}

extension HomeScreenVC: LocationServiceDelegate {
    func locationService(_: LocationService, didUpdateLocation Location: CLLocation)  {
        let latitude = Location.coordinate.latitude
        let longitude = Location.coordinate.longitude
        
        Task {
            do {
                let weatherData = try await networkManager.fetchCurrentForecast(latitude: latitude, longitude: longitude)
                weatherModel.append(weatherData)
                collectionView.reloadData()
            } catch {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func locationService(_: LocationService, didFailWithError: any Error) {
        print("location \(didFailWithError)")
    }
}
