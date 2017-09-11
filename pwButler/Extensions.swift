//
//  Extensions.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation

extension String {
    func sqliteEscape() -> String { return self.replacingOccurrences(of: "'", with: "''") }
    func antiSqliteEscape() -> String { return self.replacingOccurrences(of: "''", with: "'") }
}
