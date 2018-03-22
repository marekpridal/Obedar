//
//  RestaurantsViewController.swift
//  Obedar
//
//  Created by Marek Pridal on 21.03.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RestaurantsViewController: UIViewController {
    
    //MARK: Model
    let model = RestaurantsViewModel()
    
    let disposeBag = DisposeBag()
    
    //MARK: Table view
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupBinding()
        tableView.register(cellType: RestaurantCell.self)
        
        self.title = "RESTAURANT_VIEW_CONTROLLER".localized
        
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let detail = RestaurantDetailViewController.instantiate()
        let navigationController = UINavigationController()
        navigationController.pushViewController(detail, animated: false)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
        
        splitViewController?.showDetailViewController(detail, sender: nil)
    }
    
    private func setupBinding() {
        model.restaurants.asObservable().filter{ $0.filter{ $0.hasFetched() }.count == self.model.restaurantsId.value.count && $0.filter{ $0.hasFetched() }.count > 0 }.subscribe { [weak self] (_) in
            DispatchQueue.main.async {
                print("Reload data")
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
                self?.view.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
    }

}

extension RestaurantsViewController : UITableViewDelegate {
    
}

extension RestaurantsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RestaurantCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setupCell(with: model.restaurants.value.filter{ $0.hasData() }[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.restaurants.value.filter{ $0.hasData() }.count
    }
}

extension RestaurantsViewController : RestaurantCellDelegate {
    func didSelectRestaurant(restaurant: RestaurantTO, cell: UITableViewCell) {
        let detail = RestaurantDetailViewController.instantiate()
        detail.model.data.value = restaurant
        let navigationController = UINavigationController()
        navigationController.pushViewController(detail, animated: false)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
        print(restaurant)
    }
}

extension RestaurantsViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool
    {
        if primaryViewController.content == self
        {
            if let _  = secondaryViewController.content as? RestaurantDetailViewController
            {
                return true
            }
        }
        return false
    }
}
