//
//  MealRow.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

struct MealRow<Meal: LunchProtocol> : View {
    let meal: Meal
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Text(meal.name)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.bottom, 5)
                
                HStack {
                    Spacer()
                    Text((meal.price?.currency ?? ""))
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                }
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .lineLimit(nil)
    }
}

#if DEBUG
struct MealRow_Previews : PreviewProvider {
    static var previews: some View {
        MealRow(meal: MealTO(name: "Wrap – rozpečená tortilla plněná smaženými kuřecími stripsy, trhaným salátem a rajčaty, podávaná s bramborovými hranolky a česnekovým dipem", price: 189.99))
    }
}
#endif
