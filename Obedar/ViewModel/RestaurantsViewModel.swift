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
    
    var restaurants = BehaviorSubject<[RestaurantTO]>(value: [])
    var restaurantsId = Variable<[RestaurantTO]>([])
    var error = BehaviorSubject<[Error]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
    }
    
    func refreshRestaurants() {
        restaurantsId.value = Networking.restaurantsLocal
    }
    
    private func setupBinding() {
        restaurantsId.asObservable().subscribe(onNext: { [weak self] (restaurantsId) in
            self?.restaurants.onNext([])
            self?.error.onNext([])
            restaurantsId.forEach({ (restaurantId) in
                print("Getting menu for \(restaurantId.id)")
                Networking.getMenu(for: restaurantId, completionHandler: { [weak self] (restaurant, error) in
                    guard let `self` = self else { return }
                    if let restaurant = restaurant, var restaurants = try? self.restaurants.value() {
                        restaurants.append(restaurant)
                        self.restaurants.onNext(restaurants)
                    } else if let error = error, var errors = try? self.error.value() {
                        errors.append(error)
                        self.error.onNext(errors)
                    }
                })
            })
        }).disposed(by: disposeBag)
    }
}
