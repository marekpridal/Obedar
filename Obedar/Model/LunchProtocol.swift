//
//  LunchProtocol.swift
//  Obedar
//
//  Created by Marek Pridal on 08/06/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import SwiftUI

protocol LunchProtocol: Identifiable {
    var id: Int { get }
    var name: String { get }
    var price: Double? { get }
}

extension LunchProtocol {
    var id: Int {
        name.hashValue
    }
}
