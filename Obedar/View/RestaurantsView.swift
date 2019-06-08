//
//  RestaurantsView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI
import Combine

struct RestaurantsView : View {
    @ObjectBinding var model: RestaurantsViewModel

    var body: some View {
        Group {
            List(model.restaurants) { restaurant in
                NavigationButton(destination: RestaurantDetailView(model: RestaurantDetailViewModel(restaurant: restaurant))) {
                    RestaurantRow(restaurant: restaurant)
                }
            }
            .navigationBarTitle(Text("Restaurants"), displayMode: NavigationBarItem.TitleDisplayMode.large)
            .navigationBarItems(trailing: PresentationButton(Image(systemName: "map"), destination: FullscreenMapView(restaurants: model.restaurants)))
        }
    }
}

#if DEBUG
struct RestaurantsView_Previews : PreviewProvider {
    static var previews: some View {
        let viewModel = RestaurantsViewModel()
        return RestaurantsView(model: viewModel)
    }
}
#endif
