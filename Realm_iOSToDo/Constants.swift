//
//  Constants.swift
//  Realm_iOSToDo
//
//  Created by Nam-Anh Vu on 3/15/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import Foundation

struct Constants {

//    static let MY_INSTANCE_ADDRESS =  "realm-test-nav.us1a.cloud.realm.io"
    static let MY_INSTANCE_ADDRESS = "tentwelve.us1a.cloud.realm.io"
    
    static let AUTH_URL = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/iOSToDo")!
    
}
