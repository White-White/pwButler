//
//  Model.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation

//enum Hosts: String {
//    
//}

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
}
