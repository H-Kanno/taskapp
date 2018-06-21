//
//  CreateCategoryViewController.swift
//  taskapp
//
//  Created by 菅野 英俊 on 2018/06/17.
//  Copyright © 2018年 菅野 英俊. All rights reserved.
//

import UIKit
import RealmSwift

class CreateCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Storyboard変数
    @IBOutlet weak var categoryName01: UITextField!
    @IBOutlet weak var tableView01: UITableView!
    
    
    // その他の変数
    let category = Category()
    let realm = try! Realm()
    let allCategory = try! Realm().objects(Category.self)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView01.delegate = self
        tableView01.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if categoryName01.text != "" {
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
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_2", for: indexPath)
        
        let category = allCategory[indexPath.row]
        cell.textLabel?.text = category.category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                self.realm.delete(self.allCategory[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    
    
    
}












