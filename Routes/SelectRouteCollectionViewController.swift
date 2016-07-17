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
    
    let routes = Variable<[String]>(["California", "Arizona", "Texas"])
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: CenterCellCollectionViewFlowLayout())
        cv.registerClass(RouteSummaryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clearColor()
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
    
    func configureCell(row: Int, element: String, cell: RouteSummaryCollectionViewCell) {
        cell.backgroundColor = progressBarViewBackgroundColor
        cell.layer.cornerRadius = 12
        cell.startingLocationLabel.text = "Essex Apartments\n3063 Chapman Ave\nApt 3107\nOrange, CA 92868"
        cell.destinationLocationLabel.text = "Essex Apartments\n3063 Chapman Ave\nApt 3107\nOrange, CA 92868"
        cell.distanceValueLabel.text = "8 mi"
        cell.timeValueLabel.text = "38 mins"
        switch row {
        case 0:
            cell.timeValueLabel.textColor = darkGreenColor
        case 1:
            cell.timeValueLabel.textColor = darkYellowColor
        case 2:
            cell.timeValueLabel.textColor = darkRedColor
        default: break
        }
    }
    
    func setConstraints() {
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|[v0][v1(44)]-|", views: collectionView, confirmBtn)
        
//        nextBtn.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        confirmBtn.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        confirmBtn.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
//        nextBtn.heightAnchor.constraintEqualToConstant(44).active = true
        confirmBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width * cellSizePercentage, height: view.frame.height * cellSizePercentage)
    }
}
