//
//  WKWebView_NavigationDelegate.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 2016-01-21 00:11:18
//  Copyright © 2016 serx. All rights reserved.
//

/*
								替代Webview
  	WKWebView相关的协议有：
     WKNavigationDelegate 和 WKUIDelegate:
        WKNavigationDelegate 主要与Web视图界面加载过程相关，
        WKUIDelegate 主要与Web 视图界面显示和提示框相关
*/

import UIKit
import Foundation

class ViewController: UIViewController, WKNavigationDelegate{

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(self.webView)
    }
    
    @IBAction func testLoadHTMLString(sender: AnyObject) {
        
        //获取本地HTML路径
        let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) //基本路径
        
        do{
            
            //将html里面的内容以NSUTF8StringEncoding格式的string 保存
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
        self.webView.navigationDelegate = self
    }
    
    //Invoked when a main frame page load starts.
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("didStartProvisionalNavigation")
    }
    
    
    //Invoked when content starts arriving for the main frame
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        NSLog("didCommitNavigation")
    }
    
    //Invoked when a main frame load completes.
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        NSLog("didFinishNavigation")
    }
    
    //Invoked when an error occurs during a committed main frame navigation.
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("didFailProvisionalNavigation")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
