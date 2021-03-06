//
//  Task.swift
//  taskapp
//
//  Created by 菅野 英俊 on 2018/06/11.
//  Copyright © 2018年 菅野 英俊. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    /// 日時
    @objc dynamic var date = Date()
   
    // カテゴリーID
    @objc dynamic var categoryId = 0
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}









