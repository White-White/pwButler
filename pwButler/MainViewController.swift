//
//  MainViewController.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    private var tableView: UITableView!
    fileprivate var allPasswordItems: [PasswordItem]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        allPasswordItems = FMDBManager.shared.extractAllItems()
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        //
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PasswordItemCell.self, forCellReuseIdentifier: PasswordItemCell.cellID())
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    func addItem() {
        let alertController = UIAlertController.init(title: "Add Item", message: nil, preferredStyle: .alert)
        
        var tfHost: UITextField!
        var tfAc: UITextField!
        var tfPw: UITextField!
        
        alertController.addTextField { (tf) in
            tf.placeholder = "Host"
            tfHost = tf
        }
        
        alertController.addTextField { (tf) in
            tf.placeholder = "AccountName"
            tfAc = tf
        }
        
        alertController.addTextField { (tf) in
            tf.placeholder = "Password"
            tfPw = tf
        }
        
        let actionOK = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let newItem = PasswordItem.init(withHostName: tfHost.text!,
                                            accountName: tfAc.text!,
                                            password: tfPw.text!,
                                            id: nil)
            FMDBManager.shared.add(passwordItems: [newItem])
            self.allPasswordItems.insert(newItem, at: 0)
            self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(actionOK)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item =  allPasswordItems[indexPath.row]
        self.navigationController?.pushViewController(ItemDetailController.init(withItem: item), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPasswordItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PasswordItemCell.cellID(), for: indexPath) as! PasswordItemCell
        let item =  allPasswordItems[indexPath.row]
        cell.textLabel?.text = item.hostName
        return cell
    }
}
