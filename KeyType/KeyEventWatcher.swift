//
//  KeyEventWatcher.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa


import Cocoa

class KeyEventWatcher {
    private var keyCode: CGKeyCode? = nil
    private let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
    private let config = KeyMapConfiguration()
    
    private func eventMask() -> UInt32 {
        let eventMaskList : [CGEventType] = [
            .keyDown,
            .keyUp,
            .flagsChanged,
            .leftMouseDown,
            .leftMouseUp,
            .rightMouseDown,
            .rightMouseUp,
            .otherMouseDown,
            .otherMouseUp,
            .scrollWheel
        ]
        
        var eventMask: UInt32 = 0
        for mask in eventMaskList.map({ $0.rawValue }) {
            eventMask |= (1 << mask)
        }
        return eventMask
    }
    
    func startWatching() {
        print("start watching")
        guard let eventTap = eventTap() else {
            print("failed to create event tap")
            exit(1)
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    private func eventTap() -> CFMachPort? {
        let observer = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        func callback (proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            if let observer = refcon {
                let mySelf = Unmanaged<KeyEventWatcher>.fromOpaque(observer).takeUnretainedValue()
                return mySelf.eventCallback(proxy: proxy, type: type, event: event)
            }
            return Unmanaged.passRetained(event)
        }
        
        let tap = CGEvent.tapCreate(
            tap:              .cgSessionEventTap,
            place:            .headInsertEventTap,
            options:          .defaultTap,
            eventsOfInterest: CGEventMask(eventMask()),
            callback:         callback,
            userInfo:         observer
        )
        
        return tap
    }
    
    private func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        switch type {
        case .flagsChanged:
            if event.isModiferKeyEvent() {
                return event.isModiferKeyDownEvent() ? modifierKeyDown(event) : modifierKeyUp(event)
            } else {
                return Unmanaged.passRetained(event)
            }
        case .keyDown:
            return keyDown(event)
        case .keyUp:
            return keyUp(event)
        default:
            self.keyCode = nil
            return Unmanaged.passRetained(event)
        }
    }
    
    private func keyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        self.keyCode = nil
        let event = getConvertedEvent(event) ?? event
        return Unmanaged.passRetained(event)
    }
    
    private func keyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        self.keyCode = nil
        let event = getConvertedEvent(event) ?? event
        return Unmanaged.passRetained(event)
    }
    
    private func modifierKeyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        self.keyCode = event.keyCode
        return Unmanaged.passRetained(event)
    }
    
    private func modifierKeyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        if self.keyCode == event.keyCode {
            if let convertedEvent = getConvertedEvent(event) {
                KeyCombination(fromEvent: convertedEvent).postEvent()
            }
        }
        self.keyCode = nil
        return Unmanaged.passRetained(event)
    }
    
    private func getConvertedEvent(_ event: CGEvent, keyCode: CGKeyCode? = nil) -> CGEvent? {
        let eventKeyCombination = KeyCombination(fromEvent: event)
        
        guard let candidateMaps = self.config.mapList[keyCode ?? eventKeyCombination.keyCode] else {
            return nil
        }
        
        for map in candidateMaps {
            if eventKeyCombination.isCompatibleWith(map) {
                event.keyCode = map.outputKeyCode
                event.flags   = map.renderEventFlagFor(event: event)
                return event
            }
        }
        
        return nil
    }
}
