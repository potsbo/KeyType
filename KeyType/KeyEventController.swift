//
//  KeyEventController.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class KeyEventController {

    private let watcher = KeyEventWatcher()

    init() {
        let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString
        let options: CFDictionary = [checkOptionPrompt: true] as NSDictionary

        if !AXIsProcessTrustedWithOptions(options) {
            self.waitUntillTrusted()
        } else {
            self.watcher.startWatching()
        }
    }

    private func waitUntillTrusted() {
        Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(KeyEventController.watchAXIsProcess(_:)),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func watchAXIsProcess(_ timer: Timer) {
        if AXIsProcessTrusted() {
            timer.invalidate()
        }
    }
}
