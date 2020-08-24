//
//  KeyEventWatcher.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyEventWatcher {
    private let config = EventConverter(finder: RemapFinder(LRDvorak + KanaEisu + Emacs + Custom))

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
        func callback(proxy _: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            guard let observer = refcon else { return Unmanaged.passRetained(event) }
            let mySelf = Unmanaged<KeyEventWatcher>.fromOpaque(observer).takeUnretainedValue()
            return Unmanaged.passRetained(mySelf.config.convert(type: type, event: event))
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
}
