//
//  ModifiedProgrammerDvorak.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class EventConverter {
    var keyMappingList: [Remap] = []

    private var mapList: [CGKeyCode: [Remap]] {
        if needsRehashing { rehash() }
        return storedList
    }

    private var storedList: [CGKeyCode: [Remap]] = [:]
    private var needsRehashing = true

    private func rehash() {
        storedList = [:]

        for val in keyMappingList {
            let key = val.input.keyCode

            if storedList[key] == nil {
                storedList[key] = []
            }

            storedList[key]?.append(val)
        }
        needsRehashing = false
    }

    init(_ keyMappingList: KeyMapCollection) {
        self.keyMappingList = keyMappingList
    }

    func getConvertedEvent(_ event: CGEvent, keyCode: CGKeyCode? = nil) -> CGEvent? {
        let eventKeyCombination = KeyCombination(fromEvent: event)

        guard let candidateMaps = mapList[keyCode ?? eventKeyCombination.keyCode] else {
            return nil
        }

        for map in candidateMaps {
            if eventKeyCombination.isCompatibleWith(map) {
                event.keyCode = map.outputKeyCode
                event.flags = map.renderEventFlagFor(event: event)
                return event
            }
        }

        return nil
    }
}
