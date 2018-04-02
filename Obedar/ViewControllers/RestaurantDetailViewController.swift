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
import MapKit

class RestaurantDetailViewController: UIViewController {
    
    var model: RestaurantDetailViewModel?
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard model != nil else {
            tableView.isHidden = true
            return
        }
        
        navigationController?.navigationBar.tintColor = UIColor.black
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(cellType: RestaurantDetailCell.self)
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = model?.data.value.title
        
        if #available(iOS 11, *) {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        setupBinding()
    }
    
    private func setupBinding() {
        model?.data.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (restaurant) in
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
            self?.setupNavigationItems(with: restaurant)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    private func setupNavigationItems(with restaurant:RestaurantTO) {
        var items:[UIBarButtonItem] = []
        
        if let coordinate = restaurant.GPS {
            let navigate = UIBarButtonItem(image: #imageLiteral(resourceName: "navigateIcon"), style: .plain, target: nil, action: nil)
            navigate.rx.tap.bind {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                mapItem.name = restaurant.title
                mapItem.url = restaurant.web
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
                }.disposed(by: disposeBag)
            items.append(navigate)
        }
        
        navigationItem.setRightBarButtonItems(items, animated: true)
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
        case 0:
            return model?.data.value.soups?.count ?? 0 > 1 ?  model?.data.value.soups?.count ?? 0 : 1
        case 1:
            return model?.data.value.meals?.count ?? 0 > 1 ? model?.data.value.meals?.count ?? 0 : 1
        case 2:
            return model?.data.value.menu?.count ?? 0 > 1 ? model?.data.value.menu?.count ?? 0 : 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < getFoodCount(for: indexPath) {
            let cell: RestaurantDetailCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setup(title: getMenuItems(for: indexPath).name, subtitle: getMenuItems(for: indexPath).priceWithCurrency)
            cell.separator.isHidden = indexPath.row + 1 == getFoodCount(for: indexPath)
            return cell
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = "NO_DATA_FOR_CATEGORY".localized
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = RestaurantDetailHeaderView.loadFromNib()
        header.setup(with: getHeaderTitle(for: section))
        return header
    }
    
    private func getHeaderTitle(for section:Int) -> String {
        switch section
        {
        case 0:
            return "SOUP".localized
        case 1:
            return "MAIN_COURSE".localized
        case 2:
            return "MENU".localized
        default:
            return ""
        }
    }
    
    private func getMenuItems(for indexPath:IndexPath) -> (name:String?, priceWithCurrency:String?) {
        switch indexPath.section
        {
        case 0:
            return (name: model?.data.value.soups?[indexPath.row].name, priceWithCurrency: model?.data.value.soups?[indexPath.row].price.currency)
        case 1:
            return (name: model?.data.value.meals?[indexPath.row].name, priceWithCurrency: model?.data.value.meals?[indexPath.row].price.currency)
        case 2:
            return (name: model?.data.value.menu?[indexPath.row].name, priceWithCurrency: model?.data.value.menu?[indexPath.row].price?.currency)
        default:
            return (name: nil, priceWithCurrency: nil)
        }
    }
    
    private func getFoodCount(for indexPath:IndexPath) -> Int {
        switch indexPath.section
        {
        case 0:
            return model?.data.value.soups?.count ?? 0
        case 1:
            return model?.data.value.meals?.count ?? 0
        case 2:
            return model?.data.value.menu?.count ?? 0
        default:
            return 0
        }
    }
}

extension RestaurantDetailViewController : StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
