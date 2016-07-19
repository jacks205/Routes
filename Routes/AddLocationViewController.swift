//
//  AddRouteViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/15/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import RxCocoa
import GoogleMaps

class AddLocationViewController: AddRouteBaseViewController, UITableViewDelegate {
    
    let locations: Variable<[RoutesLocation]> = Variable<[RoutesLocation]>([])
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.allowsMultipleSelection = false
        tb.tableFooterView = UIView(frame: CGRect.zero)
        tb.separatorInset = UIEdgeInsetsZero
        tb.layoutMargins = UIEdgeInsetsZero
        tb.estimatedRowHeight = 72
        tb.rowHeight = 72
        tb.backgroundColor = addLocationViewBackgroundColor
        tb.keyboardDismissMode = .OnDrag
        return tb
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.showsCancelButton = false
        sb.searchBarStyle = .Minimal
        sb.barStyle = .Default
        sb.tintColor = UIColor.whiteColor()
        sb.keyboardAppearance = .Dark
        return sb
    }()
    
    let locationSelected: Variable<Bool> = Variable<Bool>(false)
    
    override func loadView() {
        super.loadView()
        bindTableView()
        bindSearchBar()
        setConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        #if RELEASE
            searchBar.becomeFirstResponder()
        #endif
        super.viewDidAppear(animated)
    }

    override func updateViewConstraints() {
        setConstraints()
        super.updateViewConstraints()
    }
    
    func bindSearchBar() {
        navigationItem.titleView = searchBar
        searchBar
            .rx_searchButtonClicked
            .subscribeNext {
                self.searchBar.resignFirstResponder()
            }
            .addDisposableTo(db)
        
        searchBar
            .rx_cancelButtonClicked
            .subscribeNext {
                self.searchBar.resignFirstResponder()
            }
            .addDisposableTo(db)
        
        #if DEBUG
            let throttle = 0.7
        #else
            let throttle = 0.25
        #endif
        
        searchBar
            .rx_text
            .asDriver()
            .throttle(throttle)
            .distinctUntilChanged()
            .flatMap { query in
                GMSPlacesClient.sharedClient()
                    .rx_autocompleteQuery(query, bounds: routesLocationManager.rx_bounds.value, filter: nil)
                    .asDriver(onErrorJustReturn: [])
            }
            .map { $0.map(RoutesLocation.init) }
            .drive(locations)
            .addDisposableTo(db)
    }
    
    func bindTableView() {
        tableView.registerClass(LocationTableViewCell.self, forCellReuseIdentifier: "LocationCell")
        tableView
            .rx_setDelegate(self)
            .addDisposableTo(db)
        locations
            .asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("LocationCell", cellType: LocationTableViewCell.self)) { [weak self] (row, element, cell) in
                self?.configureCell(element, cell: cell)
            }
            .addDisposableTo(db)

        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = addLocationViewBackgroundColor
        view.addSubview(tableView)
    }
    
    func configureCell(element: RoutesLocation, cell: LocationTableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = locationCellSelectedBackgroundColor
        cell.selectedBackgroundView = backgroundView
        cell.locationNameLabel.attributedText = element.boldNameText(cell.boldFont, regularFont: cell.regularFont)
        cell.addressLabel.text = element.address
        cell.backgroundColor = UIColor.clearColor()
        cell.layoutMargins = UIEdgeInsetsZero
    }

    private func setConstraints() {
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}
