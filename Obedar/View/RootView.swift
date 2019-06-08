//
//  RootView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct RootView : View {
    var body: some View {
        NavigationView {
            RestaurantsView(model: RestaurantsViewModel())
            RestaurantDetailView()
        }
    }
}

#if DEBUG
struct RootView_Previews : PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
#endif
