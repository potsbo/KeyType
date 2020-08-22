//
//  File.swift
//  KeyTypeTests
//
//  Created by Shimpei Otsubo on 2020/08/22.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

@testable import KeyType
import XCTest

class KeyCombinationTests: XCTestCase {
    func testExample() {
        XCTAssert(KeyCombination(Key.A).label == "A")
        XCTAssert(KeyCombination(Key.A).without.command.label == "A")
    }
}