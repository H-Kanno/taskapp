//
//  InputViewController.swift
//  taskapp
//
//  Created by 菅野 英俊 on 2018/06/05.
//  Copyright © 2018年 菅野 英俊. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // storyboard変数
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    // その他変数
    var task: Task!
    var category: Category!
    let realm = try! Realm()
    var tmpCategory: Int!
    
    
    // テーブルの読み込み
    var allCategory = try! Realm().objects(Category.self).sorted(byKeyPath: "id")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        // デリゲート設定
        titleTextField.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // キーボードの「完了」が押された際にキーボードを閉じる。
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text!
            self.task.date = self.datePicker.date
            if allCategory.count != 0 {
                self.task.categoryId = allCategory[tmpCategory].id
            }
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        categoryPicker.reloadAllComponents()
        
        super.viewWillAppear(animated)
    }
    
    
    
    
    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }


    
    
    
    
    // UIPickerViewの列数設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数設定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCategory.count
    }
    
    // UIPickerViewの要素設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        tmpCategory = row
        return allCategory[row].category
    }
    
    
    
    
    // 遷移先から戻ってくるときの処理
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
    
    
    
}
