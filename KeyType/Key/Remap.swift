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

    init(_ from: KeyCombination, to output: Key) {
        input = from
        self.output = output.alone
    }

    func renderEventFlag(for event: CGEvent) -> CGEventFlags {
        let rawValue = (event.flags.rawValue & ~input.withFlags.rawValue) | output.withFlags.rawValue
        return CGEventFlags(rawValue: rawValue)
    }
}
