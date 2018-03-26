//
//  RestaurantDetailViewModel.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

class RestaurantDetailViewModel {
    
    let disposeBag = DisposeBag()
    let data = Variable<RestaurantTO>(RestaurantTO(type: nil, id: "", title: nil, cached: nil, web: nil, soups: [], meals: [], menu: []))
    
    init() {
        data.asObservable().filter{ $0.hasData() && !$0.id.isEmpty && $0.web?.absoluteString.isEmpty ?? true }.subscribe(onNext: { [weak self] (restaurant) in
            self?.getRestaurantDetails(for: restaurant)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    private func getRestaurantDetails(for restaurant:RestaurantTO) {
        Networking.getRestaurantDetail(for: restaurant) { [weak self] (restaurant, error) in
            print(restaurant?.web ?? "no web")
            self?.data.value = restaurant!
        }
    }
}
