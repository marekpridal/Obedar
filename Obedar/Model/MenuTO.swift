//
//  MenuTO.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import SwiftUI

struct MenuTO: LunchProtocol, Identifiable {
    let name: String
    let price: Double?
    let description: String?
}
