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
    
    let keys = [
        "英数" : ["KeyCode": 55, "VirtualKey": 102],
        "かな" : ["KeyCode": 54, "VirtualKey": 104],
    ] as Dictionary<String, Dictionary<String, UInt16>>
    
    override init() {
        super.init()
        
        let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString
        let options: CFDictionary = [checkOptionPrompt: true] as NSDictionary
        
        if !AXIsProcessTrustedWithOptions(options) {
            self.waitUntillTrusted()
        } else {
            self.startWatching()
        }
    }
    
    func waitUntillTrusted() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.watchAXIsProcess(_:)), userInfo: nil, repeats: true)
    }
    
    func watchAXIsProcess(_ timer: Timer) {
        if AXIsProcessTrusted() {
            timer.invalidate()
        }
    }
    
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
            for (key, values) in self.keys {
                if event.keyCode == values["KeyCode"] {
                    if event.modifierFlags.contains(.command) {
                        self.keyCode = values["KeyCode"]
                    } else if self.keyCode == values["KeyCode"]  {
                        print(key) // debug
                        let loc = CGEventTapLocation.cghidEventTap
                        let keyStatus = [true, false]
                        for status in keyStatus {
                            CGEvent(keyboardEventSource: nil, virtualKey: values["VirtualKey"]!, keyDown: status)?.post(tap: loc)
                        }
                    }
                }
            }
        })
    }
}
