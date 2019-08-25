//
//  FullscreenMapView.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct FullscreenMapView: View {
    let viewModel: FullscreenMapViewModel

    var body: some View {
        NavigationView {
            MapViewRepresentable(restaurants: viewModel.restaurants)
                .navigationBarTitle(Text("MAP"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    print("Pressed")
                    self.viewModel.delegate?.closeFullscreenMapView()
                }, label: {
                    Text("DISMISS")
                }))
        }
    }
}

#if DEBUG
// swiftlint:disable type_name
struct FullscreenMapView_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenMapView(viewModel: FullscreenMapViewModel(restaurants: [], delegate: nil))
    }
}
// swiftlint:enable type_name
#endif
