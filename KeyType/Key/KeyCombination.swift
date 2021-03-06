//
//  KeyCombination.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyCombination {
    let keyCode: CGKeyCode
    var flags = CGEventFlags()
    private var withoutFlags = CGEventFlags()
    private var addToWithFlag = true

    var withoutModifier: CGEventFlags {
        return withoutFlags
    }

    init(fromEvent: CGEvent) {
        keyCode = fromEvent.keyCode
        flags = fromEvent.flags
    }

    init(_ key: Key) {
        keyCode = key.rawValue
    }

    private func addMask(_ mask: CGEventFlags) -> KeyCombination {
        if addToWithFlag {
            flags.insert(mask)
        } else {
            withoutFlags.insert(mask)
        }
        return self
    }

    var shift: KeyCombination {
        return addMask(.maskShift)
    }

    var ctrl: KeyCombination {
        return addMask(.maskControl)
    }

    var command: KeyCombination {
        return addMask(.maskCommand)
    }

    var option: KeyCombination {
        return addMask(.maskAlternate)
    }

    private func setModeExAddition() {
        addToWithFlag = false
    }

    var without: KeyCombination {
        setModeExAddition()
        return self
    }

    var label: String {
        guard let key = Key(rawValue: keyCode) else { return flagString }
        return flagString + String(describing: key)
    }

    private var flagString: String {
        var flagString = ""
        if has(modifier: .maskSecondaryFn) { flagString += "(fn)" }
        if has(modifier: .maskAlphaShift) { flagString += "⇪" }
        if has(modifier: .maskCommand) { flagString += "⌘" }
        if has(modifier: .maskShift) { flagString += "⇧" }
        if has(modifier: .maskControl) { flagString += "⌃" }
        if has(modifier: .maskAlternate) { flagString += "⌥" }
        return flagString
    }

    private func has(modifier key: CGEventFlags) -> Bool {
        return flags.contains(key)
    }

    func postEvent() {
        let loc = CGEventTapLocation.cghidEventTap

        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!

        keyDownEvent.flags = flags
        keyUpEvent.flags = CGEventFlags()

        keyDownEvent.post(tap: loc)
        keyUpEvent.post(tap: loc)
    }

    func isCompatible(with mapping: Remap) -> Bool {
        let cmb = mapping.input
        if cmb.has(modifier: .maskCommand), !has(modifier: .maskCommand) { return false }
        if cmb.has(modifier: .maskShift), !has(modifier: .maskShift) { return false }
        if cmb.has(modifier: .maskControl), !has(modifier: .maskControl) { return false }
        if cmb.has(modifier: .maskAlternate), !has(modifier: .maskAlternate) { return false }
        if cmb.has(modifier: .maskSecondaryFn), !has(modifier: .maskSecondaryFn) { return false }
        if cmb.has(modifier: .maskAlphaShift), !has(modifier: .maskAlphaShift) { return false }

        return mapping.hasAnyModToAvoid(flags)
    }
}
