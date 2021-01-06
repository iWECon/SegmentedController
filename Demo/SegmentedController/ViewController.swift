//
//  ViewController.swift
//  SegmentedController
//
//  Created by iWw on 2021/1/6.
//

import UIKit
import Segmenter

class ViewController: UIViewController, SegmentedControllerable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        func vc(_ backgroundColor: UIColor) -> UIViewController {
            let vc = UIViewController()
            vc.view.backgroundColor = backgroundColor
            return vc
        }
        
        pages = [
            .init(title: "赤", controller: vc(.red)),
            .init(title: "橙", controller: vc(.orange)),
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
        
        segmentedControllerableDidLayoutSubviews()
    }

}


