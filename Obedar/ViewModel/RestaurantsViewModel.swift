//
//  RestaurantsViewModel.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class RestaurantsViewModel: ObservableObject {
    // MARK: - ObservableObject
    let objectWillChange = PassthroughSubject<Void, Never>()

    // MARK: - Public properties
    var error: Error? {
        didSet {
            showError = error != nil
        }
    }
    var showError: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }
    var restaurants: [RestaurantTO] = []
    var showMap = false {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Private properties
    private var restaurantsSubscriptions: AnyCancellable?

    // MARK: - Lifecycle
    init() {
        refreshRestaurants()
    }

    deinit {
        print("Deinit of \(self)")
    }

    // MARK: - Public funcs
    func refreshRestaurants() {
        error = nil

        restaurantsSubscriptions = Networking.storage.restaurants
            .receive(on: RunLoop.main)
            .print()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error

                case .finished:
                    break
                }
            }, receiveValue: { [weak self] restaurants in
                guard !restaurants.filter ({ $0.hasData() }).isEmpty else { return }
                self?.objectWillChange.send()
                self?.restaurants = restaurants.filter { $0.hasData() }
                print("Has data for restaurants \(restaurants.map({ $0.title ?? "Without title" }))")
            })

        Networking.storage.restaurantsLocal.forEach({ restaurantId in
            print("Getting menu for \(restaurantId.id)")
            Networking.getMenu(for: restaurantId)
        })
    }
}

extension RestaurantsViewModel: FullscreenMapViewModelDelegate {
    func closeFullscreenMapView() {
        showMap = false
    }
}
