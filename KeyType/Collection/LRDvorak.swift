//
//  LRDvorak.swift
//  KeyType
//
//  Created by Shimpei Otsubo on 2020/08/23.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

import Foundation

let LRDvorak = setMappingList()

private func setMappingList() -> KeyMapCollection {
    var maps: [[KeyCombination]] = []
    maps = []
    maps += dvorakBaseMappings
    maps += numberMappings
    maps += symbolMappings

    return maps.map { Remap($0[0], to: $0[1]) }
}

private var dvorakBaseMappings: [[KeyCombination]] {
    let dvorakBase: [Key: Key] = [
        .Q: .QUOTE, .W: .COMMA, .E: .PERIOD, .R: .P, .T: .Y,
        .Y: .F, .U: .G, .I: .C, .O: .R, .P: .L,

        .A: .A, .S: .O, .D: .E, .F: .U, .G: .I,
        .H: .D, .J: .H, .K: .T, .L: .N, .SEMICOLON: .S,

        .Z: .SEMICOLON, .X: .Q, .C: .J, .V: .K, .B: .X,
        .N: .B, .M: .M, .COMMA: .W, .PERIOD: .V, .SLASH: .Z,
    ]

    return dvorakBase.map { [$0.without.ctrl.option.command, $1.alone] }
}

private var numberMappings: [[KeyCombination]] {
    let numbersShifted: [Key: Key] = [
        .NUM1: .NUM1, .NUM3: .SQUARE_BRA, .NUM4: .NUM9,
        .NUM6: .EQUAL, .NUM7: .NUM0, .NUM8: .SQUARE_KET, .NUM0: .NUM8,
    ]
    let numbersNotShifted: [Key: Key] = [
        .NUM2: .SQUARE_BRA, .NUM5: .EQUAL, .NUM9: .SQUARE_KET,
    ]

    let addShift = numbersShifted.map { [$0.without.shift, $1.with.shift] }
    let noShift = numbersNotShifted.map { [$0.without.shift, $1.alone] }
    let shifts = Key.numbers.map { [$0.with.shift.without.ctrl.option.command, $0.alone] }
    return noShift + addShift + shifts
}

private var symbolMappings: [[KeyCombination]] {
    return [
        [Key.SQUARE_BRA.alone, Key.SLASH.alone],
        [Key.QUOTE.alone, Key.MINUS.alone],

        [Key.SQUARE_KET.without.shift, Key.NUM2.with.shift],
        [Key.SQUARE_KET.with.shift, Key.NUM6.with.shift],

        [Key.MINUS.without.shift, Key.NUM7.with.shift],
        [Key.MINUS.with.shift, Key.NUM5.with.shift],

        [Key.EQUAL.without.shift, Key.BACKQUOTE.alone],
        [Key.EQUAL.with.shift, Key.NUM3.with.shift],

        [Key.BACKQUOTE.without.shift, Key.NUM4.with.shift],
    ]
}
