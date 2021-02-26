//
//  SegmentedTableController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/13.
//

import UIKit

open class SegmentedTableController: UITableViewController, SegmentedControllerShadowControlable {
    
    public var scrollView: UIScrollView? {
        tableView
    }
    
    public var segmentedController: SegmentedController? {
        var parent = self.parent
        while parent != nil, !(parent is SegmentedController) {
            if parent is SegmentedController {
                break
            }
            parent = parent?.parent
        }
        return parent as? SegmentedController
    }
    
}
