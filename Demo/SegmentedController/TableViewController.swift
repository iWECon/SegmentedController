//
//  TableViewController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/7.
//

import UIKit
import Pager

class TableViewController: SegmentedTableController {
    
    var data: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        for i in 0 ..< 100 {
            data.append(i)
        }
    }
    
    // bugfix: the scrollView's scroll indicator insets inaccuracy
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.1, *) {
            tableView.verticalScrollIndicatorInsets = view.safeAreaInsets
        } else {
            if #available(iOS 11.0, *) {
                tableView.scrollIndicatorInsets = view.safeAreaInsets
            } else {
                // Fallback on earlier versions
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row)"

        return cell
    }
}
