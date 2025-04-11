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
    // private var weatherModel = WeatherModel.mockWeatherData
    private let locationService = LocationService()
    private let networkManager = NetworkManager()
    private var realWeatherModel: [WeatherModel]? = []// MARK: Buna çevrilecek
    
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
        realWeatherModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < realWeatherModel?.count ?? 0 else {
            print("HATA: Geçersiz indexPath.item: \(indexPath.item), weatherModel.count: \(realWeatherModel?.count ?? 0)")
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCollectionViewCell
        // let weather = weatherModel[indexPath.item]
        let realWeather = realWeatherModel?[indexPath.item]
        // print(weather)
        cell.configureLabel(with: realWeather!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weather = realWeatherModel?[indexPath.item]
        let weatherDetailScreen = WeatherDetailVC(weatherModel: weather!)
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
                realWeatherModel?.append(weatherData)
                collectionView.reloadData()
                print(weatherData)
                
            } catch {
                print("error \(error)")
            }
        }
    }
    
    func locationService(_: LocationService, didFailWithError: any Error) {
        print("location \(didFailWithError)")
    }
}
