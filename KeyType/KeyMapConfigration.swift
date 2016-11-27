//
//  KeyMapConfigration.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyMapConfiguration {
    private let defaultExclusion : [CGEventFlags] = [.maskCommand, .maskControl, .maskAlternate]
    let defaultMask: CGEventFlags
    init() {
        var eventMask: UInt64 = 0
        for mask in self.defaultExclusion.map({ $0.rawValue }) {
            eventMask |= mask
        }
        self.defaultMask = KeyMapConfiguration.mergeMask(defaultExclusion)
    }

    static func mergeMask(_ masks: [CGEventFlags]) -> CGEventFlags {
        var eventMask: UInt64 = 0
        for mask in masks.map({ $0.rawValue }) {
            eventMask |= mask
        }
        return CGEventFlags(rawValue: eventMask)
    }
    
    var keyMappingList: [KeyEventMap] = []
    
    let kanaEisuMappings = [
        KeyEventMap(Key.COMMAND_L.alone, to: Key.EISU.alone, whenWithout: .maskCommand),
        KeyEventMap(Key.COMMAND_R.alone, to: Key.KANA.alone, whenWithout: .maskCommand),
    ]
    
    var mapList: [CGKeyCode: [KeyEventMap]] {
        get {
            if needsRehashing { rehash() }
            return storedList
        }
    }
    
    private var storedList : [CGKeyCode: [KeyEventMap]] = [:]
    private var needsRehashing = true
    
    private func rehash(){
        storedList = [:]
        
        for val in self.keyMappingList {
            let key = val.input.keyCode
            
            if storedList[key] == nil {
                storedList[key] = []
            }
            
            storedList[key]?.append(val)
        }
        needsRehashing = false
    }

}



