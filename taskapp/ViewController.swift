//
//  ViewController.swift
//  taskapp
//
//  Created by 菅野 英俊 on 2018/06/05.
//  Copyright © 2018年 菅野 英俊. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // storyboard変数
    @IBOutlet weak var tableView01: UITableView!
    @IBOutlet weak var searchPicker01: UIPickerView!
    
    // DB内のタスクが格納されるリスト。
    let realm = try! Realm()
    let category = Category()

    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
    var allCategory = try! Realm().objects(Category.self).sorted(byKeyPath: "id")
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView01.delegate = self
        tableView01.dataSource = self
        
        searchPicker01.delegate = self
        searchPicker01.dataSource = self
        
        try! realm.write {
            self.category.id = 0
            self.category.category = ""
            self.realm.add(self.category, update: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView01.reloadData()
        searchPicker01.reloadAllComponents()
    }

    
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }


    
    // category Pickerの設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCategory.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCategory[row].category
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tmpCategoryId = allCategory[row].id
        
        if tmpCategoryId == 0 {
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
        }
        else {
            let nsPredicate01: NSPredicate = NSPredicate( format: "categoryId == \(tmpCategoryId)" )
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false).filter(nsPredicate01)
        }
        
        tableView01.reloadData()
    }
    
    
    
    // segue で画面遷移するに呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView01.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    

    // serchBarでの検索
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
            tableView01.reloadData()
        }
        else {
            let nsPredicate01: NSPredicate = NSPredicate( format: "category CONTAINS %@", searchBar.text! )
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false).filter(nsPredicate01)
            
            tableView01.reloadData()
        }
    }
    
    
    // 遷移先から戻ってくるときの処理
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
    
    
    
}










