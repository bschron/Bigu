//
//  OrderedList.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

func += (inout left: OrderedList<AnyObject>, right: Array<AnyObject>) {
    for cur in right {
        left.insert(cur)
    }
}

class OrderedList<T> {
    // MARK: -Properties
    var order: (T, T) -> Bool {
        didSet {
            self.list.sort(self.order)
        }
    }
    private var list: Array<T> = []
    var count: Int {
        return self.list.count
    }
    
    // MARK: -Methods
    init(isOrderedBefore: (T, T) -> Bool) {
        self.order = isOrderedBefore
    }
    func insert(object: T) {
        var i = 0
        for cur in self.list {
            if order(object, cur) {
                break;
            }
            i++
        }
        self.list.insert(object, atIndex: i)
    }
    
    func getFirstObject() -> T? {
        return self.count > 0 ? self.list[0] : nil
    }
    
    func getLastObject() -> T? {
        return self.count > 0 ? self.list[self.list.count - 1] : nil
    }
    
    func getElementAtIndex(index: Int) -> T? {
        return index < self.count ? self.list[index] : nil
    }
    
    func removeAtIndex(index: Int) {
        if index < self.count {
            self.list.removeAtIndex(index)
        }
    }
}