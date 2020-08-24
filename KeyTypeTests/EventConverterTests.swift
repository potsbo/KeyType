//
//  File.swift
//  KeyTypeTests
//
//  Created by Shimpei Otsubo on 2020/08/22.
//  Copyright © 2020 Shimpei Otsubo. All rights reserved.
//

@testable import KeyType
import XCTest

class EventConverterTests: XCTestCase {
    func testLeftCommandToEisu() {
        XCTAssert(convert(KanaEisu, key: Key.commandL).keyCode == Key.EISU.rawValue)
    }

    func testRightCommandToKana() {
        XCTAssert(convert(KanaEisu, key: Key.commandR).keyCode == Key.KANA.rawValue)
        XCTAssert(convert(KanaEisu, key: Key.A).keyCode == Key.A.rawValue)
    }

    func testNoTouch() {
        XCTAssertTrue(convert(KanaEisu, key: Key.A, flags: .maskCommand).keyCode == Key.A.rawValue)
        XCTAssertTrue(convert(KanaEisu, key: Key.commandR, flags: .maskCommand).keyCode == Key.commandR.rawValue)
    }

    func testWithoutSimple() {
        XCTAssertTrue(
            convert(
                [Remap(Key.A.without.option, to: Key.B.alone)],
                key: Key.A
            ).keyCode == Key.B.rawValue
        )
    }

    func testWithoutWithModifier() {
        // with `shift`
        XCTAssertTrue(
            convert(
                [Remap(Key.A.without.option, to: Key.B.alone)],
                key: Key.A,
                flags: CGEventFlags.maskShift
            ).keyCode == Key.B.rawValue
        )

        // with `shift` and `command`
        XCTAssertTrue(
            convert(
                [Remap(Key.A.without.option, to: Key.B.alone)],
                key: Key.A,
                flags: CGEventFlags.maskShift.union(.maskCommand)
            ).keyCode == Key.B.rawValue
        )

        // key with `option` can never trigger the Remap
        XCTAssertTrue(
            convert(
                [Remap(Key.A.with.shift.without.option, to: Key.B.alone)],
                key: Key.A,
                flags: CGEventFlags.maskShift.union(.maskAlternate)
            ).keyCode == Key.A.rawValue
        )
    }

    private func convert(_ collection: KeyMapCollection, key: Key, flags: CGEventFlags? = nil) -> CGEvent {
        let finder = RemapFinder(collection)
        let converter = EventConverter(finder: finder)
        let event = CGEvent(
            keyboardEventSource: nil,
            virtualKey: key.rawValue,
            keyDown: false
        )!
        if let flags = flags {
            event.flags.insert(flags)
        }
        return converter.convert(type: .keyDown, event: event)
    }
}
