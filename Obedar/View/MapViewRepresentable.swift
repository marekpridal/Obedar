//
//  MapViewRepresentable.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import MapKit
import SwiftUI

final class MapViewRepresentable: NSObject, UIViewRepresentable {
    let restaurants: [RestaurantTO]

    private let locationManager = CLLocationManager()
    private var map: MKMapView?

    init(restaurants: [RestaurantTO]) {
        self.restaurants = restaurants
    }

    deinit {
        print("Deinit of \(self)")
    }

    func makeUIView(context: Context) -> MKMapView {
        map = MKMapView(frame: .zero)
        setupUserTrackingButtonAndScaleView(view: map!)
        getLocation()
        return map!
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        restaurants.forEach { restaurant in
            guard let latitude = restaurant.GPS?.latitude, let longitude = restaurant.GPS?.longitude else { return }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = restaurant.title
            view.addAnnotation(annotation)
        }

        let location = CLLocation(latitude: 50.102865, longitude: 14.391164)

        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)

        view.setRegion(region, animated: true)
    }

    private func getLocation() {
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print(#function, "No access \(CLLocationManager.authorizationStatus())")

            case .authorizedAlways, .authorizedWhenInUse:
                print(#function, "Access")
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.requestLocation()
                locationManager.allowsBackgroundLocationUpdates = false
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }

    private func setupUserTrackingButtonAndScaleView(view: MKMapView) {
        view.showsUserLocation = true

        let button = MKUserTrackingButton(mapView: view)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        let scale = MKScaleView(mapView: view)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
            [
             button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
             button.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
             scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
             scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)
            ])
    }
}

extension MapViewRepresentable: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let region = MKCoordinateRegion.init(center: locValue, latitudinalMeters: 2000, longitudinalMeters: 2000)

        map?.setRegion(region, animated: true)
    }
}

#if DEBUG
// swiftlint:disable type_name
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewRepresentable(restaurants: [])
    }
}
// swiftlint:enable type_name
#endif
