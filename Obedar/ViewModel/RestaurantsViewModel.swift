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

final class RestaurantsViewModel: BindableObject {
    
    var didChange = CurrentValueSubject<[RestaurantTO], Never>([])

    var restaurants: [RestaurantTO] = []
    var restaurantsId: [RestaurantTO] = []
    var error: Error? {
        didSet {
            showError = error != nil
        }
    }
    var showError: Bool = false
    
    private var restaurantsSubscriptions: AnyCancellable?
    private var restaurantsSink: Subscribers.Sink<CurrentValueSubject<[RestaurantTO], Error>>?
    
    init() {
        refreshRestaurants()
    }
    
    deinit {
        restaurantsSink?.cancel()
    }
    
    func refreshRestaurants() {
        restaurantsSubscriptions = Networking.storage.restaurants
            .handleEvents(receiveCompletion: { [weak self] (completion) in
                print(completion)
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            })
            .catch({ [weak self] (error) -> Publishers.Just<[RestaurantTO]> in
                self?.error = error
                return Publishers.Just<[RestaurantTO]>([])
            })
//      .print()
//      .subscribe(on: RunLoop.current) Not working in first xcode beta
        .subscribe(didChange)
        
        // Workaround because cannot use didChange.value in RestaurantsView
        restaurantsSink = Networking.storage.restaurants
            .sink(receiveCompletion: { [weak self] (completion) in
                print(completion)
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] restaurants in
                self?.restaurants = restaurants.filter { $0.hasData() }
            })

        restaurantsId = Networking.restaurantsLocal
        restaurantsId.forEach({ (restaurantId) in
            print("Getting menu for \(restaurantId.id)")
            Networking.getMenu(for: restaurantId)
        })
    }
}
