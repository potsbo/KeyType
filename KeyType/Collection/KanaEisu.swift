//
//  KanaEisu.swift
//  KeyType
//
//  Created by Shimpei Otsubo on 2020/08/23.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

import Foundation

let KanaEisu: KeyMapCollection = [
    KeyEventMap(Key.commandL.without.command, to: Key.EISU.alone),
    KeyEventMap(Key.commandR.without.command, to: Key.KANA.alone),
]
