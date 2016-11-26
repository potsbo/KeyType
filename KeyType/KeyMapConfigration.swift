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
    private let defaultMask: CGEventFlags
    init() {
        var eventMask: UInt64 = 0
        for mask in self.defaultExclusion.map({ $0.rawValue }) {
            eventMask |= mask
        }
        print(String(eventMask, radix: 2))
        self.defaultMask = CGEventFlags(rawValue: eventMask)
        
        self.setDefaultKeyMapping()
    }
    
    private var keyMappingList: [KeyEventMap] = []
    
    private func setDefaultKeyMapping() {
        self.keyMappingList = [
            KeyEventMap(from: .COMMAND_L, to: .EISU, whenWithout: CGEventFlags.maskCommand),
            KeyEventMap(from: .COMMAND_R, to: .KANA, whenWithout: CGEventFlags.maskCommand),
            
            // middle row
            KeyEventMap(from: .S, to: .O, whenWithout: defaultMask),
            KeyEventMap(from: .D, to: .E, whenWithout: defaultMask),
            KeyEventMap(from: .F, to: .U, whenWithout: defaultMask),
            KeyEventMap(from: .G, to: .I, whenWithout: defaultMask),
            KeyEventMap(from: .H, to: .D, whenWithout: defaultMask),
            
            KeyEventMap(from: .J, to: .H, whenWithout: defaultMask),
            KeyEventMap(from: .K, to: .T, whenWithout: defaultMask),
            KeyEventMap(from: .L, to: .N, whenWithout: defaultMask),
            KeyEventMap(from: .SEMICOLON, to: .S, whenWithout: defaultMask),
            
            // upper row
            KeyEventMap(from: .Q, to: .QUOTE, whenWithout: defaultMask),
            KeyEventMap(from: .W, to: .COMMA, whenWithout: defaultMask),
            KeyEventMap(from: .E, to: .PERIOD, whenWithout: defaultMask),
            KeyEventMap(from: .R, to: .P, whenWithout: defaultMask),
            KeyEventMap(from: .T, to: .Y, whenWithout: defaultMask),
            
            KeyEventMap(from: .Y, to: .F, whenWithout: defaultMask),
            KeyEventMap(from: .U, to: .G, whenWithout: defaultMask),
            KeyEventMap(from: .I, to: .C, whenWithout: defaultMask),
            KeyEventMap(from: .O, to: .R, whenWithout: defaultMask),
            KeyEventMap(from: .P, to: .L, whenWithout: defaultMask),
            
            // upper row
            KeyEventMap(from: .Z, to: .SEMICOLON, whenWithout: defaultMask),
            KeyEventMap(from: .X, to: .Q, whenWithout: defaultMask),
            KeyEventMap(from: .C, to: .J, whenWithout: defaultMask),
            KeyEventMap(from: .V, to: .K, whenWithout: defaultMask),
            KeyEventMap(from: .B, to: .X, whenWithout: defaultMask),
            
            KeyEventMap(from: .N, to: .B, whenWithout: defaultMask),
            KeyEventMap(from: .M, to: .M, whenWithout: defaultMask),
            KeyEventMap(from: .COMMA,  to: .W, whenWithout: defaultMask),
            KeyEventMap(from: .PERIOD, to: .V, whenWithout: defaultMask),
            KeyEventMap(from: .SLASH,  to: .Z, whenWithout: defaultMask),
            
        ]

    }
    
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



