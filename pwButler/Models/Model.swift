//
//  Model.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation

/*
 ASCII
 A = 0x41
 Z = 0x5a
 a = 0x61
 z = 0x7a
 */

struct PasswordItem {
    var id: Int?
    let hostName: String
    let accountName: String
    let password: String
    
    init(withHostName hostName:String, accountName: String, password: String, id: Int?) {
        self.id = id
        self.hostName = hostName
        self.accountName = accountName
        self.password = password
    }
    
    func indexTitleForHostName() -> String? {
        guard let firstUnicodeValue = self.hostName.unicodeScalars.first?.value else { return nil }
        if (firstUnicodeValue <= 0x7a && firstUnicodeValue >= 0x61) || (firstUnicodeValue <= 0x5a && firstUnicodeValue >= 0x41) {
            return String(UnicodeScalar(firstUnicodeValue)!)
        } else if firstUnicodeValue <= 0x9fa5 && firstUnicodeValue >= 0x4e00 { //汉字 [0x4e00,0x9fa5]
            //转成了可变字符串
            let mutableStr = NSMutableString(string: String(UnicodeScalar(firstUnicodeValue)!))
            //先转换为带声调的拼音
            CFStringTransform(mutableStr as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
            //再转换为不带声调的拼音
            CFStringTransform(mutableStr as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
            //转化为大写拼音
            return mutableStr.capitalized
        } else {
            return nil
        }
    }
}

struct PasswordItemBundle {
    
    private struct Bracket {
        let indexTitle: String
        var items: [PasswordItem] = []
        
        init(indexTitle: String) {
            self.indexTitle = indexTitle
        }
        
        mutating func insert(_ item: PasswordItem) -> Int {
            //TODO: 目前在同一字母下，直接插入到数组头，所以顺序是乱的
            self.items.insert(item, at: 0)
            return 0
        }
    }
    
    //Private
    private var allBrackets: [Bracket] = []
    
    //Public
    var numberOfSections: Int { return allBrackets.count }
    var allIndexTitles: [String] { return allBrackets.map { return $0.indexTitle } }
    
    func itemsAt(bracketIndex: Int) -> [PasswordItem] {
        return allBrackets[bracketIndex].items
    }
    
    func indexTitle(atIndex index: Int) -> String {
        return allBrackets[index].indexTitle
    }
    
    init(allPasswordItems allItems: [PasswordItem]) {

        var tmpBrackets: [Bracket] = []
        
        //A...Z
        for cchar in 65...90 {
            let bracket = Bracket(indexTitle: String.init(format: "%c", cchar))
            tmpBrackets.append(bracket)
        }
        
        //最后一个
        let bracketLast = Bracket(indexTitle: "*")
        tmpBrackets.append(bracketLast)
        
        for pwItem in allItems {
            let insertIndex = indexToInsertFor(pwItem.indexTitleForHostName())
            _ = tmpBrackets[insertIndex].insert(pwItem)
        }

        self.allBrackets = tmpBrackets
    }
    
    
    /// 根据字符串，返回该tile属于哪一个bracket
    private func indexToInsertFor(_ title: String?) -> Int {
        if let cchar = title?.cString(using: .utf8)?.first {
            let index = UInt8(bitPattern: cchar)
            if index <= 0x5a && index >= 0x41 {
                return Int(index) - 0x41
            } else if index <= 0x7a && index >= 0x61 {
                return Int(index) - 0x61
            } else {
                fatalError()
            }
        } else {
            return 26
        }
    }
    
    //增
    mutating func insert(_ item: PasswordItem) -> IndexPath {
        //增加到数据库
        FMDBManager.shared.add(passwordItems: [item])
        
        //增加到UI
        let bracketSection = indexToInsertFor(item.indexTitleForHostName())
        let bracketRow = allBrackets[bracketSection].insert(item)
        return IndexPath(row: bracketRow, section: bracketSection)
    }
    
    //删
    func delete(atSectionIndex sectionIndex: Int, rowIndex: Int) {
        
    }
    
    //改
}








