//
//  Extensions.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import UIKit

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

extension UIViewController
{
    var contents: UIViewController?
    {
        if let splitVC = self as? UISplitViewController,let navVC = splitVC.viewControllers.first as? UINavigationController
        {
            print("split")
            return navVC.visibleViewController ?? self
        }else
        {
            print("None")
            return self
        }
    }
    
    var content: UIViewController
    {
        if let navVC = self as? UINavigationController
        {
            return navVC.visibleViewController ?? self
        }else
        {
            return self
        }
    }
}
