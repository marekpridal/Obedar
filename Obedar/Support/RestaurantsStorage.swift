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
        restaurantsValue.append(restaurant)
        restaurants.send(restaurantsValue)
    }
}
