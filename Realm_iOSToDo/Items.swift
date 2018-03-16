//
//  Items.swift
//  Realm_iOSToDo
//
//  Created by Nam-Anh Vu on 3/15/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var itemID: String = UUID().uuidString
    @objc dynamic var body: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var timestamp: Date = Date()
    
    override static func primaryKey() -> String? {
        return "itemID"
    }
    
}
