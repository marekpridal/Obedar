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
}
