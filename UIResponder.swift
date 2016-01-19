//
//  ViewController.swift
//  lunchTest
//
//  Created by Serx on 1/12/16.
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //支持多点触控
        self.view.multipleTouchEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let t = touch as! UITouch
            if (t.tapCount == 2){
                self.view.backgroundColor = UIColor.whiteColor()
            }
            else if (t.tapCount == 1){
                self.view.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let t = touch as! UITouch
//            print(t.locationInView(self.view))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count == 2{
            let first = (touches as NSSet).allObjects[0] as! UITouch
            let second = (touches as NSSet).allObjects[1] as! UITouch
            
            let firstPiont = first.locationInView(self.view)
            let secondPiont = second.locationInView(self.view)
            
            //计算两点之间距离
            let disX = firstPiont.x - secondPiont.x
            let disY = firstPiont.y - secondPiont.y
            let initailDistance = sqrt(disX*disX + disY*disY)
            print("两点间距离：\(initailDistance)")
            
            //计算两点角度
            let heigh = secondPiont.y - firstPiont.y
            let width = secondPiont.x - firstPiont.x
            let rads = atan(heigh / width)
            let degrees = 180.0 * Double(rads) / M_PI
            print("两点间角度：\(degrees)")
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print("event canceled!")
    }

}

