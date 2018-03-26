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

class RestaurantsViewController: UITableViewController {
    
    //MARK: Model
    let model = RestaurantsViewModel()
    
    //MARK: Rx
    let disposeBag = DisposeBag()
    
    //MARK: Properties
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let searchController = UISearchController(searchResultsController: nil)
    let pullToRefresh = UIRefreshControl()
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        setup(activityIndicator: activityIndicator)
        setupBinding()
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: RestaurantCell.self)
        
        self.title = "RESTAURANT_VIEW_CONTROLLER".localized
    }
    
    private func setup(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = activityIndicator
    }
    
    private func setupBinding() {
        model.restaurants.asObservable().observeOn(MainScheduler.instance).filter{ $0.filter{ $0.hasData() }.count > 0 && $0.filter{ $0.hasData() }.count != self.tableView.numberOfRows(inSection: 0) }.subscribe { [weak self] (_) in
            guard let `self` = self else { return }
            print("Reload data")
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.pullToRefresh.endRefreshing()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }.disposed(by: disposeBag)
    }
    
    private func setupUI() {
        //setupSearchController()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        pullToRefresh.attributedTitle = NSAttributedString(string:"REFRESH".localized)
        self.refreshControl = pullToRefresh
        
        pullToRefresh.rx.controlEvent(UIControlEvents.valueChanged).bind {
            [weak self] in
            self?.model.refreshRestaurants()
        }.disposed(by: disposeBag)
    }
    
    private func setupSearchController() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationController?.navigationBar.prefersLargeTitles = true
        }else {
            tableView.tableHeaderView = searchController.searchBar
            self.tableView.contentOffset = CGPoint(x: 0.0,y: 55.0)
        }
    }

}
//MARK: Table view delegate
extension RestaurantsViewController {
    
}
//MARK: Table view data source
extension RestaurantsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model.restaurants.value.count <= indexPath.row {
            return UITableViewCell()
        }
        let cell:RestaurantCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setupCell(with: model.restaurants.value.filter{ $0.hasData() }[indexPath.row], delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.restaurants.value.filter{ $0.hasData() }.count
    }
}

extension RestaurantsViewController : RestaurantCellDelegate {
    func didSelectRestaurant(restaurant: RestaurantTO, cell: UITableViewCell) {
        let detail = RestaurantDetailViewController.instantiate()
        detail.model.data.value = restaurant
        navigationController?.pushViewController(detail, animated: true)
        print(restaurant)
    }
}

//MARK: Search Delegate
extension RestaurantsViewController: UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
