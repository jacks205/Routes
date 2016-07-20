//
//  SelectRouteCollectionViewController.swift
//  Routes
//
//  Created by Mark Jackson on 7/16/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import RxCocoa

private let reuseIdentifier = "RouteCollectionCell"

class SelectRouteCollectionViewController: AddRouteBaseViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let routes = Variable<[RouteObject]>([])
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: CenterCellCollectionViewFlowLayout())
        cv.registerClass(RouteSummaryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = addLocationViewBackgroundColor
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        return cv
    }()
    
    let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("CONFIRM", forState: .Normal)
        btn.setTitleColor(locationAddressTextColor, forState: .Normal)
        btn.setTitleColor(locationAddressTextColor, forState: .Highlighted)
        btn.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        btn.backgroundColor = bottomGradientBackgroundColor
        return btn
    }()
    
    let cellSizePercentage: CGFloat = 0.85
    var cellSizeDifference: CGFloat {
        get {
            return 1 - cellSizePercentage
        }
    }
    
    let routeSelected: Variable<Bool> = Variable<Bool>(false)
    
    override func loadView() {
        super.loadView()
        bindCollectionView()
        bindNextBtn()
        setConstraints()
    }
    
    override func updateViewConstraints() {
        setConstraints()
        super.updateViewConstraints()
    }
    
    private func bindCollectionView() {
        collectionView
            .rx_setDelegate(self)
            .addDisposableTo(db)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumLineSpacing = view.frame.width * (cellSizeDifference / 4)
        }
        routes
            .asObservable()
            .bindTo(collectionView.rx_itemsWithCellIdentifier(reuseIdentifier, cellType: RouteSummaryCollectionViewCell.self)) { [weak self] (row, element, cell) in
                DDLogInfo("\(row)")
                self?.configureCell(row, element: element, cell: cell)
            }
            .addDisposableTo(db)
        collectionView
            .rx_itemSelected
            .subscribeNext { index in
                self.routeSelected.value = true
            }
            .addDisposableTo(db)
        
        collectionView
            .rx_itemDeselected
            .subscribeNext { index in
                self.routeSelected.value = false
            }
            .addDisposableTo(db)
        collectionView.frame = view.frame
        collectionView.contentInset = UIEdgeInsets(top: 0, left: view.frame.width * (cellSizeDifference / 2), bottom: 0, right: view.frame.width * (cellSizeDifference / 2))
        view.addSubview(collectionView)
    }
    
    func bindNextBtn() {
        routeSelected
            .asObservable()
            .bindTo(confirmBtn.rx_enabled)
            .addDisposableTo(db)
        routeSelected
            .asObservable()
            .subscribeNext { selected in
                if selected {
                    self.confirmBtn.backgroundColor = lightGreenColor
                    self.confirmBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                } else {
                    self.confirmBtn.backgroundColor = bottomGradientBackgroundColor
                    self.confirmBtn.setTitleColor(locationAddressTextColor, forState: .Normal)
                }
            }
            .addDisposableTo(db)
        view.addSubview(confirmBtn)
        confirmBtn
            .rx_tap
            .subscribeNext {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(db)
    }
    
    func configureCell(row: Int, element: RouteObject, cell: RouteSummaryCollectionViewCell) {
        cell.backgroundColor = progressBarViewBackgroundColor
        cell.layer.cornerRadius = 12
        
        guard let leg = element.route.legs.first else {
            return
        }
        
        cell.originLabel.text = element.origin.name
        cell.destinationLabel.text = element.destination.name
        cell.distanceValueLabel.text = leg.distance.text
        cell.timeValueLabel.text = leg.duration.text
        cell.viaValueLabel.text = element.route.summary
        cell.layoutIfNeeded()
        
        let duration = Double(leg.duration.value) / Double(leg.traffic.value)
        if duration > 0.80 {
            cell.timeValueLabel.textColor = darkGreenColor
        } else if duration > 0.60 {
            cell.timeValueLabel.textColor = darkYellowColor
        } else {
            cell.timeValueLabel.textColor = darkRedColor
        }
    }
    
    func setConstraints() {
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|[v0][v1(44)]-|", views: collectionView, confirmBtn)
        
        confirmBtn.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        confirmBtn.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        confirmBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width * cellSizePercentage, height: view.frame.height * cellSizePercentage)
    }
}
