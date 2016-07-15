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
        return tb
    }()
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.sizeToFit()
        return sc
    }()
    
    var searchBar: UISearchBar {
        get {
            return searchController.searchBar
        }
    }
    
    let db = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = view.frame
    }
    
    override func updateViewConstraints() {
        setConstraints()
        super.updateViewConstraints()
    }
    
    override func loadView() {
        super.loadView()
        definesPresentationContext = true
        bindSearchController()
        bindTableView()
        setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bindTableView() {
        tableView.tableHeaderView = searchBar
        tableView.registerClass(RouteTableViewCell.self, forCellReuseIdentifier: "RouteCell")
        tableView
            .rx_setDelegate(self)
            .addDisposableTo(db)
        routes
            .asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("RouteCell", cellType: RouteTableViewCell.self)) { [weak self] (row, element, cell) in
                self?.configureCell(element, cell: cell)
            }
            .addDisposableTo(db)
        
        let refreshControl = UIRefreshControl()
        refreshControl
            .rx_controlEvent(.ValueChanged)
            .subscribeNext { [unowned self] strings in
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
            .addDisposableTo(db)
        
        let activityIndicator = ActivityIndicator()
        activityIndicator
            .asObservable()
            .bindTo(refreshControl.rx_refreshing)
            .addDisposableTo(db)
        
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
    }
    
    func bindSearchController() {
        searchController.searchResultsUpdater = self
    }
    
    func configureCell(element: String, cell: RouteTableViewCell) {
        let random = Double(arc4random_uniform(100) + 1) / 100.0
        var color = UIColor.greenColor()
        if random >= 0.75 {
            color = UIColor.redColor()
        } else if random < 0.75 && random > 0.45 {
            color = UIColor.yellowColor()
        }
        cell.progressBarView.textLabel.font = UIFont(name: "OpenSans", size: 25)
        cell.progressBarView.textLabel.textColor = UIColor.whiteColor()
        cell.updateProgressBarView(random, color: color, text: "\(random)")
    }
    
    private func setConstraints() {
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }

}
