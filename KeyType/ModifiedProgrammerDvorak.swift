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
        var maps: [[KeyCombination]] = []
        maps = []
        maps += kanaEisuMappings
        maps += dvorakBaseMappings
        maps += numberMappings
        maps += symbolMappings
        maps += emacsMappings
        
        self.keyMappingList = maps.map { KeyEventMap($0[0], to: $0[1]) }
    }
    
    private let dvorakBase: [Key : Key] = [
        .S:.O, .D:.E, .F:.U, .G:.I,
        .H:.D, .J:.H, .K:.T, .L:.N, .SEMICOLON:.S,
        
        .Q:.QUOTE, .W:.COMMA, .E:.PERIOD, .R:.P, .T:.Y,
        .Y:.F, .U:.G, .I:.C, .O:.R, .P:.L,
        
        .Z: .SEMICOLON, .X: .Q, .C: .J, .V: .K, .B: .X,
        .N: .B, .M: .M, .COMMA : .W, .PERIOD: .V,.SLASH : .Z
    ]
    
    private var dvorakBaseMappings: [[KeyCombination]] {
        get {
            return self.dvorakBase.map { [$0.without.ctrl.option.command, $1.alone] }
        }
    }
    
    private let numbers: [Key : Key] = [
        .NUM1:.NUM1,  .NUM3:.SQUARE_BRA, .NUM4:.NUM9,
        .NUM6:.EQUAL, .NUM7:.NUM0,       .NUM8:.SQUARE_KET, .NUM0:.NUM8,
    ]
    
    private let numbersToAddShift: [Key : Key] = [
        .NUM2:.SQUARE_BRA, .NUM5:.EQUAL, .NUM9:.SQUARE_KET
    ]

    private var numberMappings: [[KeyCombination]] {
        get {
            let noshift  = self.numbers.map { [$0.without.shift, $1.with.shift] }
            let addShift = self.numbersToAddShift.map { [$0.without.shift, $1.alone] }

            let shift   = Key.numbers().map  { [$0.with.shift.without.ctrl.option.command, $0.alone]}
            return noshift + addShift + shift
        }
    }
    
    private var symbolMappings: [[KeyCombination]] {
        get {
            return [
                [Key.SQUARE_BRA.alone,         Key.SLASH.alone],
                [Key.QUOTE.alone,              Key.MINUS.alone],
                
                [Key.SQUARE_KET.without.shift, Key.NUM2.with.shift],
                [Key.SQUARE_KET.with.shift,    Key.NUM6.with.shift],
                
                [Key.MINUS.without.shift,      Key.NUM7.with.shift],
                [Key.MINUS.with.shift,         Key.NUM5.with.shift],
                
                [Key.EQUAL.without.shift,      Key.BACKQUOTE.alone],
                [Key.EQUAL.with.shift,         Key.NUM3.with.shift],
                
                [Key.BACKQUOTE.without.shift,  Key.NUM4.with.shift],
            ]
        }
    }
    
    private var emacsMappings: [[KeyCombination]] {
        get {
            return [
                [Key.CONTROL_L.without.ctrl, Key.ESCAPE.alone],
                [Key.J.with.ctrl,            Key.RETURN.alone],
                [Key.F.with.ctrl,            Key.RIGHT_ARROW.alone],
                [Key.B.with.ctrl,            Key.LEFT_ARROW.alone],
                [Key.N.with.ctrl,            Key.DOWN_ARROW.alone],
                [Key.P.with.ctrl,            Key.UP_ARROW.alone],
                [Key.H.with.ctrl,            Key.DELETE.alone],
            ]
        }
    }
}
