
import UIKit
import YTPageController

// see: YTPageController.h:214  `YTPageControllerDelegate`
public protocol SegmentedControllerTransitionDelegate: AnyObject {
    
    func segmentedController(_ controller: SegmentedController, pageController: PageController, willStartTransition: PageTransitionContext)
    func segmentedController(_ controller: SegmentedController, pageController: PageController, didUpdateTransition: PageTransitionContext)
    func segmentedController(_ controller: SegmentedController, pageController: PageController, didEndTransition: PageTransitionContext)
}

extension SegmentedControllerTransitionDelegate {
    
    public func segmentedController(_ controller: SegmentedController, pageController: PageController, didUpdateTransition: PageTransitionContext) { }
    public func segmentedController(_ controller: SegmentedController, pageController: PageController, didEndTransition: PageTransitionContext) { }
}
