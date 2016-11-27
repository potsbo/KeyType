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
        self.keyMappingList += symbolMappings
        self.keyMappingList += emacsMappings
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
            return self.dvorakBase.map { KeyEventMap($0.alone, to: $1.alone, whenWithout: defaultMask) }
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
            let noshift = self.numbers.map { KeyEventMap($0.alone, to: $1.with.shift, whenWithout: .maskShift) }
            let addShift = self.numbersToAddShift.map { KeyEventMap($0.alone, to: $1.alone, whenWithout: .maskShift) }

            let shift   = Key.numbers().map  {
                KeyEventMap($0.with.shift,to: $0.alone, whenWithout: defaultMask )}
            return noshift + addShift + shift
        }
    }
    
    private var symbolMappings: [KeyEventMap] {
        get {
            return [
                KeyEventMap(Key.SQUARE_BRA.alone,      to: Key.SLASH.alone),
                KeyEventMap(Key.QUOTE.alone,           to: Key.MINUS.alone),
                
                KeyEventMap(Key.SQUARE_KET.alone,      to: Key.NUM2.with.shift, whenWithout: .maskShift),
                KeyEventMap(Key.SQUARE_KET.with.shift, to: Key.NUM6.with.shift),
                
                KeyEventMap(Key.MINUS.alone,           to: Key.NUM7.with.shift, whenWithout: .maskShift),
                KeyEventMap(Key.MINUS.with.shift,      to: Key.NUM5.with.shift),
                
                KeyEventMap(Key.EQUAL.alone,           to: Key.BACKQUOTE.alone, whenWithout: .maskShift),
                KeyEventMap(Key.EQUAL.with.shift,      to: Key.NUM3.with.shift),
                
                KeyEventMap(Key.BACKQUOTE.alone,       to: Key.NUM4.with.shift, whenWithout: .maskShift),
            ]
        }
    }
    
    private var emacsMappings: [KeyEventMap] {
        get {
            return [
                KeyEventMap(Key.CONTROL_L.alone, to: Key.ESCAPE.alone, whenWithout: .maskControl),
                KeyEventMap(Key.J.with.ctrl,     to: Key.RETURN.alone),
                KeyEventMap(Key.F.with.ctrl,     to: Key.RIGHT_ARROW.alone),
                KeyEventMap(Key.B.with.ctrl,     to: Key.LEFT_ARROW.alone),
                KeyEventMap(Key.N.with.ctrl,     to: Key.DOWN_ARROW.alone),
                KeyEventMap(Key.P.with.ctrl,     to: Key.UP_ARROW.alone),
                KeyEventMap(Key.H.with.ctrl,     to: Key.DELETE.alone),
            ]
        }
    }
}
