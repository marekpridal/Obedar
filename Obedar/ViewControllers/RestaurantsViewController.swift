//
//  RestaurantsViewController.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit

class RestaurantsViewController: UIViewController {
    
    //MARK: Model
    let model = RestaurantsViewModel()
    
    //MARK: Table view
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
