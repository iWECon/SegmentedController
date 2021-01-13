//
//  SegmentedCollectionController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/13.
//

import UIKit

open class SegmentedCollectionController: UICollectionViewController, SegmentedControllerShadowControlable {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let segmentedController = self.segmentedController else { return }
        guard let index = segmentedController.viewControllers?.firstIndex(where: { $0 == self }) else { return }
        guard segmentedController.segmenter?.segments[index].isShouldHideShadow == false else { return }
        segmentedController.segmenter?.isShadowHidden = scrollView.contentOffset.y <= 1.0
    }
    
}
