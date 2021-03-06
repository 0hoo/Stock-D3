//
//  SelectGroupViewController.swift
//  Stock
//
//  Created by Kim Younghoo on 12/13/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

class SelectGroupViewController: UIViewController {
    
    //[C6-4]
    @IBOutlet weak var tableView: UITableView!
    
    //[C6-6]
    let groups: [Group]
    let stock: Stock
    
    //[C6-7]
    init(groups: [Group], stock: Stock) {
        self.groups = groups
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[C6-8]
        title = "그룹 선택"
        
        tableView.hideBottomSeparator()
        tableView.backgroundColor = .backgroundView
        tableView.separatorColor = .separator
        //[C6-9]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
}

extension SelectGroupViewController: UITableViewDataSource {
    //[C6-10]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    //[C6-11]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.title
        if group.title == stock.groupTitle {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension SelectGroupViewController: UITableViewDelegate {
    //[C6-12]
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //stock.groupTitle = groups[indexPath.row].title
        
        //[C6-19]
        if stock.groupTitle == groups[indexPath.row].title {
            stock.groupTitle = nil
        } else {
            stock.groupTitle = groups[indexPath.row].title
        }
        tableView.reloadData()
        NotificationCenter.default.post(name: Stock.didUpdate, object: nil)
    }
}
