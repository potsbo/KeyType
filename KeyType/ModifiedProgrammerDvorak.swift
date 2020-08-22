//
//  ModifiedProgrammerDvorak.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Foundation

class DefaultConfiguration: KeyMapConfiguration {
    override init() {
        super.init()
        setMappingList()
    }

    private func setMappingList() {
        keyMappingList = LRDvorak + KanaEisu + Emacs
    }
}
