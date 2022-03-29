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
        
        //segmenter.segmentConfigure = .minor
        segmenter.distribution = .default
        pages = [
            Page(title: "赤", controller: vc(.red)),
            Page(title: "橙", controller: vc(.orange)),
            Page(title: "黄", controller: vc(.yellow)),
            Page(title: "绿", controller: vc(.green)),
            Page(title: "青", controller: vc(.cyan)),
            Page(title: "蓝", controller: vc(.blue)),
            Page(title: "紫", controller: vc(.purple)),
        ]
        
        initialIndex = 1
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmenter.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 34)
        pager.view.frame = .init(x: 0, y: segmenter.frame.maxY, width: segmenter.frame.width, height: view.frame.height - segmenter.frame.height)
    }

}
