//
//  ModifiedProgrammerDvorak.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class RemapFinder {
    private var remapMap: [CGKeyCode: [Remap]]

    init(_ keyMappingList: KeyMapCollection) {
        var remapList: [CGKeyCode: [Remap]] = [:]

        for val in keyMappingList {
            let key = val.input.keyCode

            if remapList[key] == nil {
                remapList[key] = []
            }

            remapList[key]?.append(val)
        }

        remapMap = remapList
    }

    // TODO: return remap instead of CGEvent
    func find(_ event: CGEvent) -> CGEvent? {
        let eventKeyCombination = KeyCombination(fromEvent: event)

        guard let candidateRemaps = remapMap[eventKeyCombination.keyCode] else {
            return nil
        }

        for remap in candidateRemaps {
            if eventKeyCombination.isCompatible(with: remap) {
                event.keyCode = remap.outputKeyCode
                event.flags = remap.renderEventFlag(for: event)
                return event
            }
        }

        return nil
    }
}
