//
//  RestaurantDetailView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct RestaurantDetailView: View {
    @ObjectBinding var model: RestaurantDetailViewModel

    var body: some View {
        List {
            if model.restaurant.soups?.count ?? 0 > 0 {
                Section(header: MealSection(title: "SOUP")) { () -> ForEach<[SoupTO], MealRow<SoupTO>> in
                    ForEach((model.restaurant.soups ?? [])) { soup -> MealRow<SoupTO> in
                        MealRow(meal: soup)
                    }
                }
            }
            if model.restaurant.meals?.count ?? 0 > 0 {
                Section(header: MealSection(title: "MAIN_COURSE")) { () -> ForEach<[MealTO], MealRow<MealTO>> in
                    ForEach((model.restaurant.meals ?? [])) { meal -> MealRow<MealTO> in
                        MealRow(meal: meal)
                    }
                }
            }
            if model.restaurant.menu?.count ?? 0 > 0 {
                Section(header: MealSection(title: "MENU")) { () -> ForEach<[MenuTO], MealRow<MenuTO>> in
                    ForEach(model.restaurant.menu ?? []) { meal -> MealRow<MenuTO> in
                        MealRow(meal: meal)
                    }
                }
            }
        }
        .navigationBarTitle(Text((model.restaurant.title ?? "")), displayMode: .automatic)
    }
}

#if DEBUG
// swiftlint:disable type_name
struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(model: RestaurantDetailViewModel(restaurant: RestaurantTO(type: nil, id: "id", title: "title", cached: nil, web: nil, soups: [SoupTO(name: "Polívka", price: 50.5)], meals: [MealTO(name: "Hlavní jídlo", price: 150.55)], menu: [MenuTO(name: "Menu", price: 250.66, description: "Popis")], GPS: nil)))
    }
}
// swiftlint:enable type_name
#endif
