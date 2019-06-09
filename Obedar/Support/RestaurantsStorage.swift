//
//  RestaurantsStorage.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class RestaurantsStorage {
    private(set) var restaurants = CurrentValueSubject<[RestaurantTO], Error>([])
    private var restaurantsValue: [RestaurantTO] = []

    deinit {
        print("Deinit of \(self)")
    }

    func add(restaurant: RestaurantTO) {
        DispatchQueue.main.async { [weak self] in
            // Need to send stream on main thread and in Xcode beta 1 doesnt  work reveive(on:) operator
            guard let self = self else { return }
            self.restaurantsValue.append(restaurant)
            self.restaurants.send(self.restaurantsValue)
        }
    }
}
