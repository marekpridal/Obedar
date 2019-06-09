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
            //RestaurantDetailView()
        }
    }
}

#if DEBUG
// swiftlint:disable type_name
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
// swiftlint:enable type_name
#endif
