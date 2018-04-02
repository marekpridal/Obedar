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
    var restaurantsId = Variable<[String]>([])
    private let disposeBag = DisposeBag()
    
    init() {
        setupBinding()
        refreshRestaurants()
    }
    
    func refreshRestaurants() {
        restaurantsId.value = Networking.restaurantsLocal.map{ $0.id }
        
        /*
        Networking.getRestaurants { [weak self] (restaurantsId, error) in
            if let restaurantsId = restaurantsId {
                self?.restaurantsId.value = restaurantsId
            }
        }
         */
    }
    
    private func setupBinding() {
        Networking.restaurantsLocal.forEach { [weak self] (restaurantLocal) in
            self?.restaurants.value.removeAll()
            print("Getting menu for \(restaurantLocal.id)")
            Networking.getMenu(for: restaurantLocal, completionHandler: { [weak self] (restaurant, error) in
                guard let `self` = self else { return }
                if let restaurant = restaurant, restaurant.hasFetched() {
                    self.restaurants.value.append(restaurant)
                } else {
                    print("Cannot get data for \(restaurantLocal.id) with error \(error?.localizedDescription ?? "")")
                }
            })
        }
        
        /*
        restaurantsId.asObservable().subscribe(onNext: { [weak self] (restaurantsId) in
            self?.restaurants.value.removeAll()
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
         */
    }
}
