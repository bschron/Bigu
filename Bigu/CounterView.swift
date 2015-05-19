//
//  CounterView.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 5/16/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import UIKit

@IBDesignable internal class CounterView: UIView {
    // MARK: -Properties
    internal var count: Int = 0 {
        didSet{
            if self.count < 0 {
                self.count = 0
            }
            self.setCounters()
        }
    }
    @IBInspectable internal var color: UIColor = UIColor.blueColor()
    private var counters: [Counter] = []
    @IBInspectable internal var limit: Int = 3
    @IBInspectable internal var spacing: CGFloat = 4.0
    @IBInspectable internal var height: CGFloat = 8.0
    @IBInspectable internal var animated: Bool = true
    @IBInspectable internal var animationDelay: NSTimeInterval = 0
    
    // MARK: -Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.config()
    }
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }
    
    internal init(frame: CGRect, colorForCounter color: UIColor) {
        super.init(frame: frame)
        self.config()
        self.color = color
    }
    
    private func config() {
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }
    
    private func setCounters() {
        if self.counters.count > self.count {
            self.removeCounter()
        }
        else if self.counters.count < self.count {
            self.insertNewCounter()
        }
    }
    
    private func insertNewCounter() {
        if self.count > self.limit && self.counters.count >= self.limit {
            return
        }
        
        var counter: Counter!
        
        let preAction: () -> () = {
            counter = self.newCounter(isPlus: self.count >= self.limit && self.counters.count == self.limit - 1)
            self.counters += [counter]
            self.addSubview(counter)
            counter.alpha = 0.0
        }
        
        let actions: () -> () = {
            counter.alpha = 1
            self.alignCounters()
        }
        
        let completion: () -> () = {
            self.setCounters()
        }
        
        preAction()
        
        if self.animated {
            UIView.animateWithDuration(0.2, delay: self.animationDelay, options: .AllowAnimatedContent, animations: {
                actions()
                }, completion: { result in
                    // for diff > 1
                    completion()
            })
        }
        else {
            actions()
            completion()
        }
    }
    
    private func removeCounter() {
        if self.count > self.limit && self.counters.count >= self.limit {
            return
        }
        
        let actions: () -> () = {
            if self.counters.count > 0 {
                let counter = self.counters.last
                
                if let c = counter {
                    c.removeFromSuperview()
                    self.counters.removeLast()
                }
            }
        }
        
        let completion: () -> () = {
            // for diff > 1
            self.setCounters()
        }
        
        if animated {
            UIView.animateWithDuration(0.2, delay: self.animationDelay, options: .AllowAnimatedContent, animations: {
                actions()
                }, completion: { reuslt in
                    completion()
            })
        }
        else {
            actions()
            completion()
        }
    }
    
    private func alignCounters() {
        var i = 0
        for cur in self.counters {
            cur.center.y = self.center.y
            cur.frame.origin.x = CGFloat(i) * (self.height + self.spacing)
            i++
        }
    }
    
    private func newCounter(isPlus plus: Bool) -> Counter {
        let frame = CGRectMake(0, 0, self.height, self.height)
        let counter = plus ? PlusCounter(frame: frame) : Counter(frame: frame)
        counter.color = self.color
        return counter
    }
    
    // MARK: -Class Properties and Methods
}
