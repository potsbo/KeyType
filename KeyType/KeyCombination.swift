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
    var flags         = CGEventFlags()
    private var withoutFlags  = CGEventFlags()
    private var addToWithFlag = true

    var withoutModifier: CGEventFlags {
        get { return withoutFlags }
    }

    init(fromEvent: CGEvent) {
        self.keyCode = fromEvent.keyCode
        self.flags   = fromEvent.flags
    }

    init(_ key: Key) {
        self.keyCode = key.rawValue
    }

    private func addMask(_ mask: CGEventFlags) -> KeyCombination {
        if self.addToWithFlag {
            self.flags.insert(mask)
        } else {
            self.withoutFlags.insert(mask)
        }
        return self
    }

    var shift: KeyCombination {
        get { return self.addMask(.maskShift) }
    }

    var ctrl: KeyCombination {
        get { return self.addMask(.maskControl) }
    }

    var command: KeyCombination {
        get { return self.addMask(.maskCommand) }
    }

    var option: KeyCombination {
        get { return self.addMask(.maskAlternate) }
    }

    private func setModeExAddition() {
        self.addToWithFlag = false
    }

    var without: KeyCombination {
        get {
            self.setModeExAddition()
            return self
        }
    }

    var label: String {
        get {
            guard let key = Key(rawValue: keyCode) else { return flagString }
            return flagString + String(describing: key)
        }
    }

    private var flagString: String {
        get {
            var flagString = ""
            if has(modifier: .maskSecondaryFn) { flagString += "(fn)" }
            if has(modifier: .maskAlphaShift) { flagString += "⇪" }
            if has(modifier: .maskCommand) { flagString += "⌘" }
            if has(modifier: .maskShift) { flagString += "⇧" }
            if has(modifier: .maskControl) { flagString += "⌃" }
            if has(modifier: .maskAlternate) { flagString += "⌥" }
            return flagString
        }

    }

    private func has(modifier key: CGEventFlags ) -> Bool {
        return self.flags.contains(key)
    }

    func postEvent() {
        let loc = CGEventTapLocation.cghidEventTap

        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        let keyUpEvent   = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!

        keyDownEvent.flags = flags
        keyUpEvent.flags   = CGEventFlags()

        keyDownEvent.post(tap: loc)
        keyUpEvent.post(tap: loc)
    }

    func isCompatibleWith(_ mapping: KeyEventMap) -> Bool {
        let cmb = mapping.input
        if  cmb.has(modifier: .maskCommand)     && !self.has(modifier: .maskCommand)     ||
            cmb.has(modifier: .maskShift)       && !self.has(modifier: .maskShift)       ||
            cmb.has(modifier: .maskControl)     && !self.has(modifier: .maskControl)     ||
            cmb.has(modifier: .maskAlternate)   && !self.has(modifier: .maskAlternate)   ||
            cmb.has(modifier: .maskSecondaryFn) && !self.has(modifier: .maskSecondaryFn) ||
            cmb.has(modifier: .maskAlphaShift)  && !self.has(modifier: .maskAlphaShift) {
            return false
        }
        return mapping.hasAnyModToAvoid(flags)
    }
}
