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
import MapKit

private let reuseIdentifier = "RouteCollectionCell"

class SelectRouteCollectionViewController: AddRouteBaseViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let selectRouteViewModel: SelectRouteViewModel
    let currentCollectionViewCenterRow = Variable<Int>(0)
    
    let confirmBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = lightBlueColor
        btn.setTitle("CONFIRM", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        return btn
    }()

    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        return mv
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.pageIndicatorTintColor = progressBarViewBackgroundColor
        pc.currentPageIndicatorTintColor = lightBlueColor
        pc.currentPage = 0
        return pc
    }()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CenterCellCollectionViewFlowLayout())
        cv.register(RouteSummaryOverlayCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = UIScrollViewDecelerationRateFast
        return cv
    }()
    
    let showDirectionsBtn: ShowDirectionView = {
        let v = ShowDirectionView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 2
        v.backgroundColor = bottomGradientBackgroundColor
        return v
    }()
    
    let routeSummaryRenameView: ContainerView = {
        let v = ContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    init(routes: [RouteType]) {
        selectRouteViewModel = SelectRouteViewModel(
            routes: routes,
            originLocation: routeSummaryRenameView.leftView.textView.rx.text.asObservable(),
            destinationLocation: routeSummaryRenameView.rightView.textView.rx.text.asObservable()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindMapView()
        bindCollectionView()
        bindPageControl()
        bindConfirmBtn()
        bindShowDirectionsBtn()
        view.addSubview(routeSummaryRenameView)
        setConstraints()
    }
    
    private func bindShowDirectionsBtn() {
        showDirectionsBtn
            .btn.rx.tap
            .map { _ in return self.currentCollectionViewCenterRow.value }
            .map { row in return self.selectRouteViewModel.routes.value[row] }
            .subscribe(onNext: { route in
                let vc = detailsViewController(route: route)
                self.navigationController?.present(vc, animated: true, completion: nil)
            })
            .addDisposableTo(db)
        
        mapView.addSubview(showDirectionsBtn)
    }
    
    private func bindMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    private func bindConfirmBtn() {
        selectRouteViewModel
            .rx_nicknamesValid
            .bindTo(confirmBtn.rx.enabled)
            .addDisposableTo(db)
        
        confirmBtn
            .rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(db)
        
        view.addSubview(confirmBtn)
    }
    
    private func bindPageControl() {
        pageControl.numberOfPages = selectRouteViewModel.routes.value.count
        mapView.addSubview(pageControl)
    }
    
    private func bindCollectionView() {
        collectionView
            .rx.setDelegate(self)
            .addDisposableTo(db)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        selectRouteViewModel
            .routes
            .asDriver()
            .drive(collectionView.rx_itemsWithCellIdentifier(reuseIdentifier, cellType: RouteSummaryOverlayCollectionViewCell.self)) { (index, route, cell) in
                let (longestStreet, secondLongestStreet) = route.legs[0].longestManeuverStreets()
                if let longestStreet = longestStreet,
                    let secondLongestStreet = secondLongestStreet {
                    cell.detailView.viaLabel.text = longestStreet + " & " + secondLongestStreet
                } else if let longestStreet = longestStreet {
                    cell.detailView.viaLabel.text = longestStreet
                } else if let secondLongestStreet = secondLongestStreet {
                    cell.detailView.viaLabel.text = secondLongestStreet
                }
                
                let summary = route.summary
                cell.detailView.distanceLabel.text = summary?.distance.metersToMilesString() ?? "UNKNOWN"
                cell.detailView.timeLabel.text = summary?.travelTime.secondsToHoursMinutesString() ?? "UNKNOWN"
            }
            .addDisposableTo(db)
        mapView.addSubview(collectionView)
    }
    
    private func setConstraints() {
        routeSummaryRenameView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        routeSummaryRenameView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        routeSummaryRenameView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        routeSummaryRenameView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        confirmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addConstraintsWithFormat("V:[v0][v1(50)]|", views: mapView, confirmBtn)
        view.addConstraintsWithFormat("H:|[v0]|", views: mapView)
        mapView.topAnchor.constraint(equalTo: routeSummaryRenameView.bottomAnchor).isActive = true
        mapView.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        mapView.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        mapView.addConstraintsWithFormat("V:[v0]-10-|", views: pageControl)
        
        pageControl.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        showDirectionsBtn.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10).isActive = true
        showDirectionsBtn.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10).isActive = true
        showDirectionsBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        showDirectionsBtn.trailingAnchor.constraint(equalTo: showDirectionsBtn.showDirectionsLabel.trailingAnchor, constant: 10).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentCollectionViewCenterRow
            .asObservable()
            .distinctUntilChanged()
            .bindTo(self.pageControl.rx.currentPage)
            .addDisposableTo(db)
        
        currentCollectionViewCenterRow
            .asObservable()
            .distinctUntilChanged()
            .flatMap { i -> Observable<MKPolyline> in
                return self.selectRouteViewModel
                    .legs[i]
                    .rx_polyline()
            }
            .subscribe(onNext: { polyline in
                let oldOverlays = self.mapView.overlays
                self.mapView.removeOverlays(oldOverlays)
                self.mapView.add(polyline)
                UIView.animate(withDuration: 0.35, animations: {
                    self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 75, left: 75, bottom: 137, right: 75), animated: true)
                })
            })
            .addDisposableTo(db)
        
        routeSummaryRenameView
            .rx_viewTap
            .subscribe(onNext: { textView in
                let addNicknameVC = addRouteNicknameViewController()
                guard let nvc = addNicknameVC.navigationController else { return }
                
                addNicknameVC.navigationItem.rightBarButtonItem?
                    .rx.tap
                    .subscribe(onNext: {
                        nvc.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo(addNicknameVC.db)
                
                addNicknameVC
                    .rx_nicknameSelected
                    .drive(onNext: { nickname in
                        textView.text = nickname
                        nvc.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo(addNicknameVC.db)
                self.navigationController?.present(nvc, animated: true, completion: nil)
            })
            .addDisposableTo(db)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //TODO: Look at list of routes and color accordingly
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = lightBlueColor
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height - pageControl.frame.height - 10 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: pageControl.frame.height + 10 + 10, right: 30)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let center = CGPoint(x: collectionView.frame.size.width / 2 + scrollView.contentOffset.x, y: collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
            if let indexPath = collectionView.indexPathForItem(at: center) {
                currentCollectionViewCenterRow.value = indexPath.row
            }
            
        }
    }
    
}
