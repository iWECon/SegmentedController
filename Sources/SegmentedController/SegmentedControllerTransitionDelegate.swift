
import UIKit
import YTPageController

// see: YTPageController.h:214  `YTPageControllerDelegate`
public protocol SegmentedControllerTransitionDelegate: AnyObject {
    
    func segmentedController(_ controller: SegmentedController, pageController: PageController, willStartTransition context: PageTransitionContext)
    func segmentedController(_ controller: SegmentedController, pageController: PageController, didUpdateTransition context: PageTransitionContext)
    func segmentedController(_ controller: SegmentedController, pageController: PageController, didEndTransition context: PageTransitionContext)
}

extension SegmentedControllerTransitionDelegate {
    
    public func segmentedController(_ controller: SegmentedController, pageController: PageController, didUpdateTransition context: PageTransitionContext) { }
    public func segmentedController(_ controller: SegmentedController, pageController: PageController, didEndTransition context: PageTransitionContext) { }
}
