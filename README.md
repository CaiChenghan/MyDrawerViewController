# MyDrawerViewController

[![CI Status](http://img.shields.io/travis/蔡成汉/MyDrawerViewController.svg?style=flat)](https://travis-ci.org/蔡成汉/MyDrawerViewController)
[![Version](https://img.shields.io/cocoapods/v/MyDrawerViewController.svg?style=flat)](http://cocoapods.org/pods/MyDrawerViewController)
[![License](https://img.shields.io/cocoapods/l/MyDrawerViewController.svg?style=flat)](http://cocoapods.org/pods/MyDrawerViewController)
[![Platform](https://img.shields.io/cocoapods/p/MyDrawerViewController.svg?style=flat)](http://cocoapods.org/pods/MyDrawerViewController)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MyDrawerViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MyDrawerViewController', '~>0.0.1'
```

## Author

蔡成汉, 1178752402@qq.com

## License

MyDrawerViewController is available under the MIT license. See the LICENSE file for more info.

## 抽屉使用

抽屉用法非常简单，可参考Example。主要用法代码在AppDelegate里，需要注意的是侧边栏控制器需要继承SideViewController，否则无法通过侧边栏来进行页面push。其他控制器则不需要此继承。
侧边栏控制器在进行页面push的时候，需要通过方法 侧边控制器.drawerViewController exchangeContentViewController:目标控制器 来进行侧边到目标控制器的切换，否则无法进行页面push。