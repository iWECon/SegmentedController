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
        var parent = self.parent
        while parent != nil, !(parent is SegmentedController) {
            if parent is SegmentedController {
                break
            }
            parent = parent?.parent
        }
        // bugfix: when parent == nil
        if parent == nil {
            parent = self.next
            while parent != nil, !(parent is SegmentedController) {
                if parent is SegmentedController {
                    break
                }
                parent = (parent as? UIResponder)?.next
            }
        }
        return parent as? SegmentedController
    }
    
}
