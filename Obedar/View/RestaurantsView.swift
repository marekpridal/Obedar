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
            // Unable to use model.didChange.value instead of model.restaurants, no idea why
            List(model.restaurants) { restaurant in
                Section() {
                    NavigationButton(destination: RestaurantDetailView(model: RestaurantDetailViewModel(restaurant: restaurant))) {
                        RestaurantRow(restaurant: restaurant)
                    }
                }
            }
            .presentation($model.showError.binding, alert: { () -> Alert in
                return Alert(title: Text("ERROR_TITLE"), message: Text(model.error?.localizedDescription ?? "GENERAL_ERROR"), primaryButton: Alert.Button.default(Text("RETRY"), onTrigger: {
                    self.model.refreshRestaurants()
                }), secondaryButton: Alert.Button.cancel())
            })
            .navigationBarTitle(Text("RESTAURANT_VIEW_CONTROLLER"), displayMode: NavigationBarItem.TitleDisplayMode.large)
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
