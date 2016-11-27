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
    var flags:   CGEventFlags
    
    init(fromEvent: CGEvent) {
        self.keyCode = fromEvent.keyCode
        self.flags   = fromEvent.flags
    }
    
    init(keyCode: CGKeyCode, flags: CGEventFlags = CGEventFlags()) {
        self.keyCode = keyCode
        self.flags   = flags
    }
    
    convenience init(_ key: Key, withModifier: CGEventFlags = CGEventFlags()){
        self.init(keyCode: key.rawValue, flags: withModifier)
    }
    
    func addMask(_ mask: CGEventFlags) -> KeyCombination{
        self.flags = CGEventFlags(rawValue: flags.rawValue | mask.rawValue)
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
    
    func toString() -> String {
        guard let key = Key(rawValue: keyCode) else { return flagString() }
        return flagString() + String(describing: key)
    }
    
    private func flagString() -> String {
        var flagString = ""
        if has(modifier: .maskSecondaryFn) { flagString += "(fn)" }
        if has(modifier: .maskAlphaShift)  { flagString += "⇪" }
        if has(modifier: .maskCommand)     { flagString += "⌘" }
        if has(modifier: .maskShift)       { flagString += "⇧" }
        if has(modifier: .maskControl)     { flagString += "⌃" }
        if has(modifier: .maskAlternate)   { flagString += "⌥" }
        return flagString
    }
    
    private func has(modifier key: CGEventFlags ) -> Bool {
        return self.flags.rawValue & key.rawValue != 0 && !modifierKeyCodes[key.rawValue]!.contains(keyCode)
    }
    
    private let modifierKeyCodes: [UInt64: [CGKeyCode]] = [
        CGEventFlags.maskCommand.rawValue:   [54, 55],
        CGEventFlags.maskShift.rawValue:     [56, 60],
        CGEventFlags.maskControl.rawValue:   [59, 62],
        CGEventFlags.maskAlternate.rawValue: [58, 61],
        CGEventFlags.maskSecondaryFn.rawValue:   [63],
        CGEventFlags.maskAlphaShift.rawValue:    [57],
    ]
    
    func postEvent() -> Void {
        let loc = CGEventTapLocation.cghidEventTap
        
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)!
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)!
        
        keyDownEvent.flags = flags
        keyUpEvent.flags = CGEventFlags()
        
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
            cmb.has(modifier: .maskAlphaShift)  && !self.has(modifier: .maskAlphaShift)
        {
            return false
        }
        return self.flags.rawValue & mapping.withoutModifier.rawValue == 0
    }
}
