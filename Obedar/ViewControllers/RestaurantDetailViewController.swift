//
//  RestaurantDetailViewController.swift
//  Obedar
//
//  Created by Marek Pridal on 22.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import RxSwift
import Reusable

class RestaurantDetailViewController: UIViewController {
    
    var model = RestaurantDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func setupBinding() {
        model.data.asObservable().subscribe { [weak self] (_) in
            DispatchQueue.main.async {
                
            }
        }.disposed(by: disposeBag)
    }

}

extension RestaurantDetailViewController : UITableViewDelegate {
    
}

extension RestaurantDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section
        {
        case 1:
            return model.data.value.soups?.count ?? 0
        case 2:
            return model.data.value.meals?.count ?? 0
        case 3:
            return model.data.value.meals?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension RestaurantDetailViewController : StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
