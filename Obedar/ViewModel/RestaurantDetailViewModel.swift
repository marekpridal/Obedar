//
//  RestaurantDetailViewModel.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class RestaurantDetailViewModel: BindableObject {
    var didChange = PassthroughSubject<RestaurantTO, Never>()

    deinit {
        print("Deinit of \(self)")
    }

    var restaurant: RestaurantTO {
        didSet {
            didChange.send(restaurant)
        }
    }

    init(restaurant: RestaurantTO) {
        self.restaurant = restaurant
    }
}
