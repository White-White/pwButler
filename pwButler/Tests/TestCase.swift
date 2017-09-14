//
//  TestKit.swift
//  pwButler
//
//  Created by White on 2017/9/14.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation

class TestCase {
    
    static let shared = TestCase()
    
    init() {
        #if !DEBUG
            fatalError()
        #endif
    }
    
//    func randomString() -> String {
//        
//        
//    
//    }
    
    private func randomChinese() -> String {
        let nsGBK = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        let randomH = 0xAF + UInt8(arc4random()%(0xF7 - 0xB0) + 1)
        let randomL = 0xA0 + UInt8(arc4random()%(0xFE - 0xA0) + 1)
        return String(data: Data(bytes: [randomH, randomL]), encoding: String.Encoding.init(rawValue: nsGBK))!
    }
    
    func randomItems() -> [PasswordItem] {
        return (0...100).map { _ in
            let host = PasswordItem(withHostName: self.randomChinese(),
                                    accountName: "A",
                                    password: "B", id: nil)
            return host
        }
    }
}
