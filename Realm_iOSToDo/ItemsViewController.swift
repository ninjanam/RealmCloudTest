//
//  ItemsViewController.swift
//  Realm_iOSToDo
//
//  Created by Nam-Anh Vu on 3/15/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsViewController: UIViewController {

    let realm : Realm
    let items : Results<Item>
    
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Create a sync Realm and connect to the Realm Cloud account
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[Item.self]))
        
        // Create a query to return a list of items
        self.items = realm.objects(Item.self).sorted(byKeyPath: "timestamp", ascending: false)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        
        title = "To Do Item"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        
        // See description below about this closure
        notificationToken = items.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
                
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
            
            case .error(let error):
                // An error occurred while opening the REalm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    @objc func addButtonDidClick() {
        
        let alertController = UIAlertController(title: "Add Item", message: "Set your to-do, please", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            let item = Item()
            item.body = textField.text ?? ""
            try! self.realm.write {
                self.realm.add(item)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "New Item text"
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func rightBarButtonDidClick() {
        
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes, logout", style: .destructive, handler: { alert -> Void in
            SyncUser.current?.logOut()
            
            self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // nil coalescing operator for optionals. If <bit before ?? isn't nil>, set cell to that, otherwise set cell to default
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.textLabel?.text = item.body
        // if item has isDone value, set checkmark, otherwise, no checkmark
        cell.accessoryType = item.isDone ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        try! realm.write {
            item.isDone = !item.isDone
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
}



/* In this method the changes object is filled with fine-grained notifications about which Items were changed, including the indexes of insertions, deletions, modifications, etc.
 
 We can use this fine-grained change information to tell our UITableView instance which rows to change with the beginUpdates and endUpdates methods. Now any modifications to the Item objects will trigger animations appropriately.
 
 We've stored the return value of observe into the notificationToken . So long as the notificationToken exists -- which will be whenever the ItemsViewController is on-screen -- then the observe handler will consistently be called.
 
 If our view controller ever goes off screen (for example if we had other views in our application), we would want to deallocate this notification handler. The deinit for the UIViewController is a convenient place to add notificationToken?.invalidate() method which cleans up this observer for us. Add the following deinit method following after the init methods near the top of the file:
 
 deinit {
 notificationToken?.invalidate()
 }
 */










