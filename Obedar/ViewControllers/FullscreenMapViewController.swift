//
//  FullscreenMapViewController.swift
//  Obedar
//
//  Created by Marek Přidal on 02.04.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxCocoa
import RxSwift
import Reusable

class FullscreenMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    let model = FullscreenMapViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        getLocation()
        setupNavigationItem()
        self.title = "MAP".localized
        
        if #available(iOS 11, *) {
            setupCompassButton()
            setupUserTrackingButtonAndScaleView()
        }
        
        model.data.asObservable().subscribe(onNext: { [weak self] (restaurants) in
            self?.addAnnotations(with: restaurants)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

    }
    
    private func setupNavigationItem() {
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "DISMISS".localized, style: .done, target: nil, action: nil), animated: true)
        
        navigationItem.leftBarButtonItem?.rx.tap.bind {
            [weak self] in
            
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    private func addAnnotations(with data: [RestaurantTO])
    {
        for restaurant in data
        {
            let coordinate = CLLocationCoordinate2D(latitude: restaurant.GPS!.latitude, longitude: restaurant.GPS!.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = restaurant.title
            map.addAnnotation(annotation)
        }
        
        let location = CLLocation(latitude: 50.102865, longitude: 14.391164)
        
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate,2000, 2000)
        
        map.setRegion(region, animated: true)
    }
    
    private func getLocation()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.requestWhenInUseAuthorization()
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                print(#function,"No access \(CLLocationManager.authorizationStatus())")
            case .authorizedAlways, .authorizedWhenInUse:
                print(#function,"Access")
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.requestLocation()
                locationManager.allowsBackgroundLocationUpdates = false
            }
        } else
        {
            print("Location services are not enabled")
        }
    }

    @available(iOS 11.0, *)
    func setupCompassButton()
    {
        let compass = MKCompassButton(mapView: map)
        compass.compassVisibility = .adaptive
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        map.showsCompass = false
    }
    
    @available(iOS 11.0, *)
    func setupUserTrackingButtonAndScaleView()
    {
        map.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: map)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: map)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
    }
}

extension FullscreenMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else
        {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(locValue,2000, 2000)
        
        map.setRegion(region, animated: true)
    }
}

extension FullscreenMapViewController: StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
