//
//  RestaurantTO.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import CoreLocation

struct RestaurantTO {
    let type:String?
    let id:String
    let title:String?
    let cached:Date?
    var web:URL?
    let soups:[SoupTO]?
    let meals:[MealTO]?
    let menu:[MenuTO]?
    let GPS:CLLocationCoordinate2D?
    
    func hasData() -> Bool {
        return !(soups?.isEmpty ?? true) || !(meals?.isEmpty ?? true) || !(menu?.isEmpty ?? true)
    }
    
    func hasFetched() -> Bool {
        return soups != nil && meals != nil && menu != nil
    }
}
