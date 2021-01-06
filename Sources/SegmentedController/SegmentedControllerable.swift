//
//  Created by iWw on 2021/1/6.
//

import UIKit
import Segmenter

struct SegmentedControllerKeys {
    static var pagerKey = "SegmentedControllerKeys.pagerKey"
    static var pagesKey = "SegmentedControllerKeys.pagesKey"
    static var initialIndexKey = "SegmentedControllerKeys.initialIndexKey"
}

public struct Page {
    public var title: String
    public var controller: UIViewController
    public var isShouldHideShadow = false
}

public protocol SegmentedControllerable: Segmentedable {
    
    var pager: SegmentedController { get set }
    
    var pages: [Page] { get set }
    
    var initialIndex: Int { get set }
}

public extension SegmentedControllerable where Self: UIViewController {
    
    var pager: SegmentedController {
        get {
            guard let pager = objc_getAssociatedObject(self, &SegmentedControllerKeys.pagerKey) as? SegmentedController else {
                let pager = SegmentedController()
                pager.moveTo(self)
                objc_setAssociatedObject(self, &SegmentedControllerKeys.pagerKey, pager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return pager
            }
            return pager
        }
        set {
            objc_setAssociatedObject(self, &SegmentedControllerKeys.pagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pages: [Page] {
        get {
            objc_getAssociatedObject(self, &SegmentedControllerKeys.pagesKey) as? [Page] ?? []
        }
        set {
            objc_setAssociatedObject(self, &SegmentedControllerKeys.pagesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            pager.viewControllers = newValue.map { $0.controller }
            segmenter.segments = newValue.map { Segmenter.Segment(title: $0.title) }
        }
    }
    
    var initialIndex: Int {
        get {
            objc_getAssociatedObject(self, &SegmentedControllerKeys.initialIndexKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &SegmentedControllerKeys.initialIndexKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            guard segmenter.segments.count > 0, segmenter.segments.count == pager.viewControllers?.count else {
                fatalError("should be set `pages` first.")
            }
            
            UIView.performWithoutAnimation {
                self.segmenter.currentIndex = newValue
                self.pager.currentIndex = newValue
            }
        }
    }
    
    /// implemented in `viewDidLayoutSubviews` of UIViewController if you wanna use default layout
    func segmentedControllerableDidLayoutSubviews() {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        segmenter.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: statusBarHeight + Segmenter.Height)
        pager.view.frame = .init(x: 0, y: segmenter.frame.height, width: segmenter.frame.width, height: view.frame.height - segmenter.frame.height)
    }
}
