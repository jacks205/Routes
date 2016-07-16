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

class AddLocationViewController: UIViewController, UITableViewDelegate {
    
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
        return tb
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.showsCancelButton = false
        sb.searchBarStyle = .Minimal
        sb.barStyle = .Default
        sb.tintColor = UIColor.whiteColor()
        return sb
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Next", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "OpenSans", size: 14)
        btn.backgroundColor = bottomGradientBackgroundColor
        return btn
    }()
    
    let db = DisposeBag()
    
    override func loadView() {
        super.loadView()
        bindTableView()
        bindNextBtn()
        bindSearchBar()
        bindCloseBtn()
        setConstraints()
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
                DDLogInfo("Selected \(index)")
            }
            .addDisposableTo(db)
        
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        view.addSubview(tableView)
    }
    
    func configureCell(element: String, cell: LocationTableViewCell) {
        cell.locationNameLabel.text = element
        cell.addressLabel.text = "3063 Chapman Ave\nOrange, CA 92868"
        cell.backgroundColor = UIColor.clearColor()
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    private func bindNextBtn() {
        nextBtn
            .rx_tap
            .subscribeNext {
                
            }
            .addDisposableTo(db)
        view.addSubview(nextBtn)
    }
    
    private func bindCloseBtn() {
        let closeBtn = UIBarButtonItem()
        closeBtn.image = UIImage(named: "cancel")
        closeBtn.tintColor = UIColor.whiteColor()
        closeBtn
            .rx_tap
            .subscribeNext { [weak self] in
                self?.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(db)
        navigationItem.rightBarButtonItem = closeBtn
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
}

//struct SingleSelectionViewModel {
//    var cellIsSelectedObservable: Observable<Bool>
//    
//    init(tableViewSelected: Observable<NSIndexPath>, tableViewDeselected: Observable<NSIndexPath>) {
//        
//        
//    }
//}
