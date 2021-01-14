//
//  SegmentedCollectionController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/13.
//

import UIKit

open class SegmentedCollectionController: UICollectionViewController, SegmentedControllerShadowControlable {
    
    public var scrollView: UIScrollView? {
        collectionView
    }
    
    public var segmentedController: SegmentedController? {
        self.parent as? SegmentedController
    }
    
}
