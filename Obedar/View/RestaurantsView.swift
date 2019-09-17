//
//  RestaurantsView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Combine
import SwiftUI

struct RestaurantsView: View {
    @ObservedObject var model: RestaurantsViewModel

    var body: some View {
        List(model.restaurants) { restaurant in
            Section {
                NavigationLink(destination: RestaurantDetailView(model: RestaurantDetailViewModel(restaurant: restaurant))) {
                    RestaurantRow(restaurant: restaurant)
                }
            }
        }
        .alert(isPresented: $model.showError, content: { () -> Alert in
            return Alert(title: Text("ERROR_TITLE"),
                         message: Text(model.error?.localizedDescription ?? "GENERAL_ERROR"),
                         primaryButton: Alert.Button.default(Text("RETRY"),
                                                             action: { self.model.refreshRestaurants() }),
                         secondaryButton: Alert.Button.cancel())
        })
        .navigationBarTitle(Text("RESTAURANT_VIEW_CONTROLLER"), displayMode: NavigationBarItem.TitleDisplayMode.large)
        .navigationBarItems(trailing: Button(action: {
            self.model.showMap = true
        }, label: {
            Image(systemName: "map")
        }).sheet(isPresented: $model.showMap) {
            FullscreenMapView(viewModel: FullscreenMapViewModel(restaurants: self.model.restaurants, delegate: self.model as? FullscreenMapViewModelDelegate))
        })
    }
}

#if DEBUG
struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RestaurantsViewModel()
        return RestaurantsView(model: viewModel)
    }
}
#endif
