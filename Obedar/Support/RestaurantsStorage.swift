//
//  RestaurantsStorage.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
import SwiftUI

final class RestaurantsStorage {
    private(set) var restaurants = CurrentValueSubject<[RestaurantTO], Error>([])
    private var restaurantsValue: [RestaurantTO] = []

    var restaurantsLocal: [RestaurantTO] {
        return [
            RestaurantTO(type: nil, id: "U Pětníka", title: "U Pětníka", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.104388), longitude: CLLocationDegrees(14.396266))),
            RestaurantTO(type: nil, id: "Na Urale", title: "Na Urale", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.102587), longitude: CLLocationDegrees(14.402206))),
            RestaurantTO(type: nil, id: "Na Slamníku", title: "Na Slamníku", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.103652), longitude: CLLocationDegrees(14.408320))),
            RestaurantTO(type: nil, id: "U Topolů", title: "U Topolů", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.106742), longitude: CLLocationDegrees(14.394968))),
            RestaurantTO(type: nil, id: "Cesta časem", title: "Cesta časem", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.106419), longitude: CLLocationDegrees(14.386867))),
            RestaurantTO(type: nil, id: "Bistro Santinka", title: "Bistro Santinka", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.106694), longitude: CLLocationDegrees(14.388263))),
            RestaurantTO(type: nil, id: "Pod Juliskou", title: "Pod Juliskou", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.110703), longitude: CLLocationDegrees(14.393790))),
            RestaurantTO(type: nil, id: "Pod Loubím", title: "Pod Loubím", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.100329), longitude: CLLocationDegrees(14.387902))),
            RestaurantTO(type: nil, id: "Studentský dům", title: "Studentský dům", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.105499), longitude: CLLocationDegrees(14.388991))),
            RestaurantTO(type: nil, id: "Pizzerie la fontanella", title: "Pizzerie la fontanella", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.105499), longitude: CLLocationDegrees(14.388991))),
            RestaurantTO(type: nil, id: "Masarykova kolej", title: "Masarykova kolej", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.100985), longitude: CLLocationDegrees(14.387003)))
        ]
    }

    deinit {
        print("Deinit of \(self)")
    }

    func add(restaurant: RestaurantTO) {
        restaurantsValue.append(restaurant)
        restaurants.send(restaurantsValue)
    }
}
