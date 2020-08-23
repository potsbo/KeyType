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
    func testLeftCommandToEisu() {
        XCTAssert(convert(KanaEisu, key: Key.commandL)?.keyCode == Key.EISU.rawValue)
    }

    func testRightCommandToKana() {
        XCTAssert(convert(KanaEisu, key: Key.commandR)?.keyCode == Key.KANA.rawValue)
    }

    func testChain() {
        XCTAssertFalse(Key.commandR.without.command.withFlags.contains(.maskCommand))
    }

    private func convert(_ collection: KeyMapCollection, key: Key) -> CGEvent? {
        let converter = EventConverter(collection)
        let event = CGEvent(
            keyboardEventSource: nil,
            virtualKey: key.rawValue,
            keyDown: false
        )!
        return converter.getConvertedEvent(event)
    }
}
