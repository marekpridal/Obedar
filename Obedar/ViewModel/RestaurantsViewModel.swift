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
    
    private var restaurants = Variable<[RestaurantTO]>([])
    private var restaurantsId = Variable<[String]>([])
    private let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
        Networking.getRestaurants { [weak self] (restaurantsId, error) in
            if let restaurantsId = restaurantsId {
                self?.restaurantsId.value = restaurantsId
            }
        }
    }
    
    private func setupBinding() {
        restaurantsId.asObservable().subscribe(onNext: { (restaurantsId) in
            restaurantsId.forEach({ (restaurantId) in
                print("Getting menu for \(restaurantId)")
                Networking.getMenu(for: restaurantId, completionHandler: { [weak self] (restaurant, error) in
                    guard let `self` = self else { return }
                    if let restaurant = restaurant {
                        self.restaurants.value.append(restaurant)
                    }
                })
            })
        }).disposed(by: disposeBag)
        
        restaurants.asObservable().subscribe(onNext: { (restaurants) in
            print(restaurants.debugDescription)
        }).disposed(by: disposeBag)
    }
}
