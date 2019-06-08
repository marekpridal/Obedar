//
//  Networking.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

struct Networking {
    
    private enum Constants {
        static let rootURL = URL(string: "http://obedar.fit.cvut.cz/api/v1/restaurants")!
    }
    
    static var restaurantsLocal:[RestaurantTO] {
        get {
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
                RestaurantTO(type: nil, id: "Masarykova kolej", title: "Masarykova kolej", cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: CLLocationCoordinate2D(latitude: CLLocationDegrees(50.100985), longitude: CLLocationDegrees(14.387003))),
            ]
        }
    }
    
    static func getRestaurants(completionHandler: @escaping ([String]?,Error?)->Void) {
        var request = URLRequest(url: Constants.rootURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let jsonData = try? JSON(data: data) else {
                completionHandler(nil,error)
                return
            }
            
            completionHandler(jsonData.compactMap{ $1.string },error)
        }
        
        dataTask.resume()
    }
    
    static func getMenu(for restaurant:RestaurantTO, completionHandler: @escaping (RestaurantTO?,Error?)->Void) {
        var request = URLRequest(url: Constants.rootURL.appendingPathComponent(restaurant.id).appendingPathComponent("menu"))
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let jsonData = try? JSON(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
                print(error?.localizedDescription ?? "error \(restaurant.id)")
                completionHandler(nil,error)
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
            

            var soups:[SoupTO] = []
            soupsData?.forEach({ (json) in
                soups.append(SoupTO(name: json[0].string ?? "", price: json[1].double))
            })
            
            var meals:[MealTO] = []
            mealsData?.forEach({ (json) in
                meals.append(MealTO(name: json[0].string ?? "", price: json[1].double))
            })
            
            var menu:[MenuTO] = []
            menuData?.forEach({ (json) in
                menu.append(MenuTO(name: json[0].string ?? "", price: json[1].double, description: json[1].string))
            })
            
            completionHandler(RestaurantTO(type: type, id: restaurant.id, title: title, cached: date, web: nil, soups: soups, meals: meals, menu: menu, GPS: restaurant.GPS), error)
        }
        
        dataTask.resume()
    }
    
    static func getRestaurantDetail(for restaurant:RestaurantTO, completionHandler: @escaping (RestaurantTO?,Error?) -> Void) {
        var request = URLRequest(url: Constants.rootURL.appendingPathComponent(restaurant.id))
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data,response,error) in
            
            guard let data = data, let jsonData = try? JSON(data: data), (response as? HTTPURLResponse)?.statusCode == 200 else {
                print(error?.localizedDescription ?? "error \(restaurant)")
                completionHandler(restaurant,error)
                return
            }
            var restaurant = restaurant
            restaurant.web = jsonData["data"]["attributes"]["url"].url
            completionHandler(restaurant,error)
        }
        
        dataTask.resume()
    }
}
