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
    private var restaurantsId: [RestaurantTO] = []
    var error: Error? {
        didSet {
            showError = error != nil
        }
    }
    var showError: Bool = false
    var restaurants: [RestaurantTO] = []

    private var restaurantsSubscriptions: AnyCancellable?

    init() {
        refreshRestaurants()
    }

    deinit {
        print("Deinit of \(self)")
    }

    func refreshRestaurants() {
//        restaurantsSubscriptions = Networking.storage.restaurants
//            .handleEvents(receiveCompletion: { [weak self] completion in
//                print(completion)
//                switch completion {
//                case .failure(let error):
//                    self?.error = error
//
//                case .finished:
//                    break
//                }
//            })
//            .catch({ [weak self] error -> Just<[RestaurantTO]> in
//                self?.error = error
//                return Just<[RestaurantTO]>([])
//            })
////        .print()
//        .receive(on: RunLoop.main)
//        .map { $0.filter { $0.hasData() } }
//        .filter { !$0.isEmpty }
//        .subscribe(didChange)

        // Workaround because .subscribe(didChange) doesn't work
        restaurantsSubscriptions = Networking.storage.restaurants
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                print(completion)
                switch completion {
                case .failure(let error):
                    self?.error = error

                case .finished:
                    break
                }
            }, receiveValue: { [weak self] restaurants in
                self?.objectWillChange.send()
                self?.restaurants = restaurants.filter { $0.hasData() }
            })

        restaurantsId = Networking.restaurantsLocal
        restaurantsId.forEach({ restaurantId in
            print("Getting menu for \(restaurantId.id)")
            Networking.getMenu(for: restaurantId)
        })
    }
}
