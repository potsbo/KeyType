//
//  Emacs.swift
//  KeyType
//
//  Created by Shimpei Otsubo on 2020/08/23.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

import Foundation

let EmacsLike = [
    Remap(Key.J.with.ctrl, to: .returnKey),
    Remap(Key.M.with.ctrl, to: .returnKey),
    Remap(Key.F.with.ctrl, to: .rightArrow),
    Remap(Key.B.with.ctrl, to: .leftArrow),
    Remap(Key.N.with.ctrl, to: .downArrow),
    Remap(Key.P.with.ctrl, to: .upArrow),
    Remap(Key.H.with.ctrl, to: .delete),
]
