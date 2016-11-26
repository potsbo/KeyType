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
    let withoutModifier: CGEventFlags
    var outputValue: Int64 {
        get { return Int64(output.keyCode) }
    }
    var outputKeyCode: CGKeyCode {
        get { return output.keyCode }
    }
    
    init(_ from: KeyCombination, to: KeyCombination, whenWithout: CGEventFlags?) {
        self.input  = from
        self.output = to
        self.withoutModifier = whenWithout ?? CGEventFlags()
    }
    
    convenience init(from: Key, to: Key, whenWithout: CGEventFlags?) {
        self.init(KeyCombination(from), to: KeyCombination(to), whenWithout: whenWithout)
    }
    
    func renderEventFlagFor(event: CGEvent) -> CGEventFlags {
        let rawValue = (event.flags.rawValue & ~input.flags.rawValue) | output.flags.rawValue
        return CGEventFlags(rawValue: rawValue)
    }
}
