# SegmentedController

提供 SegmentedTableController 和 SegmentedCollectionController 实现了列表滚动时控制 Segmenter 的 shadow 显示隐藏的效果

如果有其他业务需求，并且无法使用这两个控制器的，可以自行实现这两个控制器中的 scrollViewDidScroll 中的代码


一般情况下，实现 SegmentedControllable 协议即可

参考 Demo 中的 `ViewController.swift`


## Installation

#### Swift Package Manager

```
.package(url: "https://github.com/iWECon/SegmentedController", from: "2.0.0")
```

#### Cocoapods

```
pod 'SegmentedController', :git => 'https://github.com/iWECon/SegmentedController'
```
