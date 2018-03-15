//
//  WelcomeViewController.swift
//  Realm_iOSToDo
//
//  Created by Nam-Anh Vu on 3/15/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Wellcome"
        
        if let currentUser = SyncUser.current {
            // We have already logged in
            self.navigationController?.pushViewController(ItemsViewController(), animated: true)
        } else {
            
            let alertController = UIAlertController(title: "Log into Realm Cloud", message: "Give us a nice nickname!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self] alert -> Void in
                
                let textField = alertController.textFields![0] as UITextField
                let credentials = SyncCredentials.usernamePassword(username: "nugee", password: "nugee", register: true)
                
                SyncUser.logIn(with: credentials, server: Constants.AUTH_URL, onCompletion: { [weak self] (user, error) in
                    
                    if let theUser = user {
                        self?.navigationController?.pushViewController(ItemsViewController(), animated: true)
                    } else if let error = error {
                        fatalError(error.localizedDescription)
                    }
                })
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: { (textField = UITextField!) -> Void in
                textField.placeholder = "A name for your user"
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
