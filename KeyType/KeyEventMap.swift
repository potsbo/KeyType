//
//  KeyEventMap.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyEventMap: NSObject {
    let input:  KeyCombination
    let output: KeyCombination
    var outputValue: Int64 {
        get { return Int64(output.keyCode) }
    }
    var outputKeyCode: CGKeyCode {
        get { return output.keyCode }
    }
    
    init(_ from: KeyCombination, to: KeyCombination) {
        print(from.toString())
        self.input  = from
        self.output = to
    }
    
    func renderEventFlagFor(event: CGEvent) -> CGEventFlags {
        let rawValue = (event.flags.rawValue & ~input.flags.rawValue) | output.flags.rawValue
        return CGEventFlags(rawValue: rawValue)
    }
    
    var withoutModifier: CGEventFlags {
        get { return self.input.withoutModifier }
    }
    
    func hasAnyModToAvoid(_ flags: CGEventFlags) -> Bool {
        return flags.rawValue & self.withoutModifier.rawValue == 0
    }
}
