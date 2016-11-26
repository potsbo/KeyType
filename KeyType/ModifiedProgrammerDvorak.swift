//
//  ModifiedProgrammerDvorak.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class LRDvorak: KeyMapConfiguration {
    override init() {
        super.init()
        setMappingList()
    }
    
    private func setMappingList() {
        self.keyMappingList = []
        self.keyMappingList += kanaEisuMappings
        self.keyMappingList += dvorakBaseMappings
    }
    
    private let dvorakBase: [Key : Key] = [
        .S:.O, .D:.E, .F:.U, .G:.I,
        .H:.D, .J:.H, .K:.T, .L:.N, .SEMICOLON:.S,
        
        .Q:.QUOTE, .W:.COMMA, .E:.PERIOD, .R:.P, .T:.Y,
        .Y:.F, .U:.G, .I:.C, .O:.R, .P:.L,
        
        .Z: .SEMICOLON, .X: .Q, .C: .J, .V: .K, .B: .X,
        .N: .B, .M: .M, .COMMA : .W, .PERIOD: .V,.SLASH : .Z
    ]
    
    private var dvorakBaseMappings: [KeyEventMap] {
        get {
            return self.dvorakBase.map { KeyEventMap(from: $0, to: $1, whenWithout: defaultMask) }
        }
    }
}
