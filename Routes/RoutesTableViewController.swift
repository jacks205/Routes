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
        tb.separatorStyle = .None
        tb.estimatedRowHeight = 150
        tb.rowHeight = 150
        tb.backgroundColor = UIColor.clearColor()
        return tb
    }()
    
    let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.sizeToFit()
        sc.searchBar.barStyle = .Black
        sc.searchBar.searchBarStyle = .Minimal
        sc.searchBar.tintColor = UIColor.grayColor()
        sc.searchBar.backgroundColor = UIColor.clearColor()
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
    
    private let gradientBackgroundLayer: CAGradientLayer = {
        let gb = CAGradientLayer()
        gb.colors = [topGradientBackgroundColor.CGColor, bottomGradientBackgroundColor.CGColor]
        return gb
    }()
    
    let db = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = view.frame
        gradientBackgroundLayer.frame = view.frame
    }
    
    override func updateViewConstraints() {
        setConstraints()
        super.updateViewConstraints()
    }
    
    override func loadView() {
        super.loadView()
        view.layer.insertSublayer(gradientBackgroundLayer, atIndex: 0)
        definesPresentationContext = true
        addNavigationItems()
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
        tableView
            .rx_itemSelected
            .subscribeNext { index in
                DDLogInfo("Selected \(index)")
            }
            .addDisposableTo(db)
        
        createRefreshControl()
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        view.addSubview(tableView)
    }
    
    func bindSearchController() {
        searchController.searchResultsUpdater = self
    
        searchController
            .rx_willPresent
            .subscribeNext {
                self.activityIndicator = nil
                self.refreshControl?.removeFromSuperview()
                self.refreshControl = nil
            }
            .addDisposableTo(db)
        searchController
            .rx_willDismiss
            .subscribeNext {
                self.createRefreshControl()
            }
            .addDisposableTo(db)
    }
    
    func configureCell(element: String, cell: RouteTableViewCell) {
        let random = Double(arc4random_uniform(100) + 1) / 100.0
        var color = darkGreenColor
        if random >= 0.75 {
            color = darkRedColor
        } else if random < 0.75 && random > 0.45 {
            color = darkYellowColor
        }
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.originNameLabel.text = element
        cell.destinationNameLabel.text = element
        cell.descriptionLabel.text = "via I-55s and Chapman Ave"
        cell.distanceLabel.text = "47.3 mi"
        cell.progressBarView.textLabel.font = UIFont(name: "OpenSans", size: 10)
        cell.progressBarView.textLabel.textColor = UIColor.whiteColor()
        cell.updateProgressBarView(random, color: color, text: "\(random)")
    }
    
    private func createRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.clearColor()
        refreshControl?
            .rx_controlEvent(.ValueChanged)
            .subscribeNext { [unowned self] strings in
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
            .addDisposableTo(db)
        
        activityIndicator = ActivityIndicator()
        activityIndicator?
            .asObservable()
            .bindTo(refreshControl!.rx_refreshing)
            .addDisposableTo(db)
        
        tableView.addSubview(refreshControl!)
    }
    
    private func addNavigationItems() {
        let addBarBtn = UIBarButtonItem()
        addBarBtn.image = UIImage(named: "add")
        addBarBtn
            .rx_tap
            .subscribeNext { [weak self] in
                let addLocationVC = AddStartingLocationViewController()
                addLocationVC.view.backgroundColor = addLocationViewBackgroundColor
                addLocationVC.searchBar.placeholder = "Enter Starting Location"
                let addNvc = UINavigationController(rootViewController: addLocationVC)
                addNvc.navigationBar.tintColor = UIColor.whiteColor()
                addNvc.navigationBar.barTintColor = bottomGradientBackgroundColor
                addNvc.interactivePopGestureRecognizer?.enabled = false
                self?.navigationController?.presentViewController(addNvc, animated: true, completion: nil)
            }
            .addDisposableTo(db)
        navigationItem.rightBarButtonItem = addBarBtn
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
