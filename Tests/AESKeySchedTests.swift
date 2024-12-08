//
//  AESKeySchedTests.swift
//  AES-ArchitectureTests
//
//  Created by Leon Chamoun on 25.09.24.
//

import XCTest
@testable import AES_Visualization

final class AESKeySchedTests: XCTestCase {
    var keySched: AESKeySchedule!
    
    override func setUpWithError() throws {
        keySched = AESKeySchedule()
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        keySched = nil
        super.tearDown()
    }
    
    func testRotWord() throws {
        let testOne: [Byte] = [1, 2, 3, 4]
        let expectedOutputOne: [Byte] = [2, 3, 4, 1]
        
        let testTwo: [Byte] = [0x00, 0x00, 0x00, 0xFF]
        let expectedOutputTwo: [Byte] = [0x00, 0x00, 0xFF, 0x00]
        
        let testThree: [Byte] = [0x00, 0x00, 0x00, 0x00]
        let expectedOutputThree = testThree
        
        
        XCTAssertEqual(keySched.rotWord(testOne),
                       expectedOutputOne,
                       "RotWord failed: Expected \(expectedOutputOne) but got \(keySched.rotWord(testOne)) for input \(testOne)")
        XCTAssertEqual(keySched.rotWord(testTwo),
                       expectedOutputTwo,
                       "RotWord failed: Expected \(expectedOutputTwo) but got \(keySched.rotWord(testTwo)) for input \(testTwo)")
        XCTAssertEqual(keySched.rotWord(testThree),
                       expectedOutputThree,
                       "RotWord failed: Expected \(expectedOutputThree) but got \(keySched.rotWord(testThree)) for input \(testThree)")
    }
    
    func testSubWords() throws {
        let testOne: [Byte] = [0xCF, 0x4F, 0x3C, 0x09]
        let expectedOutputOne: [Byte] = [0x8A, 0x84, 0xEB, 0x01]
        
        let testTwo: [Byte] = [0x6C, 0x76, 0x05, 0x2A]
        let expectedOutputTwo: [Byte] = [0x50, 0x38, 0x6B, 0xE5]
        
        let testThree: [Byte] = [0x7A, 0x88, 0x3B, 0x6D]
        let expectedOutputThree: [Byte] = [0xDA, 0xC4, 0xE2, 0x3C]
        
        XCTAssertEqual(keySched.subWord(testOne),
                       expectedOutputOne,
                       "SubWord failed: Expected \(expectedOutputOne) but got \(keySched.subWord(testOne)) for input \(testOne)")

        XCTAssertEqual(keySched.subWord(testTwo),
                       expectedOutputTwo,
                       "SubWord failed: Expected \(expectedOutputTwo) but got \(keySched.subWord(testTwo)) for input \(testTwo)")

        XCTAssertEqual(keySched.subWord(testThree),
                       expectedOutputThree,
                       "SubWord failed: Expected \(expectedOutputThree) but got \(keySched.subWord(testThree)) for input \(testThree)")

    }
    
    func testKeyExp128() throws {
        let key: [Byte] = [
            0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6,
            0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let expectedRoundKeys: [[Byte]] = [
            [0x2B, 0x7E, 0x15, 0x16, 0x28, 0xAE, 0xD2, 0xA6, 0xAB, 0xF7, 0x15, 0x88, 0x09, 0xCF, 0x4F, 0x3C],
            [0xA0, 0xFA, 0xFE, 0x17, 0x88, 0x54, 0x2C, 0xB1, 0x23, 0xA3, 0x39, 0x39, 0x2A, 0x6C, 0x76, 0x05],
            [0xF2, 0xC2, 0x95, 0xF2, 0x7A, 0x96, 0xB9, 0x43, 0x59, 0x35, 0x80, 0x7A, 0x73, 0x59, 0xF6, 0x7F],
            [0x3D, 0x80, 0x47, 0x7D, 0x47, 0x16, 0xFE, 0x3E, 0x1E, 0x23, 0x7E, 0x44, 0x6D, 0x7A, 0x88, 0x3B],
            [0xEF, 0x44, 0xA5, 0x41, 0xA8, 0x52, 0x5B, 0x7F, 0xB6, 0x71, 0x25, 0x3B, 0xDB, 0x0B, 0xAD, 0x00],
            [0xD4, 0xD1, 0xC6, 0xF8, 0x7C, 0x83, 0x9D, 0x87, 0xCA, 0xF2, 0xB8, 0xBC, 0x11, 0xF9, 0x15, 0xBC],
            [0x6D, 0x88, 0xA3, 0x7A, 0x11, 0x0B, 0x3E, 0xFD, 0xDB, 0xF9, 0x86, 0x41, 0xCA, 0x00, 0x93, 0xFD],
            [0x4E, 0x54, 0xF7, 0x0E, 0x5F, 0x5F, 0xC9, 0xF3, 0x84, 0xA6, 0x4F, 0xB2, 0x4E, 0xA6, 0xDC, 0x4F],
            [0xEA, 0xD2, 0x73, 0x21, 0xB5, 0x8D, 0xBA, 0xD2, 0x31, 0x2B, 0xF5, 0x60, 0x7F, 0x8D, 0x29, 0x2F],
            [0xAC, 0x77, 0x66, 0xF3, 0x19, 0xFA, 0xDC, 0x21, 0x28, 0xD1, 0x29, 0x41, 0x57, 0x5C, 0x00, 0x6E],
            [0xD0, 0x14, 0xF9, 0xA8, 0xC9, 0xEE, 0x25, 0x89, 0xE1, 0x3F, 0x0C, 0xC8, 0xB6, 0x63, 0x0C, 0xA6]
        ]
        let expectedKeyExpHistory = [
            KeyExpansionRound(
                index: 4,
                temp: [0x09, 0xcf, 0x4f, 0x3c],
                afterRotWord: [0xcf, 0x4f, 0x3c, 0x09],
                afterSubWord: [0x8a, 0x84, 0xeb, 0x01],
                rcon: [0x01, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x8b, 0x84, 0xeb, 0x01],
                wIMinusNK: [0x2b, 0x7e, 0x15, 0x16],
                result: [0xa0, 0xfa, 0xfe, 0x17]
            ),
            KeyExpansionRound(
                index: 5,
                temp: [0xa0, 0xfa, 0xfe, 0x17],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x28, 0xae, 0xd2, 0xa6],
                result: [0x88, 0x54, 0x2c, 0xb1]
            ),
            KeyExpansionRound(
                index: 6,
                temp: [0x88, 0x54, 0x2c, 0xb1],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xab, 0xf7, 0x15, 0x88],
                result: [0x23, 0xa3, 0x39, 0x39]
            ),
            KeyExpansionRound(
                index: 7,
                temp: [0x23, 0xa3, 0x39, 0x39],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x09, 0xcf, 0x4f, 0x3c],
                result: [0x2a, 0x6c, 0x76, 0x05]
            ),
            
            KeyExpansionRound(
                index: 8,
                temp: [0x2a, 0x6c, 0x76, 0x05],
                afterRotWord: [0x6c, 0x76, 0x05, 0x2a],
                afterSubWord: [0x50, 0x38, 0x6b, 0xe5],
                rcon: [0x02, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x52, 0x38, 0x6b, 0xe5],
                wIMinusNK: [0xa0, 0xfa, 0xfe, 0x17],
                result: [0xf2, 0xc2, 0x95, 0xf2]
            ),
            KeyExpansionRound(
                index: 9,
                temp: [0xf2, 0xc2, 0x95, 0xf2],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x88, 0x54, 0x2c, 0xb1],
                result: [0x7a, 0x96, 0xb9, 0x43]
            ),
            KeyExpansionRound(
                index: 10,
                temp: [0x7a, 0x96, 0xb9, 0x43],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x23, 0xa3, 0x39, 0x39],
                result: [0x59, 0x35, 0x80, 0x7a]
            ),
            KeyExpansionRound(
                index: 11,
                temp: [0x59, 0x35, 0x80, 0x7a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x2a, 0x6c, 0x76, 0x05],
                result: [0x73, 0x59, 0xf6, 0x7f]
            ),
            KeyExpansionRound(
                index: 12,
                temp: [0x73, 0x59, 0xf6, 0x7f],
                afterRotWord: [0x59, 0xf6, 0x7f, 0x73],
                afterSubWord: [0xcb, 0x42, 0xd2, 0x8f],
                rcon: [0x04, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xcf, 0x42, 0xd2, 0x8f],
                wIMinusNK: [0xf2, 0xc2, 0x95, 0xf2],
                result: [0x3d, 0x80, 0x47, 0x7d]
            ),
            KeyExpansionRound(
                index: 13,
                temp: [0x3d, 0x80, 0x47, 0x7d],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x7a, 0x96, 0xb9, 0x43],
                result: [0x47, 0x16, 0xfe, 0x3e]
            ),
            KeyExpansionRound(
                index: 14,
                temp: [0x47, 0x16, 0xfe, 0x3e],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x59, 0x35, 0x80, 0x7a],
                result: [0x1e, 0x23, 0x7e, 0x44]
            ),
            KeyExpansionRound(
                index: 15,
                temp: [0x1e, 0x23, 0x7e, 0x44],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x73, 0x59, 0xf6, 0x7f],
                result: [0x6d, 0x7a, 0x88, 0x3b]
            ),
            KeyExpansionRound(
                index: 16,
                temp: [0x6d, 0x7a, 0x88, 0x3b],
                afterRotWord: [0x7a, 0x88, 0x3b, 0x6d],
                afterSubWord: [0xda, 0xc4, 0xe2, 0x3c],
                rcon: [0x08, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xd2, 0xc4, 0xe2, 0x3c],
                wIMinusNK: [0x3d, 0x80, 0x47, 0x7d],
                result: [0xef, 0x44, 0xa5, 0x41]
            ),
            KeyExpansionRound(
                index: 17,
                temp: [0xef, 0x44, 0xa5, 0x41],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x47, 0x16, 0xfe, 0x3e],
                result: [0xa8, 0x52, 0x5b, 0x7f]
            ),
            KeyExpansionRound(
                index: 18,
                temp: [0xa8, 0x52, 0x5b, 0x7f],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x1e, 0x23, 0x7e, 0x44],
                result: [0xb6, 0x71, 0x25, 0x3b]
            ),
            KeyExpansionRound(
                index: 19,
                temp: [0xb6, 0x71, 0x25, 0x3b],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x6d, 0x7a, 0x88, 0x3b],
                result: [0xdb, 0x0b, 0xad, 0x00]
            ),
            KeyExpansionRound(
                index: 20,
                temp: [0xdb, 0x0b, 0xad, 0x00],
                afterRotWord: [0x0b, 0xad, 0x00, 0xdb],
                afterSubWord: [0x2b, 0x95, 0x63, 0xb9],
                rcon: [0x10, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x3b, 0x95, 0x63, 0xb9],
                wIMinusNK: [0xef, 0x44, 0xa5, 0x41],
                result: [0xd4, 0xd1, 0xc6, 0xf8]
            ),
            KeyExpansionRound(
                index: 21,
                temp: [0xd4, 0xd1, 0xc6, 0xf8],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xa8, 0x52, 0x5b, 0x7f],
                result: [0x7c, 0x83, 0x9d, 0x87]
            ),
            KeyExpansionRound(
                index: 22,
                temp: [0x7c, 0x83, 0x9d, 0x87],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xb6, 0x71, 0x25, 0x3b],
                result: [0xca, 0xf2, 0xb8, 0xbc]
            ),
            KeyExpansionRound(
                index: 23,
                temp: [0xca, 0xf2, 0xb8, 0xbc],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xdb, 0x0b, 0xad, 0x00],
                result: [0x11, 0xf9, 0x15, 0xbc]
            ),
            KeyExpansionRound(
                index: 24,
                temp: [0x11, 0xf9, 0x15, 0xbc],
                afterRotWord: [0xf9, 0x15, 0xbc, 0x11],
                afterSubWord: [0x99, 0x59, 0x65, 0x82],
                rcon: [0x20, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xb9, 0x59, 0x65, 0x82],
                wIMinusNK: [0xd4, 0xd1, 0xc6, 0xf8],
                result: [0x6d, 0x88, 0xa3, 0x7a]
            ),
            KeyExpansionRound(
                index: 25,
                temp: [0x6d, 0x88, 0xa3, 0x7a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x7c, 0x83, 0x9d, 0x87],
                result: [0x11, 0x0b, 0x3e, 0xfd]
            ),
            KeyExpansionRound(
                index: 26,
                temp: [0x11, 0x0b, 0x3e, 0xfd],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xca, 0xf2, 0xb8, 0xbc],
                result: [0xdb, 0xf9, 0x86, 0x41]
            ),
            KeyExpansionRound(
                index: 27,
                temp: [0xdb, 0xf9, 0x86, 0x41],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x11, 0xf9, 0x15, 0xbc],
                result: [0xca, 0x00, 0x93, 0xfd]
            ),
            KeyExpansionRound(
                index: 28,
                temp: [0xca, 0x00, 0x93, 0xfd],
                afterRotWord: [0x00, 0x93, 0xfd, 0xca],
                afterSubWord: [0x63, 0xdc, 0x54, 0x74],
                rcon: [0x40, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x23, 0xdc, 0x54, 0x74],
                wIMinusNK: [0x6d, 0x88, 0xa3, 0x7a],
                result: [0x4e, 0x54, 0xf7, 0x0e]
            ),
            KeyExpansionRound(
                index: 29,
                temp: [0x4e, 0x54, 0xf7, 0x0e],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x11, 0x0b, 0x3e, 0xfd],
                result: [0x5f, 0x5f, 0xc9, 0xf3]
            ),
            KeyExpansionRound(
                index: 30,
                temp: [0x5f, 0x5f, 0xc9, 0xf3],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xdb, 0xf9, 0x86, 0x41],
                result: [0x84, 0xa6, 0x4f, 0xb2]
            ),
            KeyExpansionRound(
                index: 31,
                temp: [0x84, 0xa6, 0x4f, 0xb2],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xca, 0x00, 0x93, 0xfd],
                result: [0x4e, 0xa6, 0xdc, 0x4f]
            ),
            KeyExpansionRound(
                index: 32,
                temp: [0x4e, 0xa6, 0xdc, 0x4f],
                afterRotWord: [0xa6, 0xdc, 0x4f, 0x4e],
                afterSubWord: [0x24, 0x86, 0x84, 0x2f],
                rcon: [0x80, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xa4, 0x86, 0x84, 0x2f],
                wIMinusNK: [0x4e, 0x54, 0xf7, 0x0e],
                result: [0xea, 0xd2, 0x73, 0x21]
            ),
            KeyExpansionRound(
                index: 33,
                temp: [0xea, 0xd2, 0x73, 0x21],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x5f, 0x5f, 0xc9, 0xf3],
                result: [0xb5, 0x8d, 0xba, 0xd2]
            ),
            KeyExpansionRound(
                index: 34,
                temp: [0xb5, 0x8d, 0xba, 0xd2],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x84, 0xa6, 0x4f, 0xb2],
                result: [0x31, 0x2b, 0xf5, 0x60]
            ),
            KeyExpansionRound(
                index: 35,
                temp: [0x31, 0x2b, 0xf5, 0x60],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x4e, 0xa6, 0xdc, 0x4f],
                result: [0x7f, 0x8d, 0x29, 0x2f]
            ),
            KeyExpansionRound(
                index: 36,
                temp: [0x7f, 0x8d, 0x29, 0x2f],
                afterRotWord: [0x8d, 0x29, 0x2f, 0x7f],
                afterSubWord: [0x5d, 0xa5, 0x15, 0xd2],
                rcon: [0x1b, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x46, 0xa5, 0x15, 0xd2],
                wIMinusNK: [0xea, 0xd2, 0x73, 0x21],
                result: [0xac, 0x77, 0x66, 0xf3]
            ),
            KeyExpansionRound(
                index: 37,
                temp: [0xac, 0x77, 0x66, 0xf3],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xb5, 0x8d, 0xba, 0xd2],
                result: [0x19, 0xfa, 0xdc, 0x21]
            ),
            KeyExpansionRound(
                index: 38,
                temp: [0x19, 0xfa, 0xdc, 0x21],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x31, 0x2b, 0xf5, 0x60],
                result: [0x28, 0xd1, 0x29, 0x41]
            ),
            KeyExpansionRound(
                index: 39,
                temp: [0x28, 0xd1, 0x29, 0x41],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x7f, 0x8d, 0x29, 0x2f],
                result: [0x57, 0x5c, 0x00, 0x6e]
            ),
            KeyExpansionRound(
                index: 40,
                temp: [0x57, 0x5c, 0x00, 0x6e],
                afterRotWord: [0x5c, 0x00, 0x6e, 0x57],
                afterSubWord: [0x4a, 0x63, 0x9f, 0x5b],
                rcon: [0x36, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x7c, 0x63, 0x9f, 0x5b],
                wIMinusNK: [0xac, 0x77, 0x66, 0xf3],
                result: [0xd0, 0x14, 0xf9, 0xa8]
            ),
            KeyExpansionRound(
                index: 41,
                temp: [0xd0, 0x14, 0xf9, 0xa8],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x19, 0xfa, 0xdc, 0x21],
                result: [0xc9, 0xee, 0x25, 0x89]
            ),
            KeyExpansionRound(
                index: 42,
                temp: [0xc9, 0xee, 0x25, 0x89],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x28, 0xd1, 0x29, 0x41],
                result: [0xe1, 0x3f, 0x0c, 0xc8]
            ),
            KeyExpansionRound(
                index: 43,
                temp: [0xe1, 0x3f, 0x0c, 0xc8],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x57, 0x5c, 0x00, 0x6e],
                result: [0xb6, 0x63, 0x0c, 0xa6]
            )
        ]
        
        keySched.keyExpansion(key: key)
        XCTAssertEqual(keySched.getNrOfRounds,
                       10,
                       "Wrong number of rounds: Expected 10 but got \(keySched.getNrOfRounds)")
        
        XCTAssertEqual(keySched.getNk,
                       4,
                       "Wrong number of key size: Expected 4 but got \(keySched.getNk)")
        
        let keySize = AESConfiguration(rawValue: 4)!
        XCTAssertEqual(keySched.getKeySize,
                       keySize,
                       "Wrong key size: Expected \(keySize) but got \(String(describing: keySched.getKeySize))")

        let actualRoundKeys = keySched.getRoundKeys
        for (index, expectedKey) in expectedRoundKeys.enumerated() {
            let actualKey = actualRoundKeys[index]
            XCTAssertEqual(actualKey, expectedKey, "KeyExpansion failed: Round key at index \(index) does not match expected value.")
        }
        
        let actualKeySchedule = keySched.getDetailedKeySchedule
        for (index, expectedRound) in expectedKeyExpHistory.enumerated() {
            let actualRound = actualKeySchedule[index]
            
            XCTAssertEqual(actualRound.index, expectedRound.index, "Round \(index): Index does not match.")
            XCTAssertEqual(actualRound.temp, expectedRound.temp, "Round \(index): Temp value does not match.")
            XCTAssertEqual(actualRound.afterRotWord, expectedRound.afterRotWord, "Round \(index): After RotWord does not match.")
            XCTAssertEqual(actualRound.afterSubWord, expectedRound.afterSubWord, "Round \(index): After SubWord does not match.")
            XCTAssertEqual(actualRound.rcon, expectedRound.rcon, "Round \(index): RCON does not match.")
            XCTAssertEqual(actualRound.afterXORWithRCON, expectedRound.afterXORWithRCON, "Round \(index): After XOR with RCON does not match.")
            XCTAssertEqual(actualRound.wIMinusNK, expectedRound.wIMinusNK, "Round \(index): w[i - Nk] does not match.")
            XCTAssertEqual(actualRound.result, expectedRound.result, "Round \(index): Result does not match.")
        }
    }
    
    func testKeyExp192() throws {
        let key: [Byte]  = [
            0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52,
            0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5,
            0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b
        ]
        let expectedRoundKeys: [[Byte]] = [
            [0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52, 0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5],
            [0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b, 0xfe, 0x0c, 0x91, 0xf7, 0x24, 0x02, 0xf5, 0xa5],
            [0xec, 0x12, 0x06, 0x8e, 0x6c, 0x82, 0x7f, 0x6b, 0x0e, 0x7a, 0x95, 0xb9, 0x5c, 0x56, 0xfe, 0xc2],
            [0x4d, 0xb7, 0xb4, 0xbd, 0x69, 0xb5, 0x41, 0x18, 0x85, 0xa7, 0x47, 0x96, 0xe9, 0x25, 0x38, 0xfd],
            [0xe7, 0x5f, 0xad, 0x44, 0xbb, 0x09, 0x53, 0x86, 0x48, 0x5a, 0xf0, 0x57, 0x21, 0xef, 0xb1, 0x4f],
            [0xa4, 0x48, 0xf6, 0xd9, 0x4d, 0x6d, 0xce, 0x24, 0xaa, 0x32, 0x63, 0x60, 0x11, 0x3b, 0x30, 0xe6],
            [0xa2, 0x5e, 0x7e, 0xd5, 0x83, 0xb1, 0xcf, 0x9a, 0x27, 0xf9, 0x39, 0x43, 0x6a, 0x94, 0xf7, 0x67],
            [0xc0, 0xa6, 0x94, 0x07, 0xd1, 0x9d, 0xa4, 0xe1, 0xec, 0x17, 0x86, 0xeb, 0x6f, 0xa6, 0x49, 0x71],
            [0x48, 0x5f, 0x70, 0x32, 0x22, 0xcb, 0x87, 0x55, 0xe2, 0x6d, 0x13, 0x52, 0x33, 0xf0, 0xb7, 0xb3],
            [0x40, 0xbe, 0xeb, 0x28, 0x2f, 0x18, 0xa2, 0x59, 0x67, 0x47, 0xd2, 0x6b, 0x45, 0x8c, 0x55, 0x3e],
            [0xa7, 0xe1, 0x46, 0x6c, 0x94, 0x11, 0xf1, 0xdf, 0x82, 0x1f, 0x75, 0x0a, 0xad, 0x07, 0xd7, 0x53],
            [0xca, 0x40, 0x05, 0x38, 0x8f, 0xcc, 0x50, 0x06, 0x28, 0x2d, 0x16, 0x6a, 0xbc, 0x3c, 0xe7, 0xb5],
            [0xe9, 0x8b, 0xa0, 0x6f, 0x44, 0x8c, 0x77, 0x3c, 0x8e, 0xcc, 0x72, 0x04, 0x01, 0x00, 0x22, 0x02]
        ]
        let expectedKeyExpHistory: [KeyExpansionRound] = [
            KeyExpansionRound(
                index: 6,
                temp: [0x52, 0x2c, 0x6b, 0x7b],
                afterRotWord: [0x2c, 0x6b, 0x7b, 0x52],
                afterSubWord: [0x71, 0x7f, 0x21, 0x00],
                rcon: [0x01, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x70, 0x7f, 0x21, 0x00],
                wIMinusNK: [0x8e, 0x73, 0xb0, 0xf7],
                result: [0xfe, 0x0c, 0x91, 0xf7]
            ),
            KeyExpansionRound(
                index: 7,
                temp: [0xfe, 0x0c, 0x91, 0xf7],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xda, 0x0e, 0x64, 0x52],
                result: [0x24, 0x02, 0xf5, 0xa5]
            ),
            KeyExpansionRound(
                index: 8,
                temp: [0x24, 0x02, 0xf5, 0xa5],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xc8, 0x10, 0xf3, 0x2b],
                result: [0xec, 0x12, 0x06, 0x8e]
            ),
            KeyExpansionRound(
                index: 9,
                temp: [0xec, 0x12, 0x06, 0x8e],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x80, 0x90, 0x79, 0xe5],
                result: [0x6c, 0x82, 0x7f, 0x6b]
            ),
            KeyExpansionRound(
                index: 10,
                temp: [0x6c, 0x82, 0x7f, 0x6b],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x62, 0xf8, 0xea, 0xd2],
                result: [0x0e, 0x7a, 0x95, 0xb9]
            ),
            KeyExpansionRound(
                index: 11,
                temp: [0x0e, 0x7a, 0x95, 0xb9],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x52, 0x2c, 0x6b, 0x7b],
                result: [0x5c, 0x56, 0xfe, 0xc2]
            ),
            KeyExpansionRound(
                index: 12,
                temp: [0x5c, 0x56, 0xfe, 0xc2],
                afterRotWord: [0x56, 0xfe, 0xc2, 0x5c],
                afterSubWord: [0xb1, 0xbb, 0x25, 0x4a],
                rcon: [0x02, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xb3, 0xbb, 0x25, 0x4a],
                wIMinusNK: [0xfe, 0x0c, 0x91, 0xf7],
                result: [0x4d, 0xb7, 0xb4, 0xbd]
            ),
            KeyExpansionRound(
                index: 13,
                temp: [0x4d, 0xb7, 0xb4, 0xbd],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x24, 0x02, 0xf5, 0xa5],
                result: [0x69, 0xb5, 0x41, 0x18]
            ),
            KeyExpansionRound(
                index: 14,
                temp: [0x69, 0xb5, 0x41, 0x18],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xec, 0x12, 0x06, 0x8e],
                result: [0x85, 0xa7, 0x47, 0x96]
            ),
            KeyExpansionRound(
                index: 15,
                temp: [0x85, 0xa7, 0x47, 0x96],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x6c, 0x82, 0x7f, 0x6b],
                result: [0xe9, 0x25, 0x38, 0xfd]
            ),
            KeyExpansionRound(
                index: 16,
                temp: [0xe9, 0x25, 0x38, 0xfd],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x0e, 0x7a, 0x95, 0xb9],
                result: [0xe7, 0x5f, 0xad, 0x44]
            ),
            KeyExpansionRound(
                index: 17,
                temp: [0xe7, 0x5f, 0xad, 0x44],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x5c, 0x56, 0xfe, 0xc2],
                result: [0xbb, 0x09, 0x53, 0x86]
            ),
            KeyExpansionRound(
                index: 18,
                temp: [0xbb, 0x09, 0x53, 0x86],
                afterRotWord: [0x09, 0x53, 0x86, 0xbb],
                afterSubWord: [0x01, 0xed, 0x44, 0xea],
                rcon: [0x04, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x05, 0xed, 0x44, 0xea],
                wIMinusNK: [0x4d, 0xb7, 0xb4, 0xbd],
                result: [0x48, 0x5a, 0xf0, 0x57]
            ),
            KeyExpansionRound(
                index: 19,
                temp: [0x48, 0x5a, 0xf0, 0x57],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x69, 0xb5, 0x41, 0x18],
                result: [0x21, 0xef, 0xb1, 0x4f]
            ),
            KeyExpansionRound(
                index: 20,
                temp: [0x21, 0xef, 0xb1, 0x4f],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x85, 0xa7, 0x47, 0x96],
                result: [0xa4, 0x48, 0xf6, 0xd9]
            ),
            KeyExpansionRound(
                index: 21,
                temp: [0xa4, 0x48, 0xf6, 0xd9],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xe9, 0x25, 0x38, 0xfd],
                result: [0x4d, 0x6d, 0xce, 0x24]
            ),
            KeyExpansionRound(
                index: 22,
                temp: [0x4d, 0x6d, 0xce, 0x24],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xe7, 0x5f, 0xad, 0x44],
                result: [0xaa, 0x32, 0x63, 0x60]
            ),
            KeyExpansionRound(
                index: 23,
                temp: [0xaa, 0x32, 0x63, 0x60],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xbb, 0x09, 0x53, 0x86],
                result: [0x11, 0x3b, 0x30, 0xe6]
            ),
            KeyExpansionRound(
                index: 24,
                temp: [0x11, 0x3b, 0x30, 0xe6],
                afterRotWord: [0x3b, 0x30, 0xe6, 0x11],
                afterSubWord: [0xe2, 0x04, 0x8e, 0x82],
                rcon: [0x08, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xea, 0x04, 0x8e, 0x82],
                wIMinusNK: [0x48, 0x5a, 0xf0, 0x57],
                result: [0xa2, 0x5e, 0x7e, 0xd5]
            ),
            KeyExpansionRound(
                index: 25,
                temp: [0xa2, 0x5e, 0x7e, 0xd5],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x21, 0xef, 0xb1, 0x4f],
                result: [0x83, 0xb1, 0xcf, 0x9a]
            ),
            KeyExpansionRound(
                index: 26,
                temp: [0x83, 0xb1, 0xcf, 0x9a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xa4, 0x48, 0xf6, 0xd9],
                result: [0x27, 0xf9, 0x39, 0x43]
            ),
            KeyExpansionRound(
                index: 27,
                temp: [0x27, 0xf9, 0x39, 0x43],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x4d, 0x6d, 0xce, 0x24],
                result: [0x6a, 0x94, 0xf7, 0x67]
            ),
            KeyExpansionRound(
                index: 28,
                temp: [0x6a, 0x94, 0xf7, 0x67],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xaa, 0x32, 0x63, 0x60],
                result: [0xc0, 0xa6, 0x94, 0x07]
            ),
            KeyExpansionRound(
                index: 29,
                temp: [0xc0, 0xa6, 0x94, 0x07],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x11, 0x3b, 0x30, 0xe6],
                result: [0xd1, 0x9d, 0xa4, 0xe1]
            ),
            KeyExpansionRound(
                index: 30,
                temp: [0xd1, 0x9d, 0xa4, 0xe1],
                afterRotWord: [0x9d, 0xa4, 0xe1, 0xd1],
                afterSubWord: [0x5e, 0x49, 0xf8, 0x3e],
                rcon: [0x10, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x4e, 0x49, 0xf8, 0x3e],
                wIMinusNK: [0xa2, 0x5e, 0x7e, 0xd5],
                result: [0xec, 0x17, 0x86, 0xeb]
            ),
            KeyExpansionRound(
                index: 31,
                temp: [0xec, 0x17, 0x86, 0xeb],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x83, 0xb1, 0xcf, 0x9a],
                result: [0x6f, 0xa6, 0x49, 0x71]
            ),
            KeyExpansionRound(
                index: 32,
                temp: [0x6f, 0xa6, 0x49, 0x71],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x27, 0xf9, 0x39, 0x43],
                result: [0x48, 0x5f, 0x70, 0x32]
            ),
            KeyExpansionRound(
                index: 33,
                temp: [0x48, 0x5f, 0x70, 0x32],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x6a, 0x94, 0xf7, 0x67],
                result: [0x22, 0xcb, 0x87, 0x55]
            ),
            KeyExpansionRound(
                index: 34,
                temp: [0x22, 0xcb, 0x87, 0x55],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xc0, 0xa6, 0x94, 0x07],
                result: [0xe2, 0x6d, 0x13, 0x52]
            ),
            KeyExpansionRound(
                index: 35,
                temp: [0xe2, 0x6d, 0x13, 0x52],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xd1, 0x9d, 0xa4, 0xe1],
                result: [0x33, 0xf0, 0xb7, 0xb3]
            ),
            KeyExpansionRound(
                index: 36,
                temp: [0x33, 0xf0, 0xb7, 0xb3],
                afterRotWord: [0xf0, 0xb7, 0xb3, 0x33],
                afterSubWord: [0x8c, 0xa9, 0x6d, 0xc3],
                rcon: [0x20, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xac, 0xa9, 0x6d, 0xc3],
                wIMinusNK: [0xec, 0x17, 0x86, 0xeb],
                result: [0x40, 0xbe, 0xeb, 0x28]
            ),
            KeyExpansionRound(
                index: 37,
                temp: [0x40, 0xbe, 0xeb, 0x28],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x6f, 0xa6, 0x49, 0x71],
                result: [0x2f, 0x18, 0xa2, 0x59]
            ),
            KeyExpansionRound(
                index: 38,
                temp: [0x2f, 0x18, 0xa2, 0x59],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x48, 0x5f, 0x70, 0x32],
                result: [0x67, 0x47, 0xd2, 0x6b]
            ),
            KeyExpansionRound(
                index: 39,
                temp: [0x67, 0x47, 0xd2, 0x6b],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x22, 0xcb, 0x87, 0x55],
                result: [0x45, 0x8c, 0x55, 0x3e]
            ),
            KeyExpansionRound(
                index: 40,
                temp: [0x45, 0x8c, 0x55, 0x3e],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xe2, 0x6d, 0x13, 0x52],
                result: [0xa7, 0xe1, 0x46, 0x6c]
            ),
            KeyExpansionRound(
                index: 41,
                temp: [0xa7, 0xe1, 0x46, 0x6c],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x33, 0xf0, 0xb7, 0xb3],
                result: [0x94, 0x11, 0xf1, 0xdf]
            ),
            KeyExpansionRound(
                index: 42,
                temp: [0x94, 0x11, 0xf1, 0xdf],
                afterRotWord: [0x11, 0xf1, 0xdf, 0x94],
                afterSubWord: [0x82, 0xa1, 0x9e, 0x22],
                rcon: [0x40, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xc2, 0xa1, 0x9e, 0x22],
                wIMinusNK: [0x40, 0xbe, 0xeb, 0x28],
                result: [0x82, 0x1f, 0x75, 0x0a]
            ),
            KeyExpansionRound(
                index: 43,
                temp: [0x82, 0x1f, 0x75, 0x0a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x2f, 0x18, 0xa2, 0x59],
                result: [0xad, 0x07, 0xd7, 0x53]
            ),
            KeyExpansionRound(
                index: 44,
                temp: [0xad, 0x07, 0xd7, 0x53],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x67, 0x47, 0xd2, 0x6b],
                result: [0xca, 0x40, 0x05, 0x38]
            ),
            KeyExpansionRound(
                index: 45,
                temp: [0xca, 0x40, 0x05, 0x38],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x45, 0x8c, 0x55, 0x3e],
                result: [0x8f, 0xcc, 0x50, 0x06]
            ),
            KeyExpansionRound(
                index: 46,
                temp: [0x8f, 0xcc, 0x50, 0x06],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xa7, 0xe1, 0x46, 0x6c],
                result: [0x28, 0x2d, 0x16, 0x6a]
            ),
            KeyExpansionRound(
                index: 47,
                temp: [0x28, 0x2d, 0x16, 0x6a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x94, 0x11, 0xf1, 0xdf],
                result: [0xbc, 0x3c, 0xe7, 0xb5]
            ),
            KeyExpansionRound(
                index: 48,
                temp: [0xbc, 0x3c, 0xe7, 0xb5],
                afterRotWord: [0x3c, 0xe7, 0xb5, 0xbc],
                afterSubWord: [0xeb, 0x94, 0xd5, 0x65],
                rcon: [0x80, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x6b, 0x94, 0xd5, 0x65],
                wIMinusNK: [0x82, 0x1f, 0x75, 0x0a],
                result: [0xe9, 0x8b, 0xa0, 0x6f]
            ),
            KeyExpansionRound(
                index: 49,
                temp: [0xe9, 0x8b, 0xa0, 0x6f],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xad, 0x07, 0xd7, 0x53],
                result: [0x44, 0x8c, 0x77, 0x3c]
            ),
            KeyExpansionRound(
                index: 50,
                temp: [0x44, 0x8c, 0x77, 0x3c],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xca, 0x40, 0x05, 0x38],
                result: [0x8e, 0xcc, 0x72, 0x04]
            ),
            KeyExpansionRound(
                index: 51,
                temp: [0x8e, 0xcc, 0x72, 0x04],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x8f, 0xcc, 0x50, 0x06],
                result: [0x01, 0x00, 0x22, 0x02]
            )
        ]
        
        keySched.keyExpansion(key: key)
        XCTAssertEqual(keySched.getNrOfRounds,
                       12,
                       "Wrong number of rounds: Expected 12 but got \(keySched.getNrOfRounds)")
        
        XCTAssertEqual(keySched.getNk,
                       6,
                       "Wrong number of key size: Expected 6 but got \(keySched.getNk)")
        
        let keySize = AESConfiguration(rawValue: 6)!
        XCTAssertEqual(keySched.getKeySize,
                       keySize,
                       "Wrong key size: Expected \(keySize) but got \(String(describing: keySched.getKeySize))")

        let actualRoundKeys = keySched.getRoundKeys
        for (index, expectedKey) in expectedRoundKeys.enumerated() {
            let actualKey = actualRoundKeys[index]
            XCTAssertEqual(actualKey, expectedKey, "KeyExpansion failed: Round key at index \(index) does not match expected value.")
        }
        
        let actualKeySchedule = keySched.getDetailedKeySchedule
        for (index, expectedRound) in expectedKeyExpHistory.enumerated() {
            let actualRound = actualKeySchedule[index]
            
            XCTAssertEqual(actualRound.index, expectedRound.index, "Round \(index): Index does not match.")
            XCTAssertEqual(actualRound.temp, expectedRound.temp, "Round \(index): Temp value does not match.")
            XCTAssertEqual(actualRound.afterRotWord, expectedRound.afterRotWord, "Round \(index): After RotWord does not match.")
            XCTAssertEqual(actualRound.afterSubWord, expectedRound.afterSubWord, "Round \(index): After SubWord does not match.")
            XCTAssertEqual(actualRound.rcon, expectedRound.rcon, "Round \(index): RCON does not match.")
            XCTAssertEqual(actualRound.afterXORWithRCON, expectedRound.afterXORWithRCON, "Round \(index): After XOR with RCON does not match.")
            XCTAssertEqual(actualRound.wIMinusNK, expectedRound.wIMinusNK, "Round \(index): w[i - Nk] does not match.")
            XCTAssertEqual(actualRound.result, expectedRound.result, "Round \(index): Result does not match.")
        }
    }
    
    func testKeyExp256() throws {
        let key: [Byte]  = [
            0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe,
            0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
            0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7,
            0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4
        ]
        let expectedRoundKeys: [[Byte]] = [
            [0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81],
            [0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4],
            [0x9b, 0xa3, 0x54, 0x11, 0x8e, 0x69, 0x25, 0xaf, 0xa5, 0x1a, 0x8b, 0x5f, 0x20, 0x67, 0xfc, 0xde],
            [0xa8, 0xb0, 0x9c, 0x1a, 0x93, 0xd1, 0x94, 0xcd, 0xbe, 0x49, 0x84, 0x6e, 0xb7, 0x5d, 0x5b, 0x9a],
            [0xd5, 0x9a, 0xec, 0xb8, 0x5b, 0xf3, 0xc9, 0x17, 0xfe, 0xe9, 0x42, 0x48, 0xde, 0x8e, 0xbe, 0x96],
            [0xb5, 0xa9, 0x32, 0x8a, 0x26, 0x78, 0xa6, 0x47, 0x98, 0x31, 0x22, 0x29, 0x2f, 0x6c, 0x79, 0xb3],
            [0x81, 0x2c, 0x81, 0xad, 0xda, 0xdf, 0x48, 0xba, 0x24, 0x36, 0x0a, 0xf2, 0xfa, 0xb8, 0xb4, 0x64],
            [0x98, 0xc5, 0xbf, 0xc9, 0xbe, 0xbd, 0x19, 0x8e, 0x26, 0x8c, 0x3b, 0xa7, 0x09, 0xe0, 0x42, 0x14],
            [0x68, 0x00, 0x7b, 0xac, 0xb2, 0xdf, 0x33, 0x16, 0x96, 0xe9, 0x39, 0xe4, 0x6c, 0x51, 0x8d, 0x80],
            [0xc8, 0x14, 0xe2, 0x04, 0x76, 0xa9, 0xfb, 0x8a, 0x50, 0x25, 0xc0, 0x2d, 0x59, 0xc5, 0x82, 0x39],
            [0xde, 0x13, 0x69, 0x67, 0x6c, 0xcc, 0x5a, 0x71, 0xfa, 0x25, 0x63, 0x95, 0x96, 0x74, 0xee, 0x15],
            [0x58, 0x86, 0xca, 0x5d, 0x2e, 0x2f, 0x31, 0xd7, 0x7e, 0x0a, 0xf1, 0xfa, 0x27, 0xcf, 0x73, 0xc3],
            [0x74, 0x9c, 0x47, 0xab, 0x18, 0x50, 0x1d, 0xda, 0xe2, 0x75, 0x7e, 0x4f, 0x74, 0x01, 0x90, 0x5a],
            [0xca, 0xfa, 0xaa, 0xe3, 0xe4, 0xd5, 0x9b, 0x34, 0x9a, 0xdf, 0x6a, 0xce, 0xbd, 0x10, 0x19, 0x0d],
            [0xfe, 0x48, 0x90, 0xd1, 0xe6, 0x18, 0x8d, 0x0b, 0x04, 0x6d, 0xf3, 0x44, 0x70, 0x6c, 0x63, 0x1e]
        ]
        let expectedKeyExpHistory: [KeyExpansionRound] = [
            KeyExpansionRound(
                index: 8,
                temp: [0x09, 0x14, 0xdf, 0xf4],
                afterRotWord: [0x14, 0xdf, 0xf4, 0x09],
                afterSubWord: [0xfa, 0x9e, 0xbf, 0x01],
                rcon: [0x01, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xfb, 0x9e, 0xbf, 0x01],
                wIMinusNK: [0x60, 0x3d, 0xeb, 0x10],
                result: [0x9b, 0xa3, 0x54, 0x11]
            ),
            KeyExpansionRound(
                index: 9,
                temp: [0x9b, 0xa3, 0x54, 0x11],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x15, 0xca, 0x71, 0xbe],
                result: [0x8e, 0x69, 0x25, 0xaf]
            ),
            KeyExpansionRound(
                index: 10,
                temp: [0x8e, 0x69, 0x25, 0xaf],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x2b, 0x73, 0xae, 0xf0],
                result: [0xa5, 0x1a, 0x8b, 0x5f]
            ),
            KeyExpansionRound(
                index: 11,
                temp: [0xa5, 0x1a, 0x8b, 0x5f],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x85, 0x7d, 0x77, 0x81],
                result: [0x20, 0x67, 0xfc, 0xde]
            ),
            KeyExpansionRound(
                index: 12,
                temp: [0x20, 0x67, 0xfc, 0xde],
                afterRotWord: [],
                afterSubWord: [0xb7, 0x85, 0xb0, 0x1d],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x1f, 0x35, 0x2c, 0x07],
                result: [0xa8, 0xb0, 0x9c, 0x1a]
            ),
            KeyExpansionRound(
                index: 13,
                temp: [0xa8, 0xb0, 0x9c, 0x1a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x3b, 0x61, 0x08, 0xd7],
                result: [0x93, 0xd1, 0x94, 0xcd]
            ),
            KeyExpansionRound(
                index: 14,
                temp: [0x93, 0xd1, 0x94, 0xcd],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x2d, 0x98, 0x10, 0xa3],
                result: [0xbe, 0x49, 0x84, 0x6e]
            ),
            KeyExpansionRound(
                index: 15,
                temp: [0xbe, 0x49, 0x84, 0x6e],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x09, 0x14, 0xdf, 0xf4],
                result: [0xb7, 0x5d, 0x5b, 0x9a]
            ),
            KeyExpansionRound(
                index: 16,
                temp: [0xb7, 0x5d, 0x5b, 0x9a],
                afterRotWord: [0x5d, 0x5b, 0x9a, 0xb7],
                afterSubWord: [0x4c, 0x39, 0xb8, 0xa9],
                rcon: [0x02, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x4e, 0x39, 0xb8, 0xa9],
                wIMinusNK: [0x9b, 0xa3, 0x54, 0x11],
                result: [0xd5, 0x9a, 0xec, 0xb8]
            ),
            KeyExpansionRound(
                index: 17,
                temp: [0xd5, 0x9a, 0xec, 0xb8],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x8e, 0x69, 0x25, 0xaf],
                result: [0x5b, 0xf3, 0xc9, 0x17]
            ),
            KeyExpansionRound(
                index: 18,
                temp: [0x5b, 0xf3, 0xc9, 0x17],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xa5, 0x1a, 0x8b, 0x5f],
                result: [0xfe, 0xe9, 0x42, 0x48]
            ),
            KeyExpansionRound(
                index: 19,
                temp: [0xfe, 0xe9, 0x42, 0x48],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x20, 0x67, 0xfc, 0xde],
                result: [0xde, 0x8e, 0xbe, 0x96]
            ),
            KeyExpansionRound(
                index: 20,
                temp: [0xde, 0x8e, 0xbe, 0x96],
                afterRotWord: [],
                afterSubWord: [0x1d, 0x19, 0xae, 0x90],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xa8, 0xb0, 0x9c, 0x1a],
                result: [0xb5, 0xa9, 0x32, 0x8a]
            ),
            KeyExpansionRound(
                index: 21,
                temp: [0xb5, 0xa9, 0x32, 0x8a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x93, 0xd1, 0x94, 0xcd],
                result: [0x26, 0x78, 0xa6, 0x47]
            ),
            KeyExpansionRound(
                index: 22,
                temp: [0x26, 0x78, 0xa6, 0x47],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xbe, 0x49, 0x84, 0x6e],
                result: [0x98, 0x31, 0x22, 0x29]
            ),
            KeyExpansionRound(
                index: 23,
                temp: [0x98, 0x31, 0x22, 0x29],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xb7, 0x5d, 0x5b, 0x9a],
                result: [0x2f, 0x6c, 0x79, 0xb3]
            ),
            KeyExpansionRound(
                index: 24,
                temp: [0x2f, 0x6c, 0x79, 0xb3],
                afterRotWord: [0x6c, 0x79, 0xb3, 0x2f],
                afterSubWord: [0x50, 0xb6, 0x6d, 0x15],
                rcon: [0x04, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x54, 0xb6, 0x6d, 0x15],
                wIMinusNK: [0xd5, 0x9a, 0xec, 0xb8],
                result: [0x81, 0x2c, 0x81, 0xad]
            ),
            KeyExpansionRound(
                index: 25,
                temp: [0x81, 0x2c, 0x81, 0xad],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x5b, 0xf3, 0xc9, 0x17],
                result: [0xda, 0xdf, 0x48, 0xba]
            ),
            KeyExpansionRound(
                index: 26,
                temp: [0xda, 0xdf, 0x48, 0xba],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xfe, 0xe9, 0x42, 0x48],
                result: [0x24, 0x36, 0x0a, 0xf2]
            ),
            KeyExpansionRound(
                index: 27,
                temp: [0x24, 0x36, 0x0a, 0xf2],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xde, 0x8e, 0xbe, 0x96],
                result: [0xfa, 0xb8, 0xb4, 0x64]
            ),
            KeyExpansionRound(
                index: 28,
                temp: [0xfa, 0xb8, 0xb4, 0x64],
                afterRotWord: [],
                afterSubWord: [0x2d, 0x6c, 0x8d, 0x43],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xb5, 0xa9, 0x32, 0x8a],
                result: [0x98, 0xc5, 0xbf, 0xc9]
            ),
            KeyExpansionRound(
                index: 29,
                temp: [0x98, 0xc5, 0xbf, 0xc9],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x26, 0x78, 0xa6, 0x47],
                result: [0xbe, 0xbd, 0x19, 0x8e]
            ),
            KeyExpansionRound(
                index: 30,
                temp: [0xbe, 0xbd, 0x19, 0x8e],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x98, 0x31, 0x22, 0x29],
                result: [0x26, 0x8c, 0x3b, 0xa7]
            ),
            KeyExpansionRound(
                index: 31,
                temp: [0x26, 0x8c, 0x3b, 0xa7],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x2f, 0x6c, 0x79, 0xb3],
                result: [0x09, 0xe0, 0x42, 0x14]
            ),
            KeyExpansionRound(
                index: 32,
                temp: [0x09, 0xe0, 0x42, 0x14],
                afterRotWord: [0xe0, 0x42, 0x14, 0x09],
                afterSubWord: [0xe1, 0x2c, 0xfa, 0x01],
                rcon: [0x08, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xe9, 0x2c, 0xfa, 0x01],
                wIMinusNK: [0x81, 0x2c, 0x81, 0xad],
                result: [0x68, 0x00, 0x7b, 0xac]
            ),
            KeyExpansionRound(
                index: 33,
                temp: [0x68, 0x00, 0x7b, 0xac],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xda, 0xdf, 0x48, 0xba],
                result: [0xb2, 0xdf, 0x33, 0x16]
            ),
            KeyExpansionRound(
                index: 34,
                temp: [0xb2, 0xdf, 0x33, 0x16],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x24, 0x36, 0x0a, 0xf2],
                result: [0x96, 0xe9, 0x39, 0xe4]
            ),
            KeyExpansionRound(
                index: 35,
                temp: [0x96, 0xe9, 0x39, 0xe4],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xfa, 0xb8, 0xb4, 0x64],
                result: [0x6c, 0x51, 0x8d, 0x80]
            ),
            KeyExpansionRound(
                index: 36,
                temp: [0x6c, 0x51, 0x8d, 0x80],
                afterRotWord: [],
                afterSubWord: [0x50, 0xd1, 0x5d, 0xcd],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x98, 0xc5, 0xbf, 0xc9],
                result: [0xc8, 0x14, 0xe2, 0x04]
            ),
            KeyExpansionRound(
                index: 37,
                temp: [0xc8, 0x14, 0xe2, 0x04],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xbe, 0xbd, 0x19, 0x8e],
                result: [0x76, 0xa9, 0xfb, 0x8a]
            ),
            KeyExpansionRound(
                index: 38,
                temp: [0x76, 0xa9, 0xfb, 0x8a],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x26, 0x8c, 0x3b, 0xa7],
                result: [0x50, 0x25, 0xc0, 0x2d]
            ),
            KeyExpansionRound(
                index: 39,
                temp: [0x50, 0x25, 0xc0, 0x2d],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x09, 0xe0, 0x42, 0x14],
                result: [0x59, 0xc5, 0x82, 0x39]
            ),
            KeyExpansionRound(
                index: 40,
                temp: [0x59, 0xc5, 0x82, 0x39],
                afterRotWord: [0xc5, 0x82, 0x39, 0x59],
                afterSubWord: [0xa6, 0x13, 0x12, 0xcb],
                rcon: [0x10, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xb6, 0x13, 0x12, 0xcb],
                wIMinusNK: [0x68, 0x00, 0x7b, 0xac],
                result: [0xde, 0x13, 0x69, 0x67]
            ),
            KeyExpansionRound(
                index: 41,
                temp: [0xde, 0x13, 0x69, 0x67],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xb2, 0xdf, 0x33, 0x16],
                result: [0x6c, 0xcc, 0x5a, 0x71]
            ),
            KeyExpansionRound(
                index: 42,
                temp: [0x6c, 0xcc, 0x5a, 0x71],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x96, 0xe9, 0x39, 0xe4],
                result: [0xfa, 0x25, 0x63, 0x95]
            ),
            KeyExpansionRound(
                index: 43,
                temp: [0xfa, 0x25, 0x63, 0x95],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x6c, 0x51, 0x8d, 0x80],
                result: [0x96, 0x74, 0xee, 0x15]
            ),
            KeyExpansionRound(
                index: 44,
                temp: [0x96, 0x74, 0xee, 0x15],
                afterRotWord: [],
                afterSubWord: [0x90, 0x92, 0x28, 0x59],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xc8, 0x14, 0xe2, 0x04],
                result: [0x58, 0x86, 0xca, 0x5d]
            ),
            KeyExpansionRound(
                index: 45,
                temp: [0x58, 0x86, 0xca, 0x5d],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x76, 0xa9, 0xfb, 0x8a],
                result: [0x2e, 0x2f, 0x31, 0xd7]
            ),
            KeyExpansionRound(
                index: 46,
                temp: [0x2e, 0x2f, 0x31, 0xd7],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x50, 0x25, 0xc0, 0x2d],
                result: [0x7e, 0x0a, 0xf1, 0xfa]
            ),
            KeyExpansionRound(
                index: 47,
                temp: [0x7e, 0x0a, 0xf1, 0xfa],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x59, 0xc5, 0x82, 0x39],
                result: [0x27, 0xcf, 0x73, 0xc3]
            ),
            KeyExpansionRound(
                index: 48,
                temp: [0x27, 0xcf, 0x73, 0xc3],
                afterRotWord: [0xcf, 0x73, 0xc3, 0x27],
                afterSubWord: [0x8a, 0x8f, 0x2e, 0xcc],
                rcon: [0x20, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0xaa, 0x8f, 0x2e, 0xcc],
                wIMinusNK: [0xde, 0x13, 0x69, 0x67],
                result: [0x74, 0x9c, 0x47, 0xab]
            ),
            KeyExpansionRound(
                index: 49,
                temp: [0x74, 0x9c, 0x47, 0xab],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x6c, 0xcc, 0x5a, 0x71],
                result: [0x18, 0x50, 0x1d, 0xda]
            ),
            KeyExpansionRound(
                index: 50,
                temp: [0x18, 0x50, 0x1d, 0xda],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xfa, 0x25, 0x63, 0x95],
                result: [0xe2, 0x75, 0x7e, 0x4f]
            ),
            KeyExpansionRound(
                index: 51,
                temp: [0xe2, 0x75, 0x7e, 0x4f],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x96, 0x74, 0xee, 0x15],
                result: [0x74, 0x01, 0x90, 0x5a]
            ),
            KeyExpansionRound(
                index: 52,
                temp: [0x74, 0x01, 0x90, 0x5a],
                afterRotWord: [],
                afterSubWord: [0x92, 0x7c, 0x60, 0xbe],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x58, 0x86, 0xca, 0x5d],
                result: [0xca, 0xfa, 0xaa, 0xe3]
            ),
            KeyExpansionRound(
                index: 53,
                temp: [0xca, 0xfa, 0xaa, 0xe3],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x2e, 0x2f, 0x31, 0xd7],
                result: [0xe4, 0xd5, 0x9b, 0x34]
            ),
            KeyExpansionRound(
                index: 54,
                temp: [0xe4, 0xd5, 0x9b, 0x34],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x7e, 0x0a, 0xf1, 0xfa],
                result: [0x9a, 0xdf, 0x6a, 0xce]
            ),
            KeyExpansionRound(
                index: 55,
                temp: [0x9a, 0xdf, 0x6a, 0xce],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x27, 0xcf, 0x73, 0xc3],
                result: [0xbd, 0x10, 0x19, 0x0d]
            ),
            KeyExpansionRound(
                index: 56,
                temp: [0xbd, 0x10, 0x19, 0x0d],
                afterRotWord: [0x10, 0x19, 0x0d, 0xbd],
                afterSubWord: [0xca, 0xd4, 0xd7, 0x7a],
                rcon: [0x40, 0x00, 0x00, 0x00],
                afterXORWithRCON: [0x8a, 0xd4, 0xd7, 0x7a],
                wIMinusNK: [0x74, 0x9c, 0x47, 0xab],
                result: [0xfe, 0x48, 0x90, 0xd1]
            ),
            KeyExpansionRound(
                index: 57,
                temp: [0xfe, 0x48, 0x90, 0xd1],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x18, 0x50, 0x1d, 0xda],
                result: [0xe6, 0x18, 0x8d, 0x0b]
            ),
            KeyExpansionRound(
                index: 58,
                temp: [0xe6, 0x18, 0x8d, 0x0b],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0xe2, 0x75, 0x7e, 0x4f],
                result: [0x04, 0x6d, 0xf3, 0x44]
            ),
            KeyExpansionRound(
                index: 59,
                temp: [0x04, 0x6d, 0xf3, 0x44],
                afterRotWord: [],
                afterSubWord: [],
                rcon: [],
                afterXORWithRCON: [],
                wIMinusNK: [0x74, 0x01, 0x90, 0x5a],
                result: [0x70, 0x6c, 0x63, 0x1e]
            )
        ]
        
        
        keySched.keyExpansion(key: key)
        XCTAssertEqual(keySched.getNrOfRounds,
                       14,
                       "Wrong number of rounds: Expected 14 but got \(keySched.getNrOfRounds)")
        
        XCTAssertEqual(keySched.getNk,
                       8,
                       "Wrong number of key size: Expected 8 but got \(keySched.getNk)")
        
        let keySize = AESConfiguration(rawValue: 8)!
        XCTAssertEqual(keySched.getKeySize,
                       keySize,
                       "Wrong key size: Expected \(keySize) but got \(String(describing: keySched.getKeySize))")

        let actualRoundKeys = keySched.getRoundKeys
        for (index, expectedKey) in expectedRoundKeys.enumerated() {
            let actualKey = actualRoundKeys[index]
            XCTAssertEqual(actualKey, expectedKey, "KeyExpansion failed: Round key at index \(index) does not match expected value.")
        }
        
        let actualKeySchedule = keySched.getDetailedKeySchedule
        for (index, expectedRound) in expectedKeyExpHistory.enumerated() {
            let actualRound = actualKeySchedule[index]
            
            XCTAssertEqual(actualRound.index, expectedRound.index, "Round \(index): Index does not match.")
            XCTAssertEqual(actualRound.temp, expectedRound.temp, "Round \(index): Temp value does not match.")
            XCTAssertEqual(actualRound.afterRotWord, expectedRound.afterRotWord, "Round \(index): After RotWord does not match.")
            XCTAssertEqual(actualRound.afterSubWord, expectedRound.afterSubWord, "Round \(index): After SubWord does not match.")
            XCTAssertEqual(actualRound.rcon, expectedRound.rcon, "Round \(index): RCON does not match.")
            XCTAssertEqual(actualRound.afterXORWithRCON, expectedRound.afterXORWithRCON, "Round \(index): After XOR with RCON does not match.")
            XCTAssertEqual(actualRound.wIMinusNK, expectedRound.wIMinusNK, "Round \(index): w[i - Nk] does not match.")
            XCTAssertEqual(actualRound.result, expectedRound.result, "Round \(index): Result does not match.")
        }

    }
}
