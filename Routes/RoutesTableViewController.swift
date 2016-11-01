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
    
    let routesViewModel: RoutesTableViewModel
    
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
        sc.searchBar.tintColor = .gray
        sc.searchBar.backgroundColor = .clear
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
    
    init(viewModel: RoutesTableViewModel) {
        routesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.identifier)
        tableView
            .rx.setDelegate(self)
            .addDisposableTo(db)
        routesViewModel.routes
            .asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier(RouteTableViewCell.identifier, cellType: RouteTableViewCell.self)) { [unowned self] (row, route, cell) in
                self.routesViewModel.configureCell(route: route, cell: cell)
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
    
    fileprivate func createRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.clear
        refreshControl?
            .rx.controlEvent(.valueChanged)
            .flatMap { self.routesViewModel.rx_refreshRoutes() }
            .bindTo(self.routesViewModel.routes)
            .addDisposableTo(db)
        
        routesViewModel
            .routes
            .asObservable()
            .map { _ in return false }
            .bindTo(refreshControl!.rx.refreshing)
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
            .subscribe(onNext: { [unowned self] in
                let addLocationNVC = addLocationViewController()
                self.navigationController?.present(addLocationNVC, animated: true, completion: nil)
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
