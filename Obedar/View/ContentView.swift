//
//  ContentView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            RestaurantsView(model: RestaurantsViewModel())
            RestaurantDetailView(model: RestaurantDetailViewModel(restaurant: RestaurantTO(type: nil, id: "id", title: nil, cached: nil, web: nil, soups: nil, meals: nil, menu: nil, GPS: nil)))
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
