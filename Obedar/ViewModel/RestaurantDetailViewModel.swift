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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.didChange.send(self.restaurant)
            }
        }
    }

    init(restaurant: RestaurantTO) {
        self.restaurant = restaurant
    }
}
