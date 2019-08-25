//
//  FullscreenMapViewModel.swift
//  Obedar
//
//  Created by Marek Přidal on 25/08/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation

protocol FullscreenMapViewModelDelegate: class {
    func closeFullscreenMapView()
}

final class FullscreenMapViewModel {
    weak var delegate: FullscreenMapViewModelDelegate?

    let restaurants: [RestaurantTO]

    init(restaurants: [RestaurantTO], delegate: FullscreenMapViewModelDelegate?) {
        self.restaurants = restaurants
        self.delegate = delegate
    }

    deinit {
        print("Deinit of \(self)")
    }
}
