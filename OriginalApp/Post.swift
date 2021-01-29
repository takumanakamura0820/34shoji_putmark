//
//  Post.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/15.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit

class Post: NSObject {
    var objectId: String
    var user: User
    var imageUrl: String
    var text: String
    var createDate: Date
    var isLiked: Bool?
    var comments: [Comment]?
    var likeCount: Int = 0
    
    // 初期化
    init(objectId: String, user: User, imageUrl: String, text: String, createDate: Date) {
        self.objectId = objectId
        self.user = user
        self.imageUrl = imageUrl
        self.text = text
        self.createDate = createDate
        
    }

}
