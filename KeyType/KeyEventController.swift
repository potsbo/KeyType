//
//  KeyEventController.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class KeyEventController: NSObject {
    
    let watcher = KeyEventWatcher()
    override init() {
        super.init()
        
        let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString
        let options: CFDictionary = [checkOptionPrompt: true] as NSDictionary
        
        if !AXIsProcessTrustedWithOptions(options) {
            self.waitUntillTrusted()
        } else {
            self.watcher.startWatching()
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
}

