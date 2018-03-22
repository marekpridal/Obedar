//
//  RestaurantDetailHeaderView.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import Reusable

class RestaurantDetailHeaderView: UIView, NibReusable {

    @IBOutlet weak var title: UILabel!
    
    func setup(with title:String) {
        self.title.text = title
        self.backgroundColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
    }
}
