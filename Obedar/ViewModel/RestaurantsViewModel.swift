//
//  RestaurantsViewModel.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

class RestaurantsViewModel {
    
    var restaurants = Variable<[RestaurantTO]>([])
    var restaurantsId = Variable<[RestaurantTO]>([])
    private let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
        refreshRestaurants()
    }
    
    func refreshRestaurants() {
        restaurantsId.value = Networking.restaurantsLocal
    }
    
    private func setupBinding() {
        restaurantsId.asObservable().subscribe(onNext: { [weak self] (restaurantsId) in
            self?.restaurants.value.removeAll()
            restaurantsId.forEach({ (restaurantId) in
                print("Getting menu for \(restaurantId.id)")
                Networking.getMenu(for: restaurantId, completionHandler: { [weak self] (restaurant, error) in
                    guard let `self` = self else { return }
                    if let restaurant = restaurant {
                        self.restaurants.value.append(restaurant)
                    }
                })
            })
        }).disposed(by: disposeBag)
    }
}
