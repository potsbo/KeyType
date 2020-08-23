//
//  Custom.swift
//  KeyType
//
//  Created by Shimpei Otsubo on 2020/08/23.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

import Foundation

let Custom = [
    // To launch Alfred faster
    Remap(Key.shiftR.without.shift, to: Key.SPACE.with.option),
    // Left to 'a' becomes escape
    Remap(Key.ctrlR.without.ctrl, to: Key.ESCAPE),
    // To launch OmniFocus faster
    Remap(Key.shiftL.without.shift, to: Key.SPACE.with.shift.command.option),
]
