//
//  ModifiedProgrammerDvorak.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class EventConverter {
    private var remapList: [CGKeyCode: [Remap]]

    init(_ keyMappingList: KeyMapCollection) {
        var remapList: [CGKeyCode: [Remap]] = [:]

        for val in keyMappingList {
            let key = val.input.keyCode

            if remapList[key] == nil {
                remapList[key] = []
            }

            remapList[key]?.append(val)
        }

        self.remapList = remapList
    }

    func getConvertedEvent(_ event: CGEvent) -> CGEvent? {
        let eventKeyCombination = KeyCombination(fromEvent: event)

        guard let candidateMaps = remapList[eventKeyCombination.keyCode] else {
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
