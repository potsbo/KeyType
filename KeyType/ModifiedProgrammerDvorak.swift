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
        self.keyMappingList += numberMappings
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
    
    private let numbers: [Key : Key] = [
        .NUM1:.NUM1,  .NUM3:.SQUARE_BRA, .NUM4:.NUM9,
        .NUM6:.EQUAL, .NUM7:.NUM0,       .NUM8:.SQUARE_KET, .NUM0:.NUM8,
    ]
    
    private let numbersToAddShift: [Key : Key] = [
        .NUM2:.SQUARE_BRA, .NUM5:.EQUAL, .NUM9:.SQUARE_KET
    ]

    private var numberMappings: [KeyEventMap] {
        get {
            let noshift = self.numbers.map { KeyEventMap(from: $0, to: KeyCombination($1, withModifier: .maskShift), whenWithout: .maskShift) }
            let addShift = self.numbersToAddShift.map { KeyEventMap(from: $0, to: $1, whenWithout: .maskShift) }

            let shift   = Key.numbers().map  {
                KeyEventMap(from: KeyCombination($0, withModifier: .maskShift),to: $0, whenWithout: defaultMask )}
            return noshift + addShift + shift
        }
    }
}
