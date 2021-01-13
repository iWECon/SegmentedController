//
//  SubController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/8.
//

import UIKit
import Segmenter

class SubController: UIViewController, SegmentedControllerable  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func vc(_ backgroundColor: UIColor) -> UIViewController {
            let vc = UIViewController()
            vc.view.backgroundColor = backgroundColor
            return vc
        }
        
        segmenter.segmentConfigure = .minor
        segmenter.distribution = .default
        pages = [
            .init(title: "赤", controller: TableViewController()),
            .init(segment: .init(title: "橙", isShouldHideShadow: true), controller: TableViewController()),
            .init(title: "黄", controller: vc(.yellow)),
            .init(title: "绿", controller: vc(.green)),
            .init(title: "青", controller: vc(.cyan)),
            .init(title: "蓝", controller: vc(.blue)),
            .init(title: "紫", controller: vc(.purple)),
        ]
        
        initialIndex = 1
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmenter.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 34)
        pager.view.frame = .init(x: 0, y: segmenter.frame.maxY, width: segmenter.frame.width, height: view.frame.height - segmenter.frame.height)
    }

}
