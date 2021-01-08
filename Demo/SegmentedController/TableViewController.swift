//
//  TableViewController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/7.
//

import UIKit
import Pager

class TableViewController: UITableViewController {
    
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 120 {
//            var insertIndexPaths: [IndexPath] = []
//            let count = data.count
//            for i in 0 ..< 100 {
//                insertIndexPaths.append(.init(row: i + count, section: 0))
//                data.append(i)
//            }
//
//            tableView.beginUpdates()
//            tableView.insertRows(at: insertIndexPaths, with: .none)
//            tableView.endUpdates()
//
//            // tableView.reloadData()
//        }
        
        // find segmentedController
        guard let segmentedController = self.parent as? SegmentedController else { return }
        guard let index = segmentedController.viewControllers?.firstIndex(where: { $0 == self }) else { return }
        guard segmentedController.segmenter?.segments[index].isShouldHideShadow == false else { return }
        segmentedController.segmenter?.isShadowHidden = scrollView.contentOffset.y <= 1.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
