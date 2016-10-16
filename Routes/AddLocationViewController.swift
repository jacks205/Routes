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
import GooglePlaces

class AddLocationViewController: AddRouteBaseViewController, UITableViewDelegate {
    
    let locations: Variable<[RoutesLocation]> = Variable<[RoutesLocation]>([])
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.allowsMultipleSelection = false
        tb.tableFooterView = UIView(frame: CGRect.zero)
        tb.separatorInset = UIEdgeInsets.zero
        tb.layoutMargins = UIEdgeInsets.zero
        tb.estimatedRowHeight = 72
        tb.rowHeight = 72
        tb.backgroundColor = addLocationViewBackgroundColor
        tb.keyboardDismissMode = .onDrag
        return tb
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.showsCancelButton = false
        sb.searchBarStyle = .minimal
        sb.barStyle = .default
        sb.tintColor = UIColor.white
        sb.keyboardAppearance = .dark
        return sb
    }()
    
    let locationSelected: Variable<Bool> = Variable<Bool>(false)
    
    override func loadView() {
        super.loadView()
        bindTableView()
        bindSearchBar()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            .rx.searchButtonClicked
            .subscribe(onNext: {
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(db)
        
        searchBar
            .rx.cancelButtonClicked
            .subscribe(onNext: {
                self.searchBar.resignFirstResponder()
            })
            .addDisposableTo(db)
        
        #if DEBUG
            let throttle = 0.7
        #else
            let throttle = 0.25
        #endif
        
        searchBar
            .rx.text
            .asDriver()
            .throttle(throttle)
            .distinctUntilChanged()
            .flatMap { query in
                GMSPlacesClient.shared()
                    .rx_autocompleteQuery(query, bounds: RoutesLocationService.instance.bounds.value, filter: nil)
                    .asDriver(onErrorJustReturn: [])
            }
            .map { $0.map(RoutesLocation.init) }
            .drive(locations)
            .addDisposableTo(db)
    }
    
    func bindTableView() {
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationCell")
        tableView
            .rx.setDelegate(self)
            .addDisposableTo(db)
        locations
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "LocationCell", cellType: LocationTableViewCell.self)) { [weak self] (row, element, cell) in
                self?.configureCell(element, cell: cell)
            }
            .addDisposableTo(db)

        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = addLocationViewBackgroundColor
        view.addSubview(tableView)
    }
    
    func configureCell(_ element: RoutesLocation, cell: LocationTableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = locationCellSelectedBackgroundColor
        cell.selectedBackgroundView = backgroundView
        cell.locationNameLabel.attributedText = element.boldNameText(cell.boldFont, regularFont: cell.regularFont)
        cell.addressLabel.text = element.address
        cell.backgroundColor = UIColor.clear
        cell.layoutMargins = UIEdgeInsets.zero
    }

    fileprivate func setConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
}
