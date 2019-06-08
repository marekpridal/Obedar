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

class RestaurantsViewModel: BindableObject {
    
    var didChange = PassthroughSubject<Void, Never>()

    var restaurants: [RestaurantTO] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.didChange.send(())
            }
        }
    }
    var restaurantsId: [RestaurantTO] = []
    var error: Error?
    
    init() {
        refreshRestaurants()
    }
    
    func refreshRestaurants() {
        restaurantsId = Networking.restaurantsLocal
        restaurantsId.forEach({ (restaurantId) in
            print("Getting menu for \(restaurantId.id)")
            Networking.getMenu(for: restaurantId, completionHandler: { [weak self] (restaurant, error) in
                if let restaurant = restaurant {
                    //print("Got menu for \(restaurant.title ?? "")")
                    self?.restaurants.append(restaurant)
                    self?.restaurants.sort(by: { $0.title ?? "" < $1.title ?? "" })
                } else if let error = error {
                    self?.error = error
                }
            })
        })
    }
}
