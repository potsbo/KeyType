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
    Remap(Key.SHIFT_R.without.shift, to: Key.SPACE.with.option),
    // Left to 'a' becomes escape
    Remap(Key.CONTROL_R.without.ctrl, to: Key.ESCAPE.alone),
    // To launch OmniFocus faster
    Remap(Key.SHIFT_L.without.shift, to: Key.SPACE.with.shift.command.option),
]
