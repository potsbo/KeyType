//
//  KeyEventMap.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class Remap: NSObject {
    let input: KeyCombination
    private let output: KeyCombination
    var outputKeyCode: CGKeyCode { return output.keyCode }

    init(_ from: KeyCombination, to output: KeyCombination) {
        input = from
        self.output = output
    }

    func renderEventFlag(for event: CGEvent) -> CGEventFlags {
        let rawValue = (event.flags.rawValue & ~input.flags.rawValue) | output.flags.rawValue
        return CGEventFlags(rawValue: rawValue)
    }

    func hasAnyModToAvoid(_ flags: CGEventFlags) -> Bool {
        return flags.rawValue & input.withoutModifier.rawValue == 0
    }
}
