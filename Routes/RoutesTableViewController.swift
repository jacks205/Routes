//
//  RoutesTableViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/13/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import RxCocoa

class RoutesTableViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating {
    
    let routes = Variable<[String]>(["California", "Arizona"])
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.allowsMultipleSelection = false
        tb.tableFooterView = UIView(frame: CGRect.zero)
        tb.separatorStyle = .none
        tb.separatorInset = UIEdgeInsets.zero
        tb.estimatedRowHeight = 150
        tb.rowHeight = 150
        tb.backgroundColor = UIColor.clear
        return tb
    }()
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.sizeToFit()
        sc.searchBar.barStyle = .black
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.tintColor = UIColor.gray
        sc.searchBar.backgroundColor = UIColor.clear
        sc.searchBar.placeholder = ""
        return sc
    }()
    
    var searchBar: UISearchBar {
        get {
            return searchController.searchBar
        }
    }
    
    var refreshControl: UIRefreshControl? = UIRefreshControl()
    var activityIndicator: ActivityIndicator? = ActivityIndicator()
    
    fileprivate let gradientBackgroundLayer: CAGradientLayer = {
        let gb = CAGradientLayer()
        gb.colors = [topGradientBackgroundColor.cgColor, bottomGradientBackgroundColor.cgColor]
        return gb
    }()
    
    let db = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        gradientBackgroundLayer.frame = view.frame
    }
    
    override func loadView() {
        super.loadView()
        view.layer.insertSublayer(gradientBackgroundLayer, at: 0)
        definesPresentationContext = true
        addNavigationItems()
        bindSearchController()
        bindTableView()
        setConstraints()
    }
    
    func bindTableView() {
        tableView.tableHeaderView = searchBar
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: "RouteCell")
        tableView
            .rx.setDelegate(self)
            .addDisposableTo(db)
        routes
            .asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("RouteCell", cellType: RouteTableViewCell.self)) { [weak self] (row, element, cell) in
                self?.configureCell(element, cell: cell)
            }
            .addDisposableTo(db)
        tableView
            .rx.itemSelected
            .subscribe(onNext: { index in
                DDLogInfo("Selected \(index)")
            })
            .addDisposableTo(db)
        
        createRefreshControl()
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.clear
        
        view.addSubview(tableView)
    }
    
    func bindSearchController() {
        searchController.searchResultsUpdater = self
    
        searchController
            .rx.willPresent
            .subscribe(onNext: {
                self.activityIndicator = nil
                self.refreshControl?.removeFromSuperview()
                self.refreshControl = nil
            })
            .addDisposableTo(db)
        searchController
            .rx.willDismiss
            .subscribe(onNext: {
                self.createRefreshControl()
            })
            .addDisposableTo(db)
    }
    
    func configureCell(_ element: String, cell: RouteTableViewCell) {
        let random = Double(arc4random_uniform(100) + 1) / 100.0
        var color = darkGreenColor
        if random >= 0.75 {
            color = darkRedColor
        } else if random < 0.75 && random > 0.45 {
            color = darkYellowColor
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.originNameLabel.text = element
        cell.destinationNameLabel.text = element
        cell.descriptionLabel.text = "via I-55s and Chapman Ave"
        cell.distanceLabel.text = "47.3 mi"
        cell.progressBarView.textLabel.font = UIFont(name: "OpenSans", size: 10)
        cell.progressBarView.textLabel.textColor = UIColor.white
        cell.updateProgressBarView(random, color: color, text: "\(random)")
    }
    
    fileprivate func createRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.clear
        refreshControl?
            .rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] strings in
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
            .addDisposableTo(db)
        
        activityIndicator = ActivityIndicator()
        activityIndicator?
            .asObservable()
            .bindTo(refreshControl!.rx.refreshing)
            .addDisposableTo(db)
        
        tableView.addSubview(refreshControl!)
    }
    
    fileprivate func addNavigationItems() {
        let addBarBtn = UIBarButtonItem()
        addBarBtn.image = UIImage(named: "add")
        addBarBtn
            .rx.tap
            .subscribe(onNext: { [weak self] in
                let addLocationVC = AddStartingLocationViewController()
                addLocationVC.view.backgroundColor = addLocationViewBackgroundColor
                addLocationVC.searchBar.placeholder = "Enter Starting Location"
                let addNvc = UINavigationController(rootViewController: addLocationVC)
                addNvc.navigationBar.tintColor = .white
                addNvc.navigationBar.barTintColor = bottomGradientBackgroundColor
                addNvc.interactivePopGestureRecognizer?.isEnabled = false
                self?.navigationController?.present(addNvc, animated: true, completion: nil)
            })
            .addDisposableTo(db)
        navigationItem.rightBarButtonItem = addBarBtn
    }
    
    fileprivate func setConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }

}
