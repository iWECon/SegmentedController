//
//  Created by iWw on 2021/1/6.
//

import UIKit
import Pager
import Segmenter

struct SegmentedControllerKeys {
    static var pagesKey = "SegmentedControllerKeys.pagesKey"
    static var initialIndexKey = "SegmentedControllerKeys.initialIndexKey"
}

public struct Page {
    public var segment: Segmenter.Segment
    public var controller: UIViewController
    
    public init(segment: Segmenter.Segment, controller: UIViewController) {
        self.segment = segment
        self.controller = controller
    }
    public init(title: String?, controller: UIViewController) {
        self.init(segment: .init(title: title), controller: controller)
    }
}


/// 快速构建协议，包含一个 pager，pages 和 initialIndex
/// ⚠️: `该协议只能用在 UIViewController 上`
public protocol SegmentedControllerable: Segmentedable, Pagable {
    
    var pager: SegmentedController { get set }
    
    /// 设置控制器以及对应的 segment 标题/属性
    var pages: [Page] { get set }
    
    /// 设置初始化显示的 page
    var initialIndex: Int { get set }
}

public extension SegmentedControllerable where Self: UIViewController {
    
    var pager: SegmentedController {
        get {
            guard let pager = objc_getAssociatedObject(self, &PagableKeys.pagerKey) as? SegmentedController else {
                let pager = SegmentedController()
                pager.moveTo(self)
                objc_setAssociatedObject(self, &PagableKeys.pagerKey, pager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return pager
            }
            return pager
        }
        set {
            objc_setAssociatedObject(self, &PagableKeys.pagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pages: [Page] {
        get {
            objc_getAssociatedObject(self, &SegmentedControllerKeys.pagesKey) as? [Page] ?? []
        }
        set {
            objc_setAssociatedObject(self, &SegmentedControllerKeys.pagesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.pager.viewControllers = newValue.map { $0.controller }
            self.segmenter.segments = newValue.map { $0.segment }
        }
    }
    
    /// set the initial index of the `pager` and the `segmenter`
    /// default is 0
    var initialIndex: Int {
        get {
            objc_getAssociatedObject(self, &SegmentedControllerKeys.initialIndexKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &SegmentedControllerKeys.initialIndexKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            guard segmenter.segments.count > 0, segmenter.segments.count == pager.viewControllers?.count else {
                fatalError("should be set `pages` first.")
            }
            
            // bugfix: set `initialIndex` in viewDidLoad has got an error: `[TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window).`
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self.segmenter.currentIndex = newValue
                    self.pager.currentIndex = newValue
                }
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


// bugfix: 使用 SegmentedControllerable, 在 pager 初始化之前使用 (self as? Pagable)?.pager 导致 pager 初始化错误的问题
extension Pagable where Self: UIViewController & SegmentedControllerable {
    
    var pager: Pager {
        get {
            guard let pager = objc_getAssociatedObject(self, &PagableKeys.pagerKey) as? Pager else {
                let pager = SegmentedController()
                pager.moveTo(self)
                objc_setAssociatedObject(self, &PagableKeys.pagerKey, pager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return pager
            }
            return pager
        }
        set {
            objc_setAssociatedObject(self, &PagableKeys.pagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
