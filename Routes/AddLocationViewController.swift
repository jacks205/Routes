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

class AddLocationViewController: AddRouteBaseViewController, UITableViewDelegate {
    
    let locations = Variable<[String]>(["California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona", "California", "Arizona"])
    
    let tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.allowsMultipleSelection = false
        tb.tableFooterView = UIView(frame: CGRect.zero)
        tb.separatorInset = UIEdgeInsetsZero
        tb.layoutMargins = UIEdgeInsetsZero
        tb.estimatedRowHeight = 70
        tb.rowHeight = 70
        tb.backgroundColor = UIColor.clearColor()
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
    
    let nextBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("NEXT", forState: .Normal)
        btn.setTitleColor(locationAddressTextColor, forState: .Normal)
        btn.setTitleColor(locationAddressTextColor, forState: .Highlighted)
        btn.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        btn.backgroundColor = bottomGradientBackgroundColor
        return btn
    }()
    
    let locationSelected: Variable<Bool> = Variable<Bool>(false)
    
    override func loadView() {
        super.loadView()
        bindTableView()
        bindNextBtn()
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
    
    override func viewDidLayoutSubviews() {
        tableView.contentInset.bottom = nextBtn.frame.height + 10
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
        tableView
            .rx_itemSelected
            .subscribeNext { index in
                self.locationSelected.value = true
            }
            .addDisposableTo(db)
        
        tableView
            .rx_itemDeselected
            .subscribeNext { index in
                self.locationSelected.value = false
            }
            .addDisposableTo(db)
        
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        view.addSubview(tableView)
    }
    
    func configureCell(element: String, cell: LocationTableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = locationCellSelectedBackgroundColor
        cell.selectedBackgroundView = backgroundView
        cell.locationNameLabel.text = element
        cell.addressLabel.text = "3063 Chapman Ave\nOrange, CA 92868"
        cell.backgroundColor = UIColor.clearColor()
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func bindNextBtn() {
        locationSelected
            .asObservable()
            .bindTo(nextBtn.rx_enabled)
            .addDisposableTo(db)
        locationSelected
            .asObservable()
            .subscribeNext { selected in
                if selected {
                    self.nextBtn.backgroundColor = lightGreenColor
                    self.nextBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                } else {
                    self.nextBtn.backgroundColor = bottomGradientBackgroundColor
                    self.nextBtn.setTitleColor(locationAddressTextColor, forState: .Normal)
                }
            }
            .addDisposableTo(db)
        view.addSubview(nextBtn)
    }
    
    private func setConstraints() {
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        
        nextBtn.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        nextBtn.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        nextBtn.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        nextBtn.heightAnchor.constraintEqualToConstant(44).active = true
        nextBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}
