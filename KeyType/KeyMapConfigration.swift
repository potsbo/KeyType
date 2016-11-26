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
        print(String(eventMask, radix: 2))
        self.defaultMask = CGEventFlags(rawValue: eventMask)
    }
    
    var keyMappingList: [KeyEventMap] = []
    
    let kanaEisuMappings = [
        KeyEventMap(from: .COMMAND_L, to: .EISU, whenWithout: CGEventFlags.maskCommand),
        KeyEventMap(from: .COMMAND_R, to: .KANA, whenWithout: CGEventFlags.maskCommand),
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



