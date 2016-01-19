//
//  MyPlayground.swift
//  
//
//  Created by Serx on 15/12/21.
//
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mailPattern =
        "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = RegexHelper(mailPattern)
        let maybeMailAddress = "lesvio@qq.com"
        if matcher.match(maybeMailAddress) {
            println("valid email")
        }
    }
    

    //swift  正则匹配

    struct RegexHelper {
        let regex: NSRegularExpression?
        init(_ pattern: String) {
            var error: NSError?
            regex = NSRegularExpression(
                pattern: pattern,
                options: .CaseInsensitive,
                error: &error)
        }
        
        func match(input: String) -> Bool {
            if let matches = regex?.matchesInString(input,
                options: nil,
                range: NSMakeRange(0, count(input))) {
                return matches.count > 0
            } else {
                return false
            }
        }
    }

    /*
        定义操作符 infix operator hear{}
        
        precedence运算的优先级，越高的话优先进行计算。
        swift 中乘法和除法的优先级是 150 ，加法和减法的优先级是 140 ，
        这里我们定义点积的优先级为 160 ，就是说应该早于普通的乘除进行运算。
        
        重载操作符

    */
    infix operator =~ {
        associativity none
        precedence 130  
    }

    func =~(lhs: String, rhs: String) -> Bool {
        return RegexHelper(rhs).match(lhs)
    }



}


