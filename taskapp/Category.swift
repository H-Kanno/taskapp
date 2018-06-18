//
//  Category.swift
//  taskapp
//
//  Created by 菅野 英俊 on 2018/06/17.
//  Copyright © 2018年 菅野 英俊. All rights reserved.
//

import RealmSwift

class Category: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // カテゴリー
    @objc dynamic var category = ""

    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
