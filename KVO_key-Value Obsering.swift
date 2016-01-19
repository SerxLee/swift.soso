//
//  ViewController.swift
// 
//  KVO
// 在 Swift 中使用 KVO 的前提条件：
// 	1.观察者和被观察者都必须是 NSObject 的子类；
// 	2.观察的属性需要使用 @dynamic 关键字修饰
//
//  Created by Serx on 1/15/16.
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit

class MyObjectObserve: NSObject{
    dynamic var myDate = NSDate()
    
    func update(){
        myDate = NSDate()
    }
}

private var myContext = 0

class ViewController: UIViewController {

    var myObject : MyObjectObserve!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        myObject = MyObjectObserve()
        print("初始化 Myclass， 当前日期:\(myObject.myDate)")
        
        myObject.addObserver(self,
            forKeyPath: "myDate",
            options: NSKeyValueObservingOptions.New,
            context: &myContext)
        
        myObject.update()
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext{
            
            if let newDate = change?[NSKeyValueChangeNewKey]{
                print("日期发生变化: \(newDate)")
                
            } else{
                // TODO: to complete the explantion
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}