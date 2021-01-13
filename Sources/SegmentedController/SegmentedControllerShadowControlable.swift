//
//  SegmentedControllersControlShadowable.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/11.
//

import UIKit

public protocol SegmentedControllerShadowControlable {
    
    /// return the tableView/collectionView/scrollView
    /// will be find it from Mirror(reflecting: self) if nil
    var scrollView: UIScrollView? { get }
    
    var segmentedController: SegmentedController? { get }
    
}

public extension SegmentedControllerShadowControlable {
    
    var scrollView: UIScrollView? { nil }
    
}

public extension SegmentedControllerShadowControlable where Self: UIViewController {
    
    var segmentedController: SegmentedController? {
        self.parent as? SegmentedController
    }
    
}
