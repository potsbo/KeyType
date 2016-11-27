//
//  KeyMapConfigration.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyMapConfiguration {
    static func mergeMask(_ masks: [CGEventFlags]) -> CGEventFlags {
        var eventMask: UInt64 = 0
        for mask in masks.map({ $0.rawValue }) {
            eventMask |= mask
        }
        return CGEventFlags(rawValue: eventMask)
    }
    
    var keyMappingList: [KeyEventMap] = []
    
    let kanaEisuMappings = [
        [Key.COMMAND_L.without.command, Key.EISU.alone],
        [Key.COMMAND_R.without.command, Key.KANA.alone]
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



