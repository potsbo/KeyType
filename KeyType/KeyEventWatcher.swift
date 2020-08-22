//
//  KeyEventWatcher.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyEventWatcher {
    private var keyCode: CGKeyCode?
    private let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    private let config = EventConverter(LRDvorak + KanaEisu + Emacs)

    private var eventMaskToWatch: CGEventMask {
        let eventTypeList: [CGEventType] = [
            .keyDown,
            .keyUp,
            .flagsChanged,
            .leftMouseDown,
            .leftMouseUp,
            .rightMouseDown,
            .rightMouseUp,
            .otherMouseDown,
            .otherMouseUp,
            .scrollWheel,
        ]

        let maskBits = eventTypeList.map { $0.rawValue }.map { UInt32(1 << $0) }
        let maskBit = maskBits.reduce(UInt32(0)) { UInt32($0 | $1) }
        return CGEventMask(maskBit)
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
        func callback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            guard let observer = refcon else { return Unmanaged.passRetained(event) }
            let mySelf = Unmanaged<KeyEventWatcher>.fromOpaque(observer).takeUnretainedValue()
            return mySelf.eventCallback(proxy: proxy, type: type, event: event)
        }

        let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMaskToWatch,
            callback: callback,
            userInfo: observer
        )

        return tap
    }

    private func eventCallback(proxy _: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
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
            keyCode = nil
            return Unmanaged.passRetained(event)
        }
    }

    private func keyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        keyCode = nil
        let event = config.getConvertedEvent(event) ?? event
        return Unmanaged.passRetained(event)
    }

    private func keyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        keyCode = nil
        let event = config.getConvertedEvent(event) ?? event
        return Unmanaged.passRetained(event)
    }

    private func modifierKeyDown(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        keyCode = event.keyCode
        return Unmanaged.passRetained(event)
    }

    private func modifierKeyUp(_ event: CGEvent) -> Unmanaged<CGEvent>? {
        if keyCode == event.keyCode {
            if let convertedEvent = config.getConvertedEvent(event) {
                KeyCombination(fromEvent: convertedEvent).postEvent()
            }
        }
        keyCode = nil
        return Unmanaged.passRetained(event)
    }
}
