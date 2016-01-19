//
//  MyPlayground.swift
//  
//
//  Created by Serx on 15/12/21.
//
//  get global queue

import Foundation

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

/*
    QOS_CLASS_USER_INTERACTIVE：
    user interactive等级表示任务需要被立即执行以提供好的用户体验。
    使用它来更新UI，响应事件以及需要低延时的小工作量任务。这个等级的工作总量应该保持较小规模
*/
var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
}

/*
    user initiated
    等级表示任务由UI发起并且可以异步执行。
    它应该用在用户需要即时的结果同时又要求可以继续交互的任务
*/
var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
}


/*
    utility等级表示需要长时间运行的任务，
    常常伴随有用户可见的进度指示器。使用它来做计算，I/O，网络，持续的数据填充等任务
*/
var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)
}
/*
    background等级表示那些用户不会察觉的任务。
    使用它来执行预加载，维护或是其它不需用户交互和对时间不敏感的任务。
*/
var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)
}