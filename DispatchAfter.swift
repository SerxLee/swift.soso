//
//  MyPlayground.swift
//  
//
//  Created by Serx on 15/12/21.
//
// 

import Foundation

typealias Task = (cancel : Bool) -> ()

func delay(time: Int, task:()->()) ->  Task? {

    /*

        getDispatchTimeByDate：
        把NSDate转成dispatch_time_t

    */
    func getDispatchTimeByDate(date: NSDate) -> dispatch_time_t {
        let interval = date.timeIntervalSince1970
        var second = 0.0
        let subsecond = modf(interval, &second)
        var time = timespec(
            tv_sec: __darwin_time_t(second),
             tv_nsec: (Int)(subsecond * (Double)(NSEC_PER_SEC)))
        return dispatch_walltime(&time, 0)
    } 

    func dispatch_later(block:()->()) { //type: 1
        let dispatchTime = getDispatchTimeByDate(NSDate(timeIntervalSinceNow: time))
        dispatch_after(
            diapatchTime,
            dispatch_get_main_queue(),
            block)
    }

    /*
        type :2 这句dispatch_after的真正含义是在10秒后把任务添加进队列中，
        并不是表示在10秒后执行，大部分情况该函数能达到我们的预期，
        只有在对时间要求非常精准的情况下才可能会出现问题。

        调用函数时　time:NSTimeInterval
    */

    /*
    func dispatch_later(block:()->()) { //type:2

        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW, 
                Int64(time * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue(),
            block)
    }
    */

    var closure: dispatch_block_t? = task
    var result: Task?

    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                dispatch_async(
                    dispatch_get_main_queue(),
                     internalClosure)
            }
        }
        closure = nil
        result = nil
    }

    result = delayedClosure

    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(cancel: false)
        }
    }

    return result;
}

func cancel(task:Task?) {
    task?(cancel: true)
}


