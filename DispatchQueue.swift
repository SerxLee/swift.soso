//
//  MyPlayground.swift
//  
//
//  Created by Serx on 15/12/21.
//
// 

import Foundation

/*
	Dispatch Queue是用来执行任务的队列
		Dispatch Queue分为两种：
			Serial Dispatch Queue，按添加进队列的顺序（先进先出）一个接一个的执行
			Concurrent Dispatch Queue，并发执行队列里的任务
*/

func main(){
	/*
		第二个参数为nil时返回Serial Dispatch Queue，
		当指定为 DISPATCH_QUEUE_CONCURRENT 时返回Concurrent Dispatch Queue
	*/
	let myQueue: dispatch_queue_t = dispatch_queue_create("com.xxx", nil) 

	dispatch_async(myQueue) {
	    // 在 workingQueue 中异步进行
	    println("努力工作")
	    NSThread.sleepForTimeInterval(2)  // 模拟两秒的执行时间

	    dispatch_async(dispatch_get_main_queue()) { 	  // 返回到主线程更新 UI

	    println("结束工作，更新 UI")
	    }
	}
}

