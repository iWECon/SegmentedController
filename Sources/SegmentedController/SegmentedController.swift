
import UIKit
import Pager
import Segmenter
import YTPageController

open class SegmentedController: Pager {
    
    weak var segmenter: Segmenter?
    private weak var segmenterDelgate: SegmenterSelectedDelegate?
    
    private func findScrollView(in: Any?) -> UIScrollView? {
        guard let inReflecting = `in` else { return nil }
        return Mirror(reflecting: inReflecting).children.first(where: { $0.value is UIScrollView })?.value as? UIScrollView
    }
    
    public override func pageController(_ pageController: PageController, willStartTransition context: PageTransitionContext) {
        if let segmenter = segmenter, context.animationDuration > 0 {
            
            func toggleShadow(context: PageTransitionContext, from: Bool) {
                guard segmenter.isShadowShouldShow else { return }

                var scrollView: UIScrollView?

                let segment: Segmenter.Segment
                if from {
                    scrollView = self.findScrollView(in: context.toViewController)
                    segment = segmenter.segments[context.toIndex]
                } else {
                    scrollView = self.findScrollView(in: context.fromViewController)
                    segment = segmenter.segments[min(max(context.fromIndex, 0), segmenter.segments.count)]
                }
                segmenter.isShadowHidden = segment.isShouldHideShadow ? false : (scrollView?.contentOffset.y ?? 0 <= 1.0)
            }
            
            pageController.pageCoordinator?.animateAlongsidePaging(in: segmenter, animation: {
                [weak segmenter] (context) in
                segmenter?.isUserInteractionEnabled = false
                segmenter?.currentIndex = context.toIndex
                
                toggleShadow(context: context, from: false)
                
            }, completion: { [weak segmenter] (context) in
                if context.isCanceled {
                    segmenter?.currentIndex = context.fromIndex
                    
                    toggleShadow(context: context, from: true)
                }
                segmenter?.isUserInteractionEnabled = true
            })
        }
        
        super.pageController(pageController, willStartTransition: context)
    }
    
    @discardableResult
    public override func moveTo(_ viewController: UIViewController) -> Self {
        super.moveTo(viewController)
        
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.alwaysBounceVertical = false
        collectionView?.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView?.contentInsetAdjustmentBehavior = .never
        
        if let segmentedable = viewController as? Segmentedable {
            self.segmenter = segmentedable.segmenter
            if let segmenterDelgate = segmentedable.segmenter.delegate {
                self.segmenterDelgate = segmenterDelgate
                self.segmenter?.delegate = self
            } else {
                self.segmenter?.delegate = self
            }
        }
        return self
    }
}

extension SegmentedController: SegmenterSelectedDelegate {
    
    public func segmenter(_ segmenter: Segmenter, didSelectSegmentAt index: Int, with segment: Segmenter.Segment) {
        setCurrentIndex(index, animated: true)
        segmenterDelgate?.segmenter(segmenter, didSelectSegmentAt: index, with: segment)
    }
}
