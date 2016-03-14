//
//  UITouch.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 2016-01-22 22:13:46
//  Copyright © 2016 serx. All rights reserved.
//

/*	
  	运用触摸事件UITocuh来 实现Event
	
	Began 当一个手指触摸屏幕时
	Moved 当一个手中在屏幕上移动时
	Stationary 当一个手指正在触摸屏幕，但是由于上次的时间它还不能移动
	Ended 当一个手指从屏幕抬起时
	Cancelled 触摸事件没有结束，但是被终止了

	触摸事件 实现 pinch！！！
		实现 pinch 需要实现 触摸开始事件touchesBegan：， 移动触摸事件 touchesMoved：， 触摸结束事件 touchesEnded：
*/

import UIKit

class MyView: UIView {

	/*
        previousDistance 保存上一次两个手指之间的距离
        zoomFactor 变量是缩放因子
        pinchZoon  变量保存的缩放可否使用
    */
    var previousDistance: CGFloat = 0.0
    var zoomFactor: CGFloat = 1.0
    var pinchZoon = false

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        if touches.count == 2{
            self.pinchZoon = true
            //转换全部触点的set集合为array
            let arrayTouchs = Array(touches)
            
            let firstTouch = arrayTouchs[0] as UITouch
            let secondTouch = arrayTouchs[1] as UITouch
            //获得first 和 second 触点在 view上的位置
            let firstPoint = firstTouch.locationInView(self)
            let secondPoint = secondTouch.locationInView(self)
            //计算两点距离
            self.previousDistance = sqrt(pow(firstPoint.x - secondPoint.x, 2.0) + pow(firstPoint.y - secondPoint.y, 2.0))
        }else{
            self.pinchZoon = false
        }
           
//        //实现单击事件
//        let touch  = touches.first! as UITouch
//        if touch.tapCount == 1{
//            self.foundTap()         //单击事件
//        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.pinchZoon == true && touches.count == 2{
            let arrayTouchs = Array(touches)
            
            let firstTouch = arrayTouchs[0] as UITouch
            let secondTouch = arrayTouchs[1] as UITouch
            //获得first 和 second 触点在 view上的位置
            let firstPoint = firstTouch.locationInView(self)
            let secondPoint = secondTouch.locationInView(self)
            //计算两点距离
            let distance = sqrt(pow(firstPoint.x - secondPoint.x, 2.0) + pow(firstPoint.y - secondPoint.y, 2.0))
            
            zoomFactor += (distance - previousDistance) / previousDistance
            if zoomFactor > 0{
                previousDistance = distance
                self.changeView.transform = CGAffineTransformMakeScale(zoomFactor, zoomFactor)
            }
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    	if touches.count != 2{
            self.pinchZoon = false
            self.previousDistance = 0.0
        }

        // NSLog("touchesEnded - touch count = %i", touches.count)
        // for touch in touches{
        //     self.logTouchInfo(touch as UITouch)
        // }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        NSLog("touchesCancelled - touch count = %i", touches!.count)
        for touch in touches!{
            self.logTouchInfo(touch as UITouch)
        }
    }
    
    /*
		locationInView： 获取触点所在视图（Myview的位置）
		touch.locationInView(nil) 通过locationInView:方法获得触点在Window中的位置
		输出日志信息方法
    */
    func logTouchInfo(touch: UITouch){
        
        let locInSelf = touch.locationInView(self)
        let locInWin = touch.locationInView(nil)
        
        NSLog("touch.locationInView = {%.2f, %.2f}", locInSelf.x.native, locInSelf.y.native)  //native 是Double类型
        NSLog("touch.locationInWin = {%.2f, %.2f}", locInWin.x.native, locInWin.y.native)
        NSLog("touch.phase = %i", touch.phase.rawValue)
        NSLog("touch.tapCount = %d", touch.tapCount)
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}