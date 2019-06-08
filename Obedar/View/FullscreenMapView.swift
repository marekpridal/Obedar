//
//  FullscreenMapView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct FullscreenMapView : View {
    let restaurants: [RestaurantTO]
    
    var body: some View {
        NavigationView {
            MapViewRepresentable(restaurants: restaurants)
                .navigationBarTitle(Text("MAP"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    print("Pressed")
                }, label: {
                    Text("DISMISS")
                }))
        }
    }
}

#if DEBUG
struct FullscreenMapView_Previews : PreviewProvider {
    static var previews: some View {
        FullscreenMapView(restaurants: [])
    }
}
#endif
