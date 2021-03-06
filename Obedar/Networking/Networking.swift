//
//  Networking.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Combine
import Foundation
import SwiftyJSON

enum Networking {
    static let storage = RestaurantsStorage()

    private enum Constants {
        static let rootURL = URL(string: "http://obedar.fit.cvut.cz/api/v1/restaurants")!
    }

    private static func getRestaurants(completionHandler: @escaping ([String]?, Error?) -> Void) {
        var request = URLRequest(url: Constants.rootURL)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, let jsonData = try? JSON(data: data) else {
                completionHandler(nil, error)
                return
            }

            completionHandler(jsonData.compactMap { $1.string }, error)
        }

        dataTask.resume()
    }

    static func getMenu(for restaurant: RestaurantTO) {
        var request = URLRequest(url: Constants.rootURL.appendingPathComponent(restaurant.id).appendingPathComponent("menu"))
        request.httpMethod = "GET"
        // swiftlint:disable closure_body_length
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let jsonData = try? JSON(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
//                print(error?.localizedDescription ?? "error \(restaurant.id)")
                if let error = error {
                    Networking.storage.restaurants.send(completion: Subscribers.Completion<Error>.failure(error))
                }
                return
            }
            let type = jsonData["data"]["type"].string
            let title = jsonData["data"]["attributes"]["title"].string
            let soupsData = jsonData["data"]["attributes"]["content"]["Polévky"].array
            let mealsData = jsonData["data"]["attributes"]["content"]["Hlavní jídla"].array
            let menuData = jsonData["data"]["attributes"]["content"]["Menu"].array

            let cached = jsonData["data"]["attributes"]["cached"].string ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let date = formatter.date(from: cached)

            var soups: [SoupTO] = []
            soupsData?.forEach({ json in
                soups.append(SoupTO(name: json[0].string ?? "", price: json[1].double))
            })

            var meals: [MealTO] = []
            mealsData?.forEach({ json in
                meals.append(MealTO(name: json[0].string ?? "", price: json[1].double))
            })

            var menu: [MenuTO] = []
            menuData?.forEach({ json in
                menu.append(MenuTO(name: json[0].string ?? "", price: json[1].double, description: json[1].string))
            })

            Networking.storage.add(restaurant: RestaurantTO(type: type, id: restaurant.id, title: title, cached: date, web: nil, soups: soups, meals: meals, menu: menu, GPS: restaurant.GPS))
        }
        // swiftlint:enable closure_body_length

        dataTask.resume()
    }

    private static func getRestaurantDetail(for restaurant: RestaurantTO, completionHandler: @escaping (RestaurantTO?, Error?) -> Void) {
        var request = URLRequest(url: Constants.rootURL.appendingPathComponent(restaurant.id))
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let jsonData = try? JSON(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
//                print(error?.localizedDescription ?? "error \(restaurant)")
                completionHandler(restaurant, error)
                return
            }
            var restaurant = restaurant
            restaurant.web = jsonData["data"]["attributes"]["url"].url
            completionHandler(restaurant, error)
        }

        dataTask.resume()
    }
}
