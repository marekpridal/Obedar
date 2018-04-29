//
//  RestaurantCell.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import Reusable

protocol RestaurantCellDelegate : class {
    func didSelectRestaurant(restaurant: RestaurantTO, cell: RestaurantCell)
}

class RestaurantCell: UITableViewCell, NibReusable {
    
    //MARK: IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    
    //MARK: Delegates
    weak var delegate:RestaurantCellDelegate?
    
    //MARK: Private properties
    private var restaurant: RestaurantTO!

    //MARK: Public funcs
    func setupCell(with restaurant:RestaurantTO, delegate: RestaurantCellDelegate?) {
        self.delegate = delegate
        self.restaurant = restaurant
        
        title.text = restaurant.title
        
        if let recommended = restaurant.meals?.first {
            subtitle1.text = recommended.name
            subtitle2.text = recommended.price.currency
        } else {
            subtitle1.text = nil
            subtitle2.text = nil
        }
    }

    //MARK: - Animations
    
    private func pushBackAnimated() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) })
    }
    
    private func resetAnimated() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform.identity })
    }
    
}
//MARK: - Gesture Delegate
extension RestaurantCell {
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didSelectRestaurant(restaurant: restaurant, cell: self)
        resetAnimated()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pushBackAnimated()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetAnimated()
    }
    
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        resetAnimated()
    }
}
