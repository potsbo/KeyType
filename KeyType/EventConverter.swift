//
//  EventConverter.swift
//  KeyType
//
//  Created by Shimpei Otsubo on 2020/08/24.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

import Foundation

class EventConverter {
    private let finder: RemapFinder
    private var keyCode: CGKeyCode?

    init(finder: RemapFinder) {
        self.finder = finder
    }

    func eventCallback(proxy _: CGEventTapProxy, type: CGEventType, event: CGEvent) -> CGEvent {
        switch type {
        case .flagsChanged:
            if event.isModiferKeyEvent() {
                return event.isModiferKeyDownEvent() ? modifierKeyDown(event) : modifierKeyUp(event)
            } else {
                return event
            }
        case .keyDown:
            return keyDown(event)
        case .keyUp:
            return keyUp(event)
        default:
            keyCode = nil
            return event
        }
    }

    private func keyDown(_ event: CGEvent) -> CGEvent {
        keyCode = nil
        let event = finder.getConvertedEvent(event) ?? event
        return event
    }

    private func keyUp(_ event: CGEvent) -> CGEvent {
        keyCode = nil
        let event = finder.getConvertedEvent(event) ?? event
        return event
    }

    private func modifierKeyDown(_ event: CGEvent) -> CGEvent {
        keyCode = event.keyCode
        return event
    }

    private func modifierKeyUp(_ event: CGEvent) -> CGEvent {
        if keyCode == event.keyCode {
            if let convertedEvent = finder.getConvertedEvent(event) {
                KeyCombination(fromEvent: convertedEvent).postEvent()
            }
        }
        keyCode = nil
        return event
    }
}
