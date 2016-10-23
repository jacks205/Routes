//
//  AddRouteNicknameViewController.swift
//  Routes
//
//  Created by Mark Jackson on 10/20/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddRouteNicknameViewController: UIViewController, UITableViewDelegate {
    
    let nicknames = Variable<[String]>(["Home", "Work", "School", "Beach"])
    
    let tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .onDrag
        t.separatorColor = .clear
        t.backgroundColor = .clear
        return t
    }()
    
    var rx_nicknameSelected: Driver<String> {
        return tableView
            .rx.itemSelected
            .asDriver()
            .map { self.nicknames.value[$0.row] }
    }
    
    let db = DisposeBag()
    
    override func loadView() {
        super.loadView()
        bindTableView()
        setConstraints()
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self)
            .addDisposableTo(db)
        
        nicknames
            .asDriver()
            .drive(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { r, name, c in
                c.textLabel?.font = UIFont.montserratRegular(size: 14)
                c.textLabel?.textColor = .white
                c.backgroundColor = .clear
                c.textLabel?.text = name
            }
            .addDisposableTo(db)
        
        tableView
            .rx.itemDeleted
            .asDriver()
            .map { indexPath in
                var items = self.nicknames.value
                items.remove(at: indexPath.row)
                return items
            }
            .drive(nicknames)
            .addDisposableTo(db)
        
        view.addSubview(tableView)
    }
    
    func setConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let set = Set(self.nicknames.value)
        self.nicknames.value = Array(set).sorted { $0 < $1 }
    }
    
    //MARK: - Tableview Delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = view.backgroundColor
        let addView = AddNicknameSectionView()
        addView.backgroundColor = .clear
        headerView.addSubview(addView)
        addView.frame = headerView.frame
        
        addView
            .rx_add
            .drive(onNext: { text in
                var set = Set(self.nicknames.value)
                set.insert(text)
                let arr = Array(set)
                self.nicknames.value = arr.sorted { $0 < $1 }
                addView.textField.clearButtonMode = .whileEditing
                addView.textField.text = ""
            })
            .addDisposableTo(db)
        
        addView.textField.becomeFirstResponder()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
