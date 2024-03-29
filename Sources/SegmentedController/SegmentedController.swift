
import UIKit
import Pager
import Segmenter
import YTPageController

open class SegmentedController: Pager {
    
    public weak var segmenter: Segmenter?
    private weak var segmenterDelgate: SegmenterSelectedDelegate?
    public weak var transitionDelegate: SegmentedControllerTransitionDelegate?
    
    private func findScrollView(in: Any?) -> UIScrollView? {
        guard let inReflecting = `in` else { return nil }
        
        if inReflecting is SegmentedControllerShadowControlable, let scrollView = (inReflecting as? SegmentedControllerShadowControlable)?.scrollView {
            return scrollView
        }
        
        if let tableViewController = inReflecting as? UITableViewController {
            return tableViewController.tableView
        } else if let collectionViewController = inReflecting as? UICollectionViewController {
            return collectionViewController.collectionView
        }
        return Mirror(reflecting: inReflecting).children.first(where: { $0.value is UIScrollView })?.value as? UIScrollView
    }
    
    open override func pageController(_ pageController: PageController, willStartTransition context: PageTransitionContext) {
        defer {
            super.pageController(pageController, willStartTransition: context)
        }
        
        transitionDelegate?.segmentedController(self, pageController: pageController, willStartTransition: context)
        
        guard let segmenter = segmenter else {
            return
        }
        func toggleShadow(context: PageTransitionContext, from: Bool) {
            guard segmenter.isShadowShouldShow, context.toIndex <= segmenter.segments.count - 1 else { return }
            
            var scrollView: UIScrollView?
            
            let segment: Segment
            if from {
                scrollView = self.findScrollView(in: context.fromViewController)
                segment = segmenter.segments[min(max(context.fromIndex, 0), segmenter.segments.count)]
            } else {
                scrollView = self.findScrollView(in: context.toViewController)
                segment = segmenter.segments[context.toIndex]
            }
            
            guard !segment.isShouldHideShadow else {
                segmenter.isShadowHidden = true
                return
            }
            segmenter.isShadowHidden = segment.isShouldHideShadow ? true : (scrollView?.contentOffset.y ?? 0 <= 1.0)
        }
        
        if context.animationDuration > 0 {
            pageController.pageCoordinator?.animateAlongsidePaging(in: segmenter, animation: {
                [weak segmenter] (context) in
                segmenter?.isUserInteractionEnabled = false
                segmenter?.currentIndex = context.toIndex
                
                toggleShadow(context: context, from: false)
                
            }, completion: { [weak segmenter] (context) in
                if context.isCanceled {
                    segmenter?.currentIndex = context.fromIndex
                    
                    toggleShadow(context: context, from: true)
                } else {
                    segmenter?.currentIndex = context.toIndex
                }
                segmenter?.isUserInteractionEnabled = true
            })
        } else {
            toggleShadow(context: context, from: false)
        }
    }
    
    open override func pageController(_ pageController: PageController, didUpdateTransition context: PageTransitionContext) {
        super.pageController(pageController, didUpdateTransition: context)
        
        transitionDelegate?.segmentedController(self, pageController: pageController, didUpdateTransition: context)
    }
    
    open override func pageController(_ pageController: PageController, didEndTransition context: PageTransitionContext) {
        super.pageController(pageController, didEndTransition: context)
        
        transitionDelegate?.segmentedController(self, pageController: pageController, didEndTransition: context)
    }
    
    @discardableResult
    open override func moveTo(_ viewController: UIViewController) -> Self {
        super.moveTo(viewController)
        
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.alwaysBounceVertical = false
        
        
        if let pagable = viewController as? SegmentedControllerable {
            if let pvlp = pagable.pagerCollectionViewLayout {
                self.collectionViewLayoutProvider = { () -> UICollectionViewFlowLayout in
                    pvlp
                }
            }
            if let pvp = pagable.pagerCollectionView {
                self.collectionViewProvider = pvp
            }
        }
        
        // bugfix: embed SegmentedController using SegmentedController, the view's safeArea impact layout
        if #available(iOS 13.0, *) {
            collectionView?.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
            if #available(iOS 11.0, *) {
                collectionView?.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
                viewController.automaticallyAdjustsScrollViewInsets = false
            }
        }
        
        if let segmentedable = viewController as? Segmentedable {
            self.segmenter = segmentedable.segmenter
            // bugfix: shadow hide animation when view did load
            UIView.performWithoutAnimation {
                segmentedable.segmenter.isShadowHidden = true
            }
            // bring segmenter to front
            viewController.view.bringSubviewToFront(segmentedable.segmenter)
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
    
    public func segmenter(_ segmenter: Segmenter, didSelect index: Int, withSegment segment: Segment, fromIndex: Int, fromSegment: Segment) {
        setCurrentIndex(index, animated: false)
        segmenterDelgate?.segmenter(segmenter, didSelect: index, withSegment: segment, fromIndex: index, fromSegment: fromSegment)
        
        // bugfix: touch to change segmenter and the segmenter's shadow not be hidden when the scroll view is scrolling
        if let fromScrollView = findScrollView(in: viewControllers?[fromIndex]) {
            fromScrollView.setContentOffset(fromScrollView.contentOffset, animated: false)
        }
        
        guard segmenter.isShadowShouldShow, let scrollView = findScrollView(in: self.viewControllers?[index]) else {
            return
        }
        segmenter.isShadowHidden = segment.isShouldHideShadow ? true : (scrollView.contentOffset.y <= 1.0)
    }
}
