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
    
    let maps = Variable<[UIImage]>([])
    let routes = Variable<[RouteType]>([])
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: CenterCellCollectionViewFlowLayout())
        cv.register(RouteSummaryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = addLocationViewBackgroundColor
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        return cv
    }()
    
    let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("CONFIRM", for: UIControlState())
        btn.setTitleColor(locationAddressTextColor, for: UIControlState())
        btn.setTitleColor(locationAddressTextColor, for: .highlighted)
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
        super.updateViewConstraints()
    }
    
    fileprivate func bindCollectionView() {
        collectionView
            .rx.setDelegate(self)
            .addDisposableTo(db)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
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
            .rx.itemSelected
            .subscribe(onNext: { index in
                self.routeSelected.value = true
            })
            .addDisposableTo(db)
        
        collectionView
            .rx.itemDeselected
            .subscribe(onNext: { index in
                self.routeSelected.value = false
            })
            .addDisposableTo(db)
        collectionView.frame = view.frame
        collectionView.contentInset = UIEdgeInsets(top: 0, left: view.frame.width * (cellSizeDifference / 2), bottom: 0, right: view.frame.width * (cellSizeDifference / 2))
        view.addSubview(collectionView)
    }
    
    func bindNextBtn() {
        routeSelected
            .asObservable()
            .bindTo(confirmBtn.rx.enabled)
            .addDisposableTo(db)
        routeSelected
            .asObservable()
            .subscribe(onNext: { selected in
                if selected {
                    self.confirmBtn.backgroundColor = lightGreenColor
                    self.confirmBtn.setTitleColor(.white, for: .normal)
                } else {
                    self.confirmBtn.backgroundColor = bottomGradientBackgroundColor
                    self.confirmBtn.setTitleColor(locationAddressTextColor, for: .normal)
                }
            })
            .addDisposableTo(db)
        view.addSubview(confirmBtn)
        confirmBtn
            .rx.tap
            .subscribe(onNext: {
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(db)
    }
    
    func configureCell(_ row: Int, element: RouteType, cell: RouteSummaryCollectionViewCell) {
        cell.backgroundColor = progressBarViewBackgroundColor
        cell.layer.cornerRadius = 12
        cell.originLabel.text = ""
        cell.destinationLabel.text = ""
        
        let summary = element.summary
        cell.distanceValueLabel.text = "\(summary?.distance) mi"
        let (hours, minutes) = (summary?.travelTime.secondsToHoursMinutes())!
        cell.timeValueLabel.text = (hours > 0 ? "\(hours) hrs" : "") + (minutes > 0 ? "\(minutes) min" : "")
        cell.layoutIfNeeded()
        
        if let summary = summary {
            let duration = summary.baseTime / summary.travelTime
            if duration > 0.80 {
                cell.timeValueLabel.textColor = darkGreenColor
            } else if duration > 0.60 {
                cell.timeValueLabel.textColor = darkYellowColor
            } else {
                cell.timeValueLabel.textColor = darkRedColor
            }
        }
    }
    
    func setConstraints() {
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|[v0][v1(44)]-|", confirmBtn, views: collectionView)
        
        confirmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * cellSizePercentage, height: view.frame.height * cellSizePercentage)
    }
}
