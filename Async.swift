//
//  Async.swift
//
//  Created by Tobias DM on 15/07/14.
//
//	OS X 10.10+ and iOS 8.0+
//	Only use with ARC
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation


// MARK: - DSL for GCD queues

/**
 `GCD` is an empty struct with convenience static functions to get `dispatch_queue_t` of different quality of service classes, as provided by `dispatch_get_global_queue`.
 
 let utilityQueue = GCD.utilityQueue()
 
 - SeeAlso: Grand Central Dispatch
 */
private struct GCD {
    
    static func mainQueue() -> dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    static func userInteractiveQueue() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }
    

    static func userInitiatedQueue() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }
    

    static func utilityQueue() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }
    

    static func backgroundQueue() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }
}


public struct Async {
    
    private let block: dispatch_block_t
    
    private init(_ block: dispatch_block_t) {
        self.block = block
    }
    

    public static func main(after after: Double? = nil, block: dispatch_block_t) -> Async {
        return Async.async(after, block: block, queue: GCD.mainQueue())
    }
    
    /**
     Sends the a block to be run asynchronously on a queue with a quality of service of QOS_CLASS_USER_INTERACTIVE.
     */
    public static func userInteractive(after after: Double? = nil, block: dispatch_block_t) -> Async {
        return Async.async(after, block: block, queue: GCD.userInteractiveQueue())
    }
    
    /**
     Sends the a block to be run asynchronously on a queue with a quality of service of QOS_CLASS_USER_INITIATED.
     */
    public static func userInitiated(after after: Double? = nil, block: dispatch_block_t) -> Async {
        return Async.async(after, block: block, queue: GCD.userInitiatedQueue())
    }
    
    /**
     Sends the a block to be run asynchronously on a queue with a quality of service of QOS_CLASS_UTILITY.
     */
    public static func utility(after after: Double? = nil, block: dispatch_block_t) -> Async {
        return Async.async(after, block: block, queue: GCD.utilityQueue())
    }
    
    /**
     Sends the a block to be run asynchronously on a queue with a quality of service of QOS_CLASS_BACKGROUND.
     */
    public static func background(after after: Double? = nil, block: dispatch_block_t) -> Async {
        return Async.async(after, block: block, queue: GCD.backgroundQueue())
    }
    
    /**
     Sends the a block to be run asynchronously on a custom queue.
     */
    public static func customQueue(queue: dispatch_queue_t, after: Double? = nil, block: dispatch_block_t) -> Async {
        return Async.async(after, block: block, queue: queue)
    }
    
    
    // MARK: - Private static methods
    private static func async(seconds: Double? = nil, block chainingBlock: dispatch_block_t, queue: dispatch_queue_t) -> Async {
        if let seconds = seconds {
            return asyncAfter(seconds, block: chainingBlock, queue: queue)
        }
        return asyncNow(chainingBlock, queue: queue)
    }
    
    private static func asyncNow(block: dispatch_block_t, queue: dispatch_queue_t) -> Async {

        let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        // Add block to queue
        dispatch_async(queue, _block)
        // Wrap block in a struct since dispatch_block_t can't be extended
        return Async(_block)
    }
    
    private static func asyncAfter(seconds: Double, block: dispatch_block_t, queue: dispatch_queue_t) -> Async {
        let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        return at(time, block: block, queue: queue)
    }
    
    private static func at(time: dispatch_time_t, block: dispatch_block_t, queue: dispatch_queue_t) -> Async {
        // See Async.async() for comments
        let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        dispatch_after(time, queue, _block)
        return Async(_block)
    }
    
    
    // MARK: - Instance methods (matches static ones)
    public func main(after after: Double? = nil, chainingBlock: dispatch_block_t) -> Async {
        return chain(after, block: chainingBlock, queue: GCD.mainQueue())
    }

    public func userInteractive(after after: Double? = nil, chainingBlock: dispatch_block_t) -> Async {
        return chain(after, block: chainingBlock, queue: GCD.userInteractiveQueue())
    }
    

    public func userInitiated(after after: Double? = nil, chainingBlock: dispatch_block_t) -> Async {
        return chain(after, block: chainingBlock, queue: GCD.userInitiatedQueue())
    }
    

    public func utility(after after: Double? = nil, chainingBlock: dispatch_block_t) -> Async {
        return chain(after, block: chainingBlock, queue: GCD.utilityQueue())
    }
    
    
    public func background(after after: Double? = nil, chainingBlock: dispatch_block_t) -> Async {
        return chain(after, block: chainingBlock, queue: GCD.backgroundQueue())
    }
    

    public func customQueue(queue: dispatch_queue_t, after: Double? = nil, chainingBlock: dispatch_block_t) -> Async {
        return chain(after, block: chainingBlock, queue: queue)
    }
    
    // MARK: - Instance methods
    
    /**
     Usage:
     
     let block1 = Async.background {
     // Some work
     }
     let block2 = block1.background {
     // Some other work
     }
     Async.main {
     // Cancel async to allow block1 to begin
     block1.cancel() // First block is NOT cancelled
     block2.cancel() // Second block IS cancelled
     }
     */
    public func cancel() {
        dispatch_block_cancel(block)
    }
    
    
    /**
     Convenience function to call `dispatch_block_wait()` on the encapsulated block.
     Waits for the current block to finish, on any given thread.
     */
    public func wait(seconds seconds: Double! = nil) {
        if seconds != nil {
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
            dispatch_block_wait(block, time)
        } else {
            dispatch_block_wait(block, DISPATCH_TIME_FOREVER)
        }
    }
    
    // MARK: Private instance methods

    private func chain(seconds: Double? = nil, block chainingBlock: dispatch_block_t, queue: dispatch_queue_t) -> Async {
        if let seconds = seconds {
            return chainAfter(seconds, block: chainingBlock, queue: queue)
        }
        return chainNow(block: chainingBlock, queue: queue)
    }
    

    private func chainNow(block chainingBlock: dispatch_block_t, queue: dispatch_queue_t) -> Async {
        // See Async.async() for comments
        let _chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
        dispatch_block_notify(block, queue, _chainingBlock)
        return Async(_chainingBlock)
    }
    

    private func chainAfter(seconds: Double, block chainingBlock: dispatch_block_t, queue: dispatch_queue_t) -> Async {
        // Create a new block (Qos Class) from block to allow adding a notification to it later (see Async)
        // Create block with the "inherit" type
        let _chainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock)
        
        // Wrap block to be called when previous block is finished
        let chainingWrapperBlock: dispatch_block_t = {
            // Calculate time from now
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
            dispatch_after(time, queue, _chainingBlock)
        }
        // Create a new block (Qos Class) from block to allow adding a notification to it later (see Async)
        // Create block with the "inherit" type
        let _chainingWrapperBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingWrapperBlock)
        // Add block to queue *after* previous block is finished
        dispatch_block_notify(self.block, queue, _chainingWrapperBlock)
        // Wrap block in a struct since dispatch_block_t can't be extended
        return Async(_chainingBlock)
    }
}


// MARK: - Apply - DSL for `dispatch_apply`

/**
 `Apply` is an empty struct with convenience static functions to parallelize a for-loop, as provided by `dispatch_apply`.
 
 Apply.background(100) { i in
 // Calls blocks in parallel
 }
 
 `Apply` runs a block multiple times, before returning. If you want run the block asynchronously from the current thread, wrap it in an `Async` block:
 
 Async.background {
 Apply.background(100) { i in
 // Calls blocks in parallel asynchronously
 }
 }
 
 - SeeAlso: Grand Central Dispatch, dispatch_apply
 */
public struct Apply {
    
    public static func userInteractive(iterations: Int, block: Int -> ()) {
        dispatch_apply(iterations, GCD.userInteractiveQueue(), block)
    }
    

    public static func userInitiated(iterations: Int, block: Int -> ()) {
        dispatch_apply(iterations, GCD.userInitiatedQueue(), block)
    }
    

    public static func utility(iterations: Int, block: Int -> ()) {
        dispatch_apply(iterations, GCD.utilityQueue(), block)
    }
    

    public static func background(iterations: Int, block: Int -> ()) {
        dispatch_apply(iterations, GCD.backgroundQueue(), block)
    }
    

    public static func customQueue(iterations: Int, queue: dispatch_queue_t, block: Int -> ()) {
        dispatch_apply(iterations, queue, block)
    }
}


// MARK: - AsyncGroup – Struct

/**
 The **AsyncGroup** struct facilitates working with groups of asynchronous blocks. Handles a internally `dispatch_group_t`.
 
 Multiple dispatch blocks with GCD:
 
 let group = AsyncGroup()
 group.background {
 // Run on background queue
 }
 group.utility {
 // Run on untility queue, after the previous block
 }
 group.wait()
 
 All moderns queue classes:
 
 group.main {}
 group.userInteractive {}
 group.userInitiated {}
 group.utility {}
 group.background {}
 
 Custom queues:
 
 let customQueue = dispatch_queue_create("Label", DISPATCH_QUEUE_CONCURRENT)
 group.customQueue(customQueue) {}
 
 Wait for group to finish:
 
 let group = AsyncGroup()
 group.background {
 // Do stuff
 }
 group.background {
 // Do other stuff in parallel
 }
 // Wait for both to finish
 group.wait()
 // Do rest of stuff
 
 - SeeAlso: Grand Central Dispatch
 */
public struct AsyncGroup {
    
    // MARK: - Private properties and init
    
    /**
     Private property to hold internally on to a `dispatch_group_t`
     */
    var group: dispatch_group_t
    
    /**
     Private init that takes a `dispatch_group_t`
     */
    public init() {
        group = dispatch_group_create()
    }
    
    
    /**
     Convenience for `dispatch_group_async()`
     
     - parameters:
     - block: The block that is to be passed to be run on the `queue`
     - queue: The queue on which the `block` is run.
     
     - SeeAlso: dispatch_group_async, dispatch_group_create
     */
    private func async(block block: dispatch_block_t, queue: dispatch_queue_t) {
        dispatch_group_async(group, queue, block)
    }
    
    /**
     Convenience for `dispatch_group_enter()`. Used to add custom blocks to the current group.
     
     - SeeAlso: dispatch_group_enter, dispatch_group_leave
     */
    public func enter() {
        dispatch_group_enter(group)
    }
    
    public func leave() {
        dispatch_group_leave(group)
    }
    
    public func main(block: dispatch_block_t) {
        async(block: block, queue: GCD.mainQueue())
    }
    

    public func userInteractive(block: dispatch_block_t) {
        async(block: block, queue: GCD.userInteractiveQueue())
    }
    

    public func userInitiated(block: dispatch_block_t) {
        async(block: block, queue: GCD.userInitiatedQueue())
    }
    

    public func utility(block: dispatch_block_t) {
        async(block: block, queue: GCD.utilityQueue())
    }

    public func background(block: dispatch_block_t) {
        async(block: block, queue: GCD.backgroundQueue())
    }
    

    public func customQueue(queue: dispatch_queue_t, block: dispatch_block_t) {
        async(block: block, queue: queue)
    }

    public func wait(seconds seconds: Double! = nil) {
        if seconds != nil {
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
            dispatch_group_wait(group, time)
        } else {
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        }
    }
    
}


// MARK: - Extension for `qos_class_t`

/**
 Extension to add description string for each quality of service class.
 */
public extension qos_class_t {
    
    /**
     Description of the `qos_class_t`. E.g. "Main", "User Interactive", etc. for the given Quality of Service class.
     */
    var description: String {
        get {
            switch self {
            case qos_class_main(): return "Main"
            case QOS_CLASS_USER_INTERACTIVE: return "User Interactive"
            case QOS_CLASS_USER_INITIATED: return "User Initiated"
            case QOS_CLASS_DEFAULT: return "Default"
            case QOS_CLASS_UTILITY: return "Utility"
            case QOS_CLASS_BACKGROUND: return "Background"
            case QOS_CLASS_UNSPECIFIED: return "Unspecified"
            default: return "Unknown"
            }
        }
    }
}
