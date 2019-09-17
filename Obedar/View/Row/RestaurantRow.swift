//
//  RestaurantRow.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct RestaurantRow: View {
    let restaurant: RestaurantTO

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text((restaurant.title ?? ""))
                .font(.system(size: 30))
                .fontWeight(.bold)

            Text((restaurant.meals?.first?.name ?? ""))
                .font(.system(size: 14))
                .fontWeight(.medium)

            HStack {
                Spacer()
                Text((restaurant.meals?.first?.price?.currency ?? ""))
                    .font(.system(size: 22))
                    .fontWeight(.bold)
            }
        }
        .lineLimit(nil)
        .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
    }
}

#if DEBUG
struct RestaurantRow_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRow(restaurant: RestaurantTO(type: "Type", id: "Id", title: "title", cached: nil, web: nil, soups: [], meals: [MealTO(name: "Jídlo", price: 100.50)], menu: [MenuTO(name: "Menu", price: 200.01, description: "Popis")], GPS: nil))
    }
}
#endif
