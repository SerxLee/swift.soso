//
//  WebView.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 2016-01-20 23:36:12
//  Copyright © 2016 serx. All rights reserved.
//

/*
  	(detail...)
*/

import UIKit
import Foundation

class ViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func testLoadHTMLString(sender: AnyObject) {
        
        //加载本地html文件, 1:获取本地html具体路径， 2：获取大概路径
        let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html") //1
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) //2
        
        do{
            
            let html = try String(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding)
            self.webView.loadHTMLString(html, baseURL: bundleUrl)

        }catch let error as NSError{
            
        }
    }
    
    
    
    //异步加载
    @IBAction func testRoadRequest(sender: AnyObject) {
        
        let url = NSURL(string: "http://www.sina.com")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        self.webView.delegate = self //把当前的视图控制器self作为UIWebView的委托对象
    }
    
    //Web视图加载失败之后调用
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        NSLog("error: %@", error!)
    }
    
    //该方法在WEB视图加载前调用，用来获取Web视图中的JavaScript事件
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //调用JavaScript语句，使用document.body.innerHTML获取页面中HTML代码的javascript语句，并在日志中输出
        NSLog("%@", webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")!)
        return true
    }
    
    //在Web视图开始加载新的界面之后调用
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
    //在Web视图完成加载新的界面之后调用
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

