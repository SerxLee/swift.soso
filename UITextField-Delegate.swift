//
//  UITextField-Delegate.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 2016-01-19 23:32:01
//  Copyright © 2016 serx. All rights reserved.
//

/*
  	UITextField and the UITextFieldDelegate
  	通过委托来实现功能，关闭键盘
*/

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self

    }
    
    
    //MARK: 实现UITextFieldDelegate 委托协议方法
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        NSLog("call textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        NSLog("call textFieldEidting")
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        NSLog("call textFieldshouldEndEditing")
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        NSLog("call textFieldDidEditing")
    }
    
    //放弃第一响应来关闭键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        NSLog("call textFieldShouldReturn")
        
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
