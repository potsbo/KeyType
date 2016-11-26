//
//  KeyEventMap.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyEventMap: NSObject {
    let keyCode: UInt16
    let virtualKey: UInt16
    let withoutModifier: NSEventModifierFlags
    
    init(from: UInt16, to: UInt16, whenWithout: NSEventModifierFlags) {
        self.keyCode         = from
        self.virtualKey      = to
        self.withoutModifier = whenWithout
    }
    
    convenience init(from: Key, to: Key, whenWithout: NSEventModifierFlags) {
        self.init(from: from.rawValue, to: to.rawValue, whenWithout: whenWithout)
    }
}


