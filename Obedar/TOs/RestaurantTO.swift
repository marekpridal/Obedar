//
//  RestaurantTO.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation

struct RestaurantTO {
    let type:String?
    let id:String
    let title:String?
    let soups:[SoupTO]?
    let meals:[MealTO]?
    let menu:[MenuTO]?
}
