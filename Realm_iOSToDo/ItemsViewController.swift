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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Create a sync Realm and connect to the Realm Cloud account
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[Item.self]))
        
        // Create a query to return a list of items
        self.items = realm.objects(Item.self).sorted(byKeyPath: "timestamp", ascending: false)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        
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
