//
//  FMDBManager.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation
import FMDB

class FMDBManager {
    static let shared = FMDBManager()
    
    private var dbQueue: FMDatabaseQueue
    private var pwTableName = "passwords"
    
    private init() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbName = "pw.db"
        dbQueue = FMDatabaseQueue.init(path: docPath + "/" + dbName)
        
        dbQueue.inDatabase { (db) in
            do {
                try db.executeUpdate("create table if not exists \(pwTableName)(" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                    "hostName TEXT NOT NULL," +
                    "accountName TEXT NOT NULL," +
                    "password TEXT NOT NULL" +
                ")", values: nil)
            } catch {
                fatalError()
            }
        }
        
        print("dbPath: \(docPath)")
    }
    
    //增
    func add(passwordItems: [PasswordItem]) {
        let tmpString = "INSERT INTO \(pwTableName) VALUES (null, '%@', '%@', '%@')"
        dbQueue.inDatabase { (db) in
            do {
                if db.beginTransaction() {
                    for passwordItem in passwordItems {
                        let insertString = String(format: tmpString,
                                                  passwordItem.hostName.sqliteEscape(),
                                                  passwordItem.accountName.sqliteEscape(),
                                                  passwordItem.password.sqliteEscape())
                        try db.executeUpdate(insertString, values: nil)
                    }
                } else {
                    fatalError()
                }
                db.commit()
            } catch {
                fatalError()
            }
        }
    }
    
    //删
    func delete(passwordItem: PasswordItem) {
        guard let itemID = passwordItem.id else { fatalError() }
        dbQueue.inDatabase { (db) in
            do {
                try db.executeUpdate("DELETE FROM \(pwTableName) WHERE id = \(itemID)", values: nil)
            } catch {
                fatalError()
            }
        }
    }
    
    //改
    func update(passwordItem: PasswordItem) {
        guard let itemID = passwordItem.id else { fatalError() }
        dbQueue.inDatabase { (db) in
            do {
                try db.executeUpdate("UPDATE \(pwTableName) SET " +
                    "accountName = \(passwordItem.accountName.sqliteEscape()), " +
                    "password = \(passwordItem.password.sqliteEscape()) WHERE id = \(itemID)", values: nil)
            } catch {
                fatalError()
            }
        }
    }
    
    //查
    func extractAllItems() -> [PasswordItem] {
        var result: [PasswordItem] = []
        
        dbQueue.inDatabase { (db) in
            do {
                let rs = try db.executeQuery("SELECT * FROM \(pwTableName)", values: nil)
                while rs.next() {
                    let item = PasswordItem.init(withHostName: rs.string(forColumnIndex: 1)!.antiSqliteEscape(),
                                                 accountName: rs.string(forColumnIndex: 2)!.antiSqliteEscape(),
                                                 password: rs.string(forColumnIndex: 3)!.antiSqliteEscape(),
                                                 id: Int(rs.int(forColumnIndex: 0)))
                    result.append(item)
                }
            } catch {
                fatalError()
            }
        }
        
        return result
    }
}












