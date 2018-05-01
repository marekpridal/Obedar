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
import AudioToolbox
import StoreKit

class RestaurantsViewController: UITableViewController {
    
    //MARK: Model
    let model = RestaurantsViewModel()
    
    //MARK: Rx
    private let disposeBag = DisposeBag()
    
    //MARK: Properties
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let searchController = UISearchController(searchResultsController: nil)
    private let pullToRefresh = UIRefreshControl()
    private var selectedCell: RestaurantCell? = nil
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        self.splitViewController!.delegate = self;
        self.splitViewController!.preferredDisplayMode = .allVisible
        
        setup(activityIndicator: activityIndicator)
        setupBinding()
        setupUI()
        setupAppShortcuts()
        model.refreshRestaurants()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: RestaurantCell.self)
        checkAppStoreReview()
        
        self.title = "RESTAURANT_VIEW_CONTROLLER".localized
    }
    
    private func setupAppShortcuts() {
        guard (UIApplication.shared.shortcutItems?.count ?? 0) == 0 else { return }
        
        let showMap = UIMutableApplicationShortcutItem(type: Constants.showMapShortcutItemType, localizedTitle: "SHOW_ON_MAP".localized)
        showMap.icon = UIApplicationShortcutIcon(templateImageName: "mapIcon")
        
        UIApplication.shared.shortcutItems = [showMap]
    }
    
    private func setup(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = activityIndicator
    }
    
    private func setupBinding() {
        model.restaurants.asObservable().observeOn(MainScheduler.instance).filter{ $0.filter{ $0.hasData() }.count > 0 && $0.filter{ $0.hasFetched() }.count != self.tableView.numberOfRows(inSection: 0)}.subscribe(onNext: { [weak self] (restaurants) in
            guard let `self` = self else { return }
            print("Reload data with new restaurant \(restaurants.last?.id ?? "")")
            self.tableView.reloadData()
            self.tableView.selectRow(at: self.getIndexPath(for: self.selectedCell, restaurants: restaurants), animated: false, scrollPosition: .none)
            self.tableView.isHidden = false
            if ((restaurants.filter{ $0.hasFetched() }.count + ((try? self.model.error.value().count) ?? 0)) == (self.model.restaurantsId.value.count)) {
                self.activityIndicator.stopAnimating()
                self.pullToRefresh.endRefreshing()
                AudioServicesPlaySystemSound(1519)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        model.error.asObserver().observeOn(MainScheduler.instance).filter{ $0.count > 0 }.filter{ $0.count == self.model.restaurantsId.value.count }.subscribe(onNext: { [weak self] (error) in
            guard let `self` = self else { return }
            
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.pullToRefresh.endRefreshing()
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            AudioServicesPlaySystemSound(1521)

            let alertController = UIAlertController(title: "MSG_ALERT".localized, message: error.first?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "MSG_OK".localized, style: UIAlertActionStyle.cancel, handler: nil))
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        //setupSearchController()
        setupRefreshControl()
        setupNavigationItem()
        
        if(traitCollection.forceTouchCapability == .available)
        {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    private func setupNavigationItem() {
        navigationItem.setRightBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "mapIcon"), style: .plain, target: self, action: nil), animated: true)
        
        navigationItem.rightBarButtonItem?.rx.tap.bind {
            [weak self] in
            guard let `self` = self else { return }
            
            let mapVC = FullscreenMapViewController.instantiate()
            mapVC.model.data.value = Networking.restaurantsLocal
            
            let navigationController = UINavigationController()
            navigationController.pushViewController(mapVC, animated: false)
            
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        }.disposed(by: disposeBag)
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
    
    private func checkAppStoreReview() {
        let appOpenCount = logAppOpened()
        
        switch appOpenCount {
        case 10,50:
            SKStoreReviewController.requestReview()
        case _ where appOpenCount%100 == 0 :
            SKStoreReviewController.requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break;
        }
    }
    
    private func logAppOpened() -> Int {
        guard let openCount = UserDefaults.standard.value(forKey: Constants.openCount) as? Int else {
            UserDefaults.standard.setValue(1, forKey: Constants.openCount)
            return 1
        }
        UserDefaults.standard.setValue(openCount + 1, forKey: Constants.openCount)
        
        return openCount + 1
    }

    private func getIndexPath(for selectedRow: RestaurantCell?, restaurants: [RestaurantTO]) -> IndexPath? {
        guard let selectedRow = selectedRow else { return nil }
        
        if let index = restaurants.index(where: { $0.id == selectedRow.restaurant.id }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
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
        do
        {
            
            if try model.restaurants.value().count <= indexPath.row {
                return UITableViewCell()
            }
            let cell:RestaurantCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(with: try model.restaurants.value().filter{ $0.hasData() }[indexPath.row], delegate: self)
            return cell
        } catch let e
        {
            print(e.localizedDescription)
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (try? model.restaurants.value().filter{ $0.hasData() }.count) ?? 0
    }
}

extension RestaurantsViewController : RestaurantCellDelegate {
    func didSelectRestaurant(restaurant: RestaurantTO, cell: RestaurantCell) {
        selectedCell?.setSelected(false, animated: false)
        
        let detail = RestaurantDetailViewController.instantiate()
        detail.model = RestaurantDetailViewModel()
        detail.model?.data.value = restaurant
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(detail, animated: false)
        
        splitViewController?.showDetailViewController(navigationController, sender: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.setSelected(true, animated: false)
            selectedCell = cell
        }
    }
}

//MARK: Search Delegate
extension RestaurantsViewController: UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
//MARK: Split view controller
extension RestaurantsViewController : UISplitViewControllerDelegate {
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

extension RestaurantsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let index = tableView.indexPathForRow(at: location)?.row, let value = (try? model.restaurants.value().filter{ $0.hasData() }[index]) else { return nil }
        let detail = RestaurantDetailViewController.instantiate()
        detail.model = RestaurantDetailViewModel()
        detail.model?.data.value = value
        return detail
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.pushViewController(viewControllerToCommit, animated: false)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
}
