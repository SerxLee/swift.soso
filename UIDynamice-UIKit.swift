//
//  UIDynamice-UIKit.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 2016-03-08 20:26:22
//  Copyright © 2016 serx. All rights reserved.
//

/*
  	My design centred around rising and falling blocks that represented the different parts of my life. These blocks had mass and density and elasticity, and they responded in a lively way. And, like little blocks in a glass case, I wanted them to fall away when the device rotated.
*/

import UIKit
import Foundation

class ViewController: UIViewController {
    // MARK: - Blocks
    
    // Our block
    lazy var greenBlock: UIView = {
        let view = UIView(frame: CGRect(x: 50.0, y: 50.0, width: 100.0, height: 100.0))
        view.backgroundColor = UIColor.greenColor()
        return view
    }()
    
    lazy var orangeBlock: UIView = {
        let view = UIView(frame: CGRect(x: 125.0, y: 190.0, width: 50.0, height: 50.0))
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    
    // MARK: - Dynamics properties
    // Animator for all of the components
    var itemsAnimator: UIDynamicAnimator?
    
    // Gravity for the system
    var gravityBehavior: UIGravityBehavior?
    
    lazy var regularGravityVector: CGVector = {
        CGVector(dx: 0, dy: 1.0)
    }()
    
    lazy var invertedGravityVector: CGVector = {
        CGVector(dx: 0, dy: -1.0)
    }()
    
    // Collisions
    var boundaryCollisionBehavior: UICollisionBehavior?
    
    // Elasticity
    var elasticityBehavior: UIDynamicItemBehavior?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for orientation changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
        
        // Add our blocks to the view
        view.addSubview(greenBlock)
        view.addSubview(orangeBlock)
        
        let blocks = [greenBlock, orangeBlock]
        
        // Our master item animator
        itemsAnimator = UIDynamicAnimator(referenceView: view)
        
        // The gravity for our system
        gravityBehavior = UIGravityBehavior(items: blocks)
        
        // The collision between our items, and with the boundary of the containing view
        boundaryCollisionBehavior = UICollisionBehavior(items: blocks)
        boundaryCollisionBehavior?.translatesReferenceBoundsIntoBoundary = true
        
        // The elasticity for the blocks
        elasticityBehavior = UIDynamicItemBehavior(items: blocks)
        elasticityBehavior?.elasticity = 0.6
        
        // Add everything
        itemsAnimator?.addBehavior(gravityBehavior)
        itemsAnimator?.addBehavior(boundaryCollisionBehavior)
        itemsAnimator?.addBehavior(elasticityBehavior)
    }
    
    // MARK: - Orientation
    func orientationChanged(notification: NSNotification) {
        if let device = notification.object as? UIDevice {
            switch device.orientation {
            case .Portrait:
                portraitOrientationChange()
            case .PortraitUpsideDown:
                portraitUpsideDownOrientationChange()
            default:
                return
            }
        }
    }
    
    /**
    * This function handles the response when the device rotates into regular portrait orientation.
    */
    func portraitOrientationChange() {
        // Change gravity direction
        gravityBehavior?.gravityDirection = regularGravityVector
    }
    
    /**
    * This function handles the response when the device rotates into upside-down portrait orientation.
    */
    func portraitUpsideDownOrientationChange() {
        // Flip our gravity
        gravityBehavior?.gravityDirection = invertedGravityVector
    }

}

