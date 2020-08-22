//
//  CGEventExtension.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

extension CGEvent {
    var keyCode: CGKeyCode {
        get {
            return CGKeyCode(getIntegerValueField(.keyboardEventKeycode))
        }
        set(newValue) {
            setIntegerValueField(.keyboardEventKeycode, value: Int64(newValue))
        }
    }

    func isModiferKeyDownEvent() -> Bool {
        guard let flag = modifierMasks[keyCode] else {
            return false
        }
        return flags.contains(flag) && isModiferKeyEvent()
    }

    func isModiferKeyEvent() -> Bool {
        return modifierMasks[keyCode] != nil
    }
}

let modifierMasks: [CGKeyCode: CGEventFlags] = [
    54: CGEventFlags.maskCommand,
    55: CGEventFlags.maskCommand,
    56: CGEventFlags.maskShift,
    60: CGEventFlags.maskShift,
    59: CGEventFlags.maskControl,
    62: CGEventFlags.maskControl,
    58: CGEventFlags.maskAlternate,
    61: CGEventFlags.maskAlternate,
    63: CGEventFlags.maskSecondaryFn,
    57: CGEventFlags.maskAlphaShift,
]
