//
//  RestaurantDetailCell.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import Reusable

class RestaurantDetailCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func setup(title: String?, subtitle: String?) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
