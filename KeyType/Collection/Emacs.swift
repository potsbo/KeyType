//
//  Emacs.swift
//  KeyType
//
//  Created by Shimpei Otsubo on 2020/08/23.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

import Foundation

let Emacs = [
    [Key.ctrlL.without.ctrl, Key.ESCAPE.alone],
    [Key.J.with.ctrl, Key.RETURN.alone],
    [Key.M.with.ctrl, Key.RETURN.alone],
    [Key.F.with.ctrl, Key.RIGHT_ARROW.alone],
    [Key.B.with.ctrl, Key.LEFT_ARROW.alone],
    [Key.N.with.ctrl, Key.DOWN_ARROW.alone],
    [Key.P.with.ctrl, Key.UP_ARROW.alone],
    [Key.H.with.ctrl, Key.DELETE.alone],
].map { Remap($0[0], to: $0[1]) }
