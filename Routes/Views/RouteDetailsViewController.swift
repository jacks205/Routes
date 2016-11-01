//
//  RouteDetailsViewController.swift
//  Routes
//
//  Created by Mark Jackson on 10/19/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import RealmSwift

class RouteDetailsViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate {
    
    let route: Variable<Route>
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        return mv
    }()
    
    let tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(StepDetailTableViewCell.self, forCellReuseIdentifier: StepDetailTableViewCell.identifier)
        t.backgroundColor = .clear
        t.allowsSelection = false
        t.tableFooterView = UIView()
        t.showsVerticalScrollIndicator = false
        t.separatorColor = .clear
        return t
    }()
    
    private let lineLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.lineWidth = 8
        l.strokeColor = lightBlueColor.cgColor
        return l
    }()
    
    private let overviewDetailView: LegOverviewDetailView = {
        let v = LegOverviewDetailView()
        v.backgroundColor = .clear
        return v
    }()
    
    let db = DisposeBag()
    
    init(origin: String, destination: String, route: Route) {
        self.route = Variable<Route>(route)
        super.init(nibName: nil, bundle: nil)
        bindNavigationBar()
        
        overviewDetailView.originLabel.text = origin
        overviewDetailView.destinationLabel.text = destination
        overviewDetailView.timeLabel.text = route.legs.first?.durationText
        overviewDetailView.distanceLabel.text = route.legs.first?.distanceText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bindMapView()
        bindTableView()
        setConstraints()
    }
    
    private func bindNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map"), style: .plain, target: nil, action: nil)
        navigationItem
            .rightBarButtonItem?
            .rx
            .tap
            .subscribe(onNext: {
                
            })
            .addDisposableTo(db)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: nil, action: nil)
        navigationItem
            .leftBarButtonItem?
            .rx
            .tap
            .subscribe(onNext: {
                let _ = self.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(db)
    }
    
    private func bindMapView() {
        mapView.delegate = self
    }
    
    private func bindTableView() {
        tableView
            .rx.setDelegate(self)
            .addDisposableTo(db)
        
        let steps = Variable<List<Step>>(route
                                        .value
                                        .legs.first!
                                        .steps)
        steps
            .asDriver()
            .drive(tableView.rx_itemsWithCellIdentifier(StepDetailTableViewCell.identifier, cellType: StepDetailTableViewCell.self)) { r, step, c in
                c.backgroundColor = .clear
                c.detailView.setTextLabelAttributedString(text: step.instructions)
                c.detailView.timeLabel.text = step.durationText
                c.detailView.distanceLabel.text = step.distanceText
            }
            .addDisposableTo(db)
        
        view.addSubview(tableView)
        
    }
    
    func setConstraints() {
        view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
    }
    
    override func viewDidLayoutSubviews() {
        lineLayer.removeFromSuperlayer()
        lineLayer.frame = view.bounds
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: view.frame.width, y: 0))
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = route.value.legs.first?.routeColor.cgColor
        view.layer.addSublayer(lineLayer)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 210))
        mapView.frame = headerView.frame
        headerView.addSubview(mapView)
        tableView.tableHeaderView = headerView
        
        tableView.contentInset.bottom = view.frame.height / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        route
            .value
            .rx_polyline()
            .subscribe(onNext: { polyline in
                self.mapView.add(polyline)
                UIView.animate(withDuration: 0.35, animations: {
                    self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
                })
            })
            .addDisposableTo(db)
    }
    
    func tableViewHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = addLocationViewBackgroundColor
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70)
        overviewDetailView.frame = CGRect(x: 10, y: 10, width: tableView.frame.width - 16, height: 50)
        headerView.addSubview(overviewDetailView)
        return headerView
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    //MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //TODO: Look at list of routes and color accordingly
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = route.value.legs.first?.routeColor
        renderer.lineWidth = 4
        return renderer
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
}
