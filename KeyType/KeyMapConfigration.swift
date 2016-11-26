//
//  KeyMapConfigration.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

class KeyMapConfiguration {
    
    private let keyMappingList = [
        KeyEventMap(from: .COMMAND_L, to: .EISU, whenWithout: NSEventModifierFlags.command),
        KeyEventMap(from: .COMMAND_R, to: .KANA, whenWithout: NSEventModifierFlags.command),
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
