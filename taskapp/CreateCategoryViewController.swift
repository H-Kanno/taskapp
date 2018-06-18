//
//  CreateCategoryViewController.swift
//  taskapp
//
//  Created by 菅野 英俊 on 2018/06/17.
//  Copyright © 2018年 菅野 英俊. All rights reserved.
//

import UIKit
import RealmSwift

class CreateCategoryViewController: UIViewController {

    // Storyboard変数
    @IBOutlet weak var categoryName01: UITextField!
    

    // その他の変数
    let category = Category()
    let realm = try! Realm()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        let allCategory = realm.objects(Category.self)
        
        try! realm.write {
            // 書き込む値の準備
            self.category.category = categoryName01.text!
            if allCategory.count != 0 {
                self.category.id = allCategory.max(ofProperty: "id")! + 1
            }
            
            // テーブルへ書き込み
            self.realm.add(self.category, update: true)
        }
    }
  
    
    
}












