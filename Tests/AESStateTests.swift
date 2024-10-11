//
//  AESStateTests.swift
//  AES-ArchitectureTests
//
//  Created by Leon Chamoun on 28.09.24.
//

import XCTest
@testable import AES_Visualization

final class AESStateTests: XCTestCase {
    var state: AESState!
    
    override func setUpWithError() throws {
        state = AESState(math: AESMath())
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        state = nil
        super.tearDown()
    }
    
    func testShiftRows() throws {
        var testOne: [[Byte]] = [
            [0x63, 0x53, 0xe0, 0x8c],
            [0x09, 0x60, 0xe1, 0x04],
            [0xcd, 0x70, 0xb7, 0x51],
            [0xba, 0xca, 0xd0, 0xe7]
        ]
        var testTwo: [[Byte]] = [
            [0x49, 0x45, 0x7f, 0x77],
            [0xde, 0xdb, 0x39, 0x02],
            [0xd2, 0x96, 0x87, 0x53],
            [0x89, 0xf1, 0x1a, 0x3b]
        ]
        
        let resultOne: [[Byte]] = [
            [0x63, 0x53, 0xe0, 0x8c],
            [0x60, 0xe1, 0x04, 0x09],
            [0xb7, 0x51, 0xcd, 0x70],
            [0xe7, 0xba, 0xca, 0xd0]
        ]
        let resultTwo: [[Byte]] = [
            [0x49, 0x45, 0x7f, 0x77],
            [0xdb, 0x39, 0x02, 0xde],
            [0x87, 0x53, 0xd2, 0x96],
            [0x3b, 0x89, 0xf1, 0x1a]
        ]
        
        let historyExceptedOutputOne: [ShiftRowRound] = [
            ShiftRowRound(index: 1,
                          temp: [0x09, 0x60, 0xe1, 0x04],
                          shifts: [[0x60, 0xe1, 0x04, 0x09], [], []]),
            ShiftRowRound(index: 2,
                          temp: [0xcd, 0x70, 0xb7, 0x51],
                          shifts: [[0x70, 0xb7, 0x51, 0xcd], [0xb7, 0x51, 0xcd, 0x70], []]),
            ShiftRowRound(index: 3,
                          temp: [0xba, 0xca, 0xd0, 0xe7],
                          shifts: [[0xca, 0xd0, 0xe7, 0xba], [0xd0, 0xe7, 0xba, 0xca], [0xe7, 0xba, 0xca, 0xd0]]),
        ]
        let historyExceptedOutputTwo: [ShiftRowRound] = [
            ShiftRowRound(index: 1,
                          temp: [0xde, 0xdb, 0x39, 0x02],
                          shifts: [[0xdb, 0x39, 0x02, 0xde], [], []]),
            ShiftRowRound(index: 2,
                          temp: [0xd2, 0x96, 0x87, 0x53],
                          shifts: [[0x96, 0x87, 0x53, 0xd2], [0x87, 0x53, 0xd2, 0x96], []]),
            ShiftRowRound(index: 3,
                          temp: [0x89, 0xf1, 0x1a, 0x3b],
                          shifts: [[0xf1, 0x1a, 0x3b, 0x89], [0x1a, 0x3b, 0x89, 0xf1], [0x3b, 0x89, 0xf1, 0x1a]]),
        ]
        let historyExceptedOutputOneRev: [ShiftRowRound] = [
            ShiftRowRound(index: 1,
                          temp: [0x60, 0xe1, 0x04, 0x09],
                          shifts: [[0xe1, 0x04, 0x09, 0x60], [0x04, 0x09, 0x60, 0xe1], [0x09, 0x60, 0xe1, 0x04]]),
            ShiftRowRound(index: 2,
                          temp: [0xb7, 0x51, 0xcd, 0x70],
                          shifts: [[0x51, 0xcd, 0x70, 0xb7], [0xcd, 0x70, 0xb7, 0x51], []]),
            ShiftRowRound(index: 3,
                          temp: [0xe7, 0xba, 0xca, 0xd0],
                          shifts: [[0xba, 0xca, 0xd0, 0xe7], [], []]),
        ]
        let historyExceptedOutputTwoRev: [ShiftRowRound] = [
            ShiftRowRound(index: 1,
                          temp: [0xdb, 0x39, 0x02, 0xde],
                          shifts: [[0x39, 0x02, 0xde, 0xdb], [0x02, 0xde, 0xdb, 0x39], [0xde, 0xdb, 0x39, 0x02]]),
            ShiftRowRound(index: 2,
                          temp: [0x87, 0x53, 0xd2, 0x96],
                          shifts: [[0x53, 0xd2, 0x96, 0x87], [0xd2, 0x96, 0x87, 0x53], []]),
            ShiftRowRound(index: 3,
                          temp: [0x3b, 0x89, 0xf1, 0x1a],
                          shifts: [[0x89, 0xf1, 0x1a, 0x3b], [], []]),
        ]
        
        let copyOfTestOne = testOne
        let copyOfTestTwo = testTwo
        
        let historyOutputOne = state.shiftRows(state: &testOne, isInverse: false)
        let historyOutputTwo = state.shiftRows(state: &testTwo, isInverse: false)
        
        XCTAssertEqual(testOne,
                       resultOne,
                       "ShiftRows failed: Expected result does not match for testOne")
        XCTAssertEqual(historyOutputOne,
                       historyExceptedOutputOne,
                       "ShiftRows history mismatch for testOne")
        
        XCTAssertEqual(testTwo,
                       resultTwo,
                       "ShiftRows failed: Expected result does not match for testTwo")
        XCTAssertEqual(historyOutputTwo,
                       historyExceptedOutputTwo,
                       "ShiftRows history mismatch for testTwo")
        
        let historyOutputOneRev = state.shiftRows(state: &testOne, isInverse: true)
        let historyOutputTwoRev = state.shiftRows(state: &testTwo, isInverse: true)
        
        XCTAssertEqual(testOne,
                       copyOfTestOne,
                       "Inverse ShiftRows failed: testOne state should match original after inverse transformation")
        XCTAssertEqual(historyOutputOneRev,
                       historyExceptedOutputOneRev,
                       "Inverse ShiftRows history mismatch for testOne")
        
        XCTAssertEqual(testTwo,
                       copyOfTestTwo,
                       "Inverse ShiftRows failed: testTwo state should match original after inverse transformation")
        XCTAssertEqual(historyOutputTwoRev,
                       historyExceptedOutputTwoRev,
                       "Inverse ShiftRows history mismatch for testTwo")
    }
    
    func testMixColumn() throws {
        var testOne: [[Byte]] = [
            [0xd4, 0xe0, 0xb8, 0x1e],
            [0xbf, 0xb4, 0x41, 0x27],
            [0x5d, 0x52, 0x11, 0x98],
            [0x30, 0xae, 0xf1, 0xe5]
        ]
        var testTwo: [[Byte]] = [
            [0x49, 0x45, 0x7f, 0x77],
            [0xdb, 0x39, 0x02, 0xde],
            [0x87, 0x53, 0xd2, 0x96],
            [0x3b, 0x89, 0xf1, 0x1a]
        ]
        
        let resultOne: [[Byte]] = [
            [0x04, 0xe0, 0x48, 0x28],
            [0x66, 0xCB, 0xF8, 0x06],
            [0x81, 0x19, 0xd3, 0x26],
            [0xe5, 0x9a, 0x7a, 0x4c]
        ]
        let resultTwo: [[Byte]] = [
            [0x58, 0x1b, 0xdb, 0x1b],
            [0x4d, 0x4b, 0xe7, 0x6b],
            [0xca, 0x5a, 0xca, 0xb0],
            [0xf1, 0xac, 0xa8, 0xe5]
        ]
        
        let copyOfTestOne = testOne
        let copyOfTestTwo = testTwo
        
        state.mixColumns(state: &testOne, isInverse: false)
        state.mixColumns(state: &testTwo, isInverse: false)
        
        XCTAssertEqual(testOne,
                       resultOne,
                       "MixColumn failed: Expected result does not match for testOne")
        XCTAssertEqual(testTwo,
                       resultTwo,
                       "MixColumn failed: Expected result does not match for testTwo")
        
        state.mixColumns(state: &testOne, isInverse: true)
        state.mixColumns(state: &testTwo, isInverse: true)
        
        XCTAssertEqual(testOne,
                       copyOfTestOne,
                       "Inverse MixColumn failed: testOne state should match original after inverse transformation")
        XCTAssertEqual(testTwo,
                       copyOfTestTwo,
                       "Inverse MixColumn failed: testTwo state should match original after inverse transformation")
        
    }
    
    func testSubBytes() throws {
        var testOne: [[Byte]] = [
            [0xaa, 0x61, 0x82, 0x68],
            [0x8f, 0xdd, 0xd2, 0x32],
            [0x5f, 0xe3, 0x4a, 0x46],
            [0x03, 0xef, 0xd2, 0x9a]
        ]
        let resultOne: [[Byte]] = [
            [0xac, 0xef, 0x13, 0x45],
            [0x73, 0xc1, 0xb5, 0x23],
            [0xcf, 0x11, 0xd6, 0x5a],
            [0x7b, 0xdf, 0xb5, 0xb8]
        ]
        
        var testTwo: [[Byte]] = [
            [0x48, 0x67, 0x4d, 0xd6],
            [0x6c, 0x1d, 0xe3, 0x5f],
            [0x4e, 0x9d, 0xb1, 0x58],
            [0xee, 0x0d, 0x38, 0xe7]
        ]
        let resultTwo: [[Byte]] = [
            [0x52, 0x85, 0xe3, 0xf6],
            [0x50, 0xa4, 0x11, 0xcf],
            [0x2f, 0x5e, 0xc8, 0x6a],
            [0x28, 0xd7, 0x07, 0x94]
        ]
        
        let copyOfTestOne = testOne
        let copyOfTestTwo = testTwo
        
        state.subBytes(state: &testOne, isInverse: false)
        state.subBytes(state: &testTwo, isInverse: false)
        
        XCTAssertEqual(testOne,
                       resultOne,
                       "SubBytes failed: Expected result does not match for testOne")
        XCTAssertEqual(testTwo,
                       resultTwo,
                       "SubBytes failed: Expected result does not match for testTwo")
        
        state.subBytes(state: &testOne, isInverse: true)
        state.subBytes(state: &testTwo, isInverse: true)
        
        XCTAssertEqual(testOne,
                       copyOfTestOne,
                       "Inverse SubBytes failed: testOne state should match original after inverse transformation")
        XCTAssertEqual(testTwo,
                       copyOfTestTwo,
                       "Inverse SubBytes failed: testTwo state should match original after inverse transformation")
    }
    
    func testAddRoundKey() throws {
        var testOne: [[Byte]] = [
            [0x04, 0xe0, 0x48, 0x28],
            [0x66, 0xcb, 0xf8, 0x06],
            [0x81, 0x19, 0xd3, 0x26],
            [0xe5, 0x9a, 0x7a, 0x4c]
        ]
        let keyOne: [[Byte]] = [
            [0xa0, 0x88, 0x23, 0x2a],
            [0xfa, 0x54, 0xa3, 0x6c],
            [0xfe, 0x2c, 0x39, 0x76],
            [0x17, 0xb1, 0x39, 0x05]
        ]
        let resultOne: [[Byte]] = [
            [0xa4, 0x68, 0x6b, 0x02],
            [0x9c, 0x9f, 0x5b, 0x6a],
            [0x7f, 0x35, 0xea, 0x50],
            [0xf2, 0x2b, 0x43, 0x49]
        ]
        
        var testTwo: [[Byte]] = [
            [0x58, 0x1b, 0xdb, 0x1b],
            [0x4d, 0x4b, 0xe7, 0x6b],
            [0xca, 0x5a, 0xca, 0xb0],
            [0xf1, 0xac, 0xa8, 0xe5]
        ]
        let keyTwo: [[Byte]] = [
            [0xf2, 0x7a, 0x59, 0x73],
            [0xc2, 0x96, 0x35, 0x59],
            [0x95, 0xb9, 0x80, 0xf6],
            [0xf2, 0x43, 0x7a, 0x7f]
        ]
        let resultTwo: [[Byte]] = [
            [0xaa, 0x61, 0x82, 0x68],
            [0x8f, 0xdd, 0xd2, 0x32],
            [0x5f, 0xe3, 0x4a, 0x46],
            [0x03, 0xef, 0xd2, 0x9a]
        ]
        
        state.addRoundKey(state: &testOne, key: keyOne)
        state.addRoundKey(state: &testTwo, key: keyTwo)
        
        XCTAssertEqual(testOne,
                       resultOne,
                       "AddRoundKey failed: Expected result does not match for testOne")
        XCTAssertEqual(testTwo,
                       resultTwo,
                       "AddRoundKey failed: Expected result does not match for testTwo")
    }
    
}
