//
//  FBTimer.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import Foundation

class FBTimer {
    static let shared = FBTimer()
    

    private var isResume:Bool = false
    
    /// 任务队列
    private var tasks:[Task] = []
//    private var link:CADisplayLink?
    private var timer = DispatchSource.makeTimerSource(queue: .global())

    private  init() {
        timer.schedule(deadline: .now(), repeating: .milliseconds(100))
        timer.setEventHandler { [weak self] in
            self?.processingHandler()
        }
        resume()
    }

    @objc private func processingHandler() {
//        print("processingHandler")
        let now = Date().timeIntervalSince1970
        self.tasks.forEach({ (obj) in
            if  now > obj.lastDate + obj.interval  , let block = obj.handler {
                obj.lastDate = now
                #if DEBUG
                print("now:\(now) > \(obj.lastDate + obj.interval) interval: \(obj.interval) lastDate:\(obj.lastDate)")
                #endif
                DispatchQueue.main.async(execute: block)
            }
        })
    }
    
    var currentTimestamp:TimeInterval? {
        CFAbsoluteTimeGetCurrent()
    }
    
    var isresume = false
}


extension FBTimer {
    
    
    
    func suspend(){
        guard isresume else { return }
        timer.suspend()
        isresume = false
    }
    
    func resume(){
        guard !isresume else { return }
        timer.resume()
        isresume = true
    }
    
    
    
    /* interval: 单位：ms
     * target: 代理目标
     *
     */
    public func registerHandler(target:AnyObject, interval: Double, handler: @escaping FBCallback) {
        if !self.tasks.contains(where: { $0.target === target }) {
            let obj = Task()
            obj.target = target
            obj.interval = interval
            obj.lastDate = Date().timeIntervalSince1970
            obj.handler = handler
            self.tasks.append(obj)
        }
    }
    
    
    
    
    
    
    
    
    
    
    private func remove( objects: [Task]) {
        self.tasks.removeAll(objects)
    }
    
    func remove(target: AnyObject?) {
        let tasks = self.tasks.filter {
            if $0.target == nil { return true }
            if let object = $0.target, let target = target, object === target {
                return true
            }
            return false
        }
        self.tasks.removeAll(tasks)
    }

    func contains(target: AnyObject) -> Bool {
        return self.tasks.contains(where: { $0.target === target })
    }
}


extension FBTimer {
    private class Task : Equatable {
        fileprivate var lastDate:TimeInterval = 0
        var interval:Double = 1000.0     //间隔
        var handler: FBCallback?          //执行
        weak var target:AnyObject?       //弱引用、防止不会被释放
        
        static func == (lhs: Task, rhs: Task) -> Bool {
            return Unmanaged.passUnretained(lhs).toOpaque() == Unmanaged.passUnretained(rhs).toOpaque()
        }
    }


}
