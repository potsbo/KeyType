//
//  KeyEventWatcher.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyEventWatcher {
    private var keyCode: CGKeyCode? = nil
    private let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String
    private let config = LRDvorak()
    
    private var eventMaskToWatch: CGEventMask {
        get {
            let eventTypeList : [CGEventType] = [
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
            
            let maskBits = eventTypeList.map { $0.rawValue }.map { UInt32(1 << $0) }
            let maskBit  = maskBits.reduce(UInt32(0), { UInt32($0 | $1) } )
            return CGEventMask(maskBit)
        }
    }
    
    func startWatching() {
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
            guard let observer = refcon else { return Unmanaged.passRetained(event) }
            let mySelf = Unmanaged<KeyEventWatcher>.fromOpaque(observer).takeUnretainedValue()
            return mySelf.eventCallback(proxy: proxy, type: type, event: event)
        }
        
        let tap = CGEvent.tapCreate(
            tap:              .cgSessionEventTap,
            place:            .headInsertEventTap,
            options:          .defaultTap,
            eventsOfInterest: eventMaskToWatch,
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
