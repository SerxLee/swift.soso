//
//  ViewController.swift
//  GestureTutorial
//
//  Created by Serx on 1/12/16.
//  Copyright © 2016 serx. All rights reserved.
//

/*
    一共有七种手势识别器，在这里 Screen Edge Pan(屏幕边缘平移)没写
*/

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var pinchView: UIView!
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var longPressView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var dragView: UIView!
    
    
    //为每一个View声明一个手势对象
    var lastRotation = CGFloat() //旋转时，保存之前角度的变量

    var currentScale: CGFloat = 1.0

    let tapRec = UITapGestureRecognizer()
    tapRec.numberOfTapRequired = 1          //触发Tap单击次数
    tapRec.numberOfTouchesRequired = 1      //触发Tap触点个数

    let pinchRec = UIPinchGestureRecognizer()
    let swipeRec = UISwipeGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            为每个视图设定手势识别的目标。所谓的目标，就是每个view中的手势完成后要调用的方法。
            关于手势识别器
            如果调用的方法action 是有参数的， 则需要在方法名后面加 ":" ，“tappedView:”
        */
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
    
    /*
        每个手势的指定的回调方法
            回调的方法可以带参数，tappedView(paramSendar: UITapGestureRecognizer){}
    */
    func tappedView(){
        let tapAlert = UIAlertController(title: "Tapped", message: "you tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    //滑动
    func swipedView(paramSendar: UISwipeGestureRecognizer){

        NSlog("paramSendar.direction = %i", paramSendar.direction.rawValue)
        switch paramSendar.direction{
        case UISwipeGestureRecognizerDirection.Down:
            NSlog("slip down")
        case UISwipeGestureRecognizerDirection.Up:
            NSlog("slip up")
        case UISwipeGestureRecognizerDirection.Left:
            NSlog("slip left")
        case UISwipeGestureRecognizerDirection.Right:
            NSlog("slip right")
        }
    }
    
    func longPressedView(){
        let longPressAlert = UIAlertController(title: "long Pressed", message: "you long pressed long press view", preferredStyle: UIAlertControllerStyle.Alert)
        longPressAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(longPressAlert, animated: true, completion: nil)
    }
    
    //rotate an pinch 这两种手势识别器（有点复杂）
    //重写了。。。。之前写的有点乱
    func rotatedView(paramSendar:UIRotationGestureRecognizer){

        //上一次角度加上本次旋转角度
        self.view.bringSubviewToFront(rotateView)
        self.rotateView.transform = CGAffineTransformMakeRotation(lastRotation + paramSender.rotation)
        //手势识别完成，保存旋转的角度
        if (paramSender.state == .Ended){
            lastRotation += paramSender.rotation
        }
        /*
        var lastRotation = CGFloat()
        self.view.bringSubviewToFront(rotateView)
        if(paramSender.state == UIGestureRecognizerState.Ended){
            lastRotation = 0.0
        }
        let rotation = 0.0 - (lastRotation - paramSender.rotation)
        //计算rotate view 的旋转程度
        var point  = rotateRec.locationInView(rotateView)
        var currentTrans = paramSender.view!.transform
        //设置rotate view 的旋转程度
        var newTrans = CGAffineTransformRotate(currentTrans, rotation)
        paramSender.view?.transform = newTrans
        lastRotation = paramSender.rotation
        */
    }
    
    //捏
    func pinchedView(paramSender: UIPinchGestureRecognizer){

        self.view.bringSubviewToFront(pinchView)
        //判断手势检测完成状态，在这种情况下，保存当前缩放因子 Scale
        if (paramSender.state == .Ended){
            currentScale = paramSender.scale
        }
        /*
            手势检测开始状态时，将上次保存的的缩放因子作为当前的缩放因子使用。
            这样可以保证视图连续变化，避免忽大忽小
        */
        else if (paramSender.state == .Begin && currentScale != 0.0){
            paramSender.scale = currentScale
        }
        //通过放射变换函数进行缩放变换
        self.rotateView.transform = CGAffineTransformMakeScale(paramSender.scale, paramSender.scale)
        /* 
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
        */
    }
    
    //拖拉
    func draggedView(sender: UIPanGestureRecognizer){
        self.view.bringSubviewToFront(dragView)
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, inView: self.view)
    }

}

