//
//  MealSection.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct MealSection : View {
    let title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.system(size: 30))
            .bold()
    }
}

#if DEBUG
struct MealSection_Previews : PreviewProvider {
    static var previews: some View {
        MealSection(title: "Section Title")
    }
}
#endif
