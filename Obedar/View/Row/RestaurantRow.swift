//
//  RestaurantRow.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct RestaurantRow : View {
    let restaurant: RestaurantTO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text((restaurant.title ?? "")).font(.title)
            Group {
                Text((restaurant.meals?.first?.name ?? "")).font(.subheadline)
                Text((restaurant.meals?.first?.price?.currency ?? "")).font(.subheadline)
            }
        }
        .lineLimit(nil)
        .padding(20)
    }
}

#if DEBUG
struct RestaurantRow_Previews : PreviewProvider {
    static var previews: some View {
        RestaurantRow(restaurant: RestaurantTO(type: "Type", id: "Id", title: "title", cached: nil, web: nil, soups: [], meals: [MealTO(name: "Jídlo", price: 100.50)], menu: [MenuTO(name: "Menu", price: 200.01, description: "Popis")], GPS: nil))
    }
}
#endif
