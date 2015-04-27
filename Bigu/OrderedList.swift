//
//  OrderedList.swift
//  Bigu
//
//  Created by Bruno Chroniaris on 4/18/15.
//  Copyright (c) 2015 Universidade Federal De Alagoas. All rights reserved.
//

import Foundation

public class OrderedList<T> {
    // MARK: -Properties
    public var order: (T, T) -> Bool {
        didSet {
            self.list.sort(self.order)
        }
    }
    private var list: Array<T> = Array<T>()
    public var count: Int {
        return self.list.count
    }
    
    // MARK: -Methods
    public init(isOrderedBefore: (T, T) -> Bool) {
        self.order = isOrderedBefore
    }
    
    public func insert(object: T) {
        var i = 0
        let array = self.list
        for cur in array {
            if order(object, cur) {
                break;
            }
            i++
        }
        self.list.insert(object, atIndex: i)
    }
    
    public func insert(array: [T]) {
        for cur in array {
            self.insert(cur)
        }
    }
    
    public func insert(list: OrderedList<T>) {
        for cur in list.list {
            self.insert(cur)
        }
    }
    
    public func getFirstObject() -> T? {
        return self.count > 0 ? self.list[0] : nil
    }
    
    public func getLastObject() -> T? {
        return self.count > 0 ? self.list[self.list.count - 1] : nil
    }
    
    public func getElementAtIndex(index: Int) -> T? {
        return index < self.count ? self.list[index] : nil
    }
    
    public func removeAtIndex(index: Int) {
        if index < self.count {
            self.list.removeAtIndex(index)
        }
    }
    
    public func removeObject(parameter: (T) -> Bool) -> Bool {
        var result = false
        
        var i = 0
        for cur in self.list {
            if parameter(cur) {
                result = true
                break
            }
            i++
        }
        removeAtIndex(i)
        
        return result
    }
    
    public func findBy(parameter: (T) -> Bool) -> OrderedList<T> {
        var desired: OrderedList<T> = OrderedList<T>(isOrderedBefore: self.order)
        
        for cur in self.list {
            if parameter(cur) {
                desired.insert(cur)
            }
        }
        
        return desired
    }
    
    public func clearList() {
        self.list = []
    }
    
    public func arrayCopy() -> Array<T> {
        var array = Array<T>()
        for cur in self.list {
            array += [cur]
        }
        return array
    }
    
    public func getObjectIndex(indexFor object: T, compareBy parameter: (T) -> Bool) -> Int? {
        var i: Int = 0
        var result: Int?
        for cur in self.list {
            if parameter(cur) {
                result = i
                break
            }
            i++
        }
        
        return result
    }
}