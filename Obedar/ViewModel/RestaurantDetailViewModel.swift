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

class RestaurantDetailViewModel: ObservableObject {
    deinit {
        print("Deinit of \(self)")
    }

    var restaurant: RestaurantTO {
        didSet {
            objectWillChange.send()
        }
    }

    init(restaurant: RestaurantTO) {
        self.restaurant = restaurant
    }
}
