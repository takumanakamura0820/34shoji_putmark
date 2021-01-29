//
//  User.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/15.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit

class User: NSObject {
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?
    
    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName

}

}
