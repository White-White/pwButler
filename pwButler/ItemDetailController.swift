//
//  ItemDetailController.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailController: UIViewController {

    private var hostNameLabel: UILabel!
    private var accountNameLabel: UILabel!
    private var passwordLabel: UILabel!
    
    let item: PasswordItem
    
    init(withItem item: PasswordItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostNameLabel = UILabel()
        hostNameLabel.text = item.hostName
        self.view.addSubview(hostNameLabel)
        
        accountNameLabel = UILabel()
        accountNameLabel.text = item.accountName
        self.view.addSubview(accountNameLabel)
        
        passwordLabel = UILabel()
        passwordLabel.text = item.password
        self.view.addSubview(passwordLabel)
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hostNameLabel.sizeToFit()
        hostNameLabel.frame.origin = CGPoint(x: 50, y: 150)
        
        accountNameLabel.sizeToFit()
        accountNameLabel.frame.origin = CGPoint(x: hostNameLabel.frame.origin.x, y: hostNameLabel.frame.origin.y + 100)
        
        passwordLabel.sizeToFit()
        passwordLabel.frame.origin = CGPoint(x: accountNameLabel.frame.origin.x, y: accountNameLabel.frame.origin.y + 100)
    }
}
