//
//  ViewController.swift
//  GestureTutorial
//
//  Created by Serx on 1/12/16.
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var pinchView: UIView!
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var longPressView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var dragView: UIView!
    
    
    //为每一个View声明一个手势对象
    var lastRotation = CGFloat()
    let tapRec = UITapGestureRecognizer()
    let pinchRec = UIPinchGestureRecognizer()
    let swipeRec = UISwipeGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //为每个视图设定手势识别的目标。所谓的目标，就是每个view中的手势完成后要调用的方法。
        tapRec.addTarget(self.view, action: "tappedView")
        pinchRec.addTarget(self.view, action: "pinchedView")
        swipeRec.addTarget(self.view, action: "swipedView")
        longPressRec.addTarget(self.view, action: "longPressView")
        rotateRec.addTarget(self.view, action: "rotateView")
        panRec.addTarget(self.view, action: "draggedView")
        
        //把手势识别添加到视图中.
        tapView.addGestureRecognizer(tapRec)
        pinchView.addGestureRecognizer(pinchRec)
        rotateView.addGestureRecognizer(rotateRec)
        longPressView.addGestureRecognizer(longPressRec)
        swipeView.addGestureRecognizer(swipeRec)
        dragView.addGestureRecognizer(panRec)
        
        //把每个视图的userInterationEnabled属性设为true，并把需要多点触控的手势(rotateView and pinchView)所在的view属性设为true
        rotateView.userInteractionEnabled = true
        rotateView.multipleTouchEnabled = true
        pinchView.userInteractionEnabled = true
        pinchView.multipleTouchEnabled = true
        tapView.userInteractionEnabled = true
        dragView.userInteractionEnabled = true
        longPressView.userInteractionEnabled = true
        swipeView.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //每个手势的调用方法
    func tappedView(){
        let tapAlert = UIAlertController(title: "Tapped", message: "you tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    func swipedView(){
        let swipeAlert = UIAlertController(title: "swiped", message: "you swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
        swipeAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(swipeAlert, animated: true, completion: nil)
    }
    
    func longPressedView(){
        let longPressAlert = UIAlertController(title: "long Pressed", message: "you long pressed long press view", preferredStyle: UIAlertControllerStyle.Alert)
        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(longPressAlert, animated: true, completion: nil)
    }
    
    //rotate an pinch 这两种手势识别器（有点复杂）
    func rotatedView(sender:UIRotationGestureRecognizer){
        var lastRotation = CGFloat()
        self.view.bringSubviewToFront(rotateView)
        if(sender.state == UIGestureRecognizerState.Ended){
            lastRotation = 0.0
        }
        let rotation = 0.0 - (lastRotation - sender.rotation)
        //计算rotate view 的旋转程度
        var point  = rotateRec.locationInView(rotateView)
        var currentTrans = sender.view!.transform
        //设置rotate view 的旋转程度
        var newTrans = CGAffineTransformRotate(currentTrans, rotation)
        sender.view?.transform = newTrans
        lastRotation = sender.rotation
        
    }
    
    //捏
    func pinchedView(sender:UIPinchGestureRecognizer){
        self.view.bringSubviewToFront(pinchView)
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
    }
    
    //拖拉
    func draggedView(sender: UIPanGestureRecognizer){
        self.view.bringSubviewToFront(dragView)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, inView: self.view)
    }

}

