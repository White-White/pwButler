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
    fileprivate var pwItemBundle: PasswordItemBundle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        pwItemBundle = PasswordItemBundle.init(allPasswordItems: TestCase.shared.randomItems())
        pwItemBundle = PasswordItemBundle.init(allPasswordItems: FMDBManager.shared.extractAllItems())
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
    
    @objc func addItem() {
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
            let idxPath = self.pwItemBundle.insert(newItem)
            self.tableView.insertRows(at: [idxPath], with: .automatic)
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
        
        let item =  pwItemBundle.itemsAt(bracketIndex: indexPath.section)[indexPath.row]
        self.navigationController?.pushViewController(ItemDetailController.init(withItem: item), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pwItemBundle.itemsAt(bracketIndex: section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pwItemBundle.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PasswordItemCell.cellID(), for: indexPath) as! PasswordItemCell
        let item =  pwItemBundle.itemsAt(bracketIndex: indexPath.section)[indexPath.row]
        cell.textLabel?.text = item.hostName
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return pwItemBundle.allIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = pwItemBundle.indexTitle(atIndex: section)
        label.sizeToFit()
        label.textColor = UIColor.red
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
}
