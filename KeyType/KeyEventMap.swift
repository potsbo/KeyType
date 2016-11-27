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
    private let output: KeyCombination
    var outputValue: Int64 { get { return Int64(outputKeyCode) } }
    var outputKeyCode: CGKeyCode { get { return output.keyCode } }
    
    init(_ from: KeyCombination, to: KeyCombination) {
        self.input  = from
        self.output = to
    }
    
    func renderEventFlagFor(event: CGEvent) -> CGEventFlags {
        let rawValue = (event.flags.rawValue & ~input.flags.rawValue) | output.flags.rawValue
        return CGEventFlags(rawValue: rawValue)
    }
    
    func hasAnyModToAvoid(_ flags: CGEventFlags) -> Bool {
        return flags.rawValue & self.input.withoutModifier.rawValue == 0
    }
}
