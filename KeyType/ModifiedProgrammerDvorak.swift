//
//  ModifiedProgrammerDvorak.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class DefaultConfiguration {
    var keyMappingList: [KeyEventMap] = []

    var mapList: [CGKeyCode: [KeyEventMap]] {
        if needsRehashing { rehash() }
        return storedList
    }

    private var storedList: [CGKeyCode: [KeyEventMap]] = [:]
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
}
