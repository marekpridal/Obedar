//
//  Extensions.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation

extension String {
    var localized:String
    {
        return NSLocalizedString(self,comment: "")
    }
}
extension Double {
    var currency:String
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.currencyCode = "CZK"
        formatter.allowsFloats = false
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
