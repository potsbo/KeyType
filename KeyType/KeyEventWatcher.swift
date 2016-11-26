//
//  KeyEventWatcher.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyEventWatcher: NSObject {
    var keyCode: UInt16? = nil
    
    // exclude here to config file
    let keyMaps = [
        KeyEventMap(from: .L_CMD, to: .EISU, whenWithout: NSEventModifierFlags.command),
        KeyEventMap(from: .R_CMD, to: .KANA, whenWithout: NSEventModifierFlags.command),
    ]
    
    func startWatching() {
        let masks = [
            NSEventMask.keyDown,
            NSEventMask.keyUp,
        ]
        let handler = { (evt: NSEvent!) -> Void in self.keyCode = nil }
        
        for mask in masks {
            NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.flagsChanged, handler: { (event: NSEvent!) -> Void in
            for map in self.keyMaps {
                if event.keyCode == map.keyCode {
                    if event.modifierFlags.contains(map.withoutModifier) {
                        self.keyCode = map.keyCode
                    } else if self.keyCode == map.keyCode {
                        let loc = CGEventTapLocation.cghidEventTap
                        let keyStatus = [true, false]
                        for status in keyStatus {
                            CGEvent(keyboardEventSource: nil, virtualKey: map.virtualKey, keyDown: status)?.post(tap: loc)
                        }
                    }
                }
            }
        })
    }
}
