//
//  AddTag_TableViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/11/11.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB
import PKHUD


class AddTag_TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let ud = UserDefaults.standard
    
    @IBOutlet var tagsTableView: UITableView!
    
    var tagsList = [NCMBObject]()
    
    var selectedTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsTableView.dataSource = self
        tagsTableView.delegate = self
        
        tagsTableView.tableFooterView = UIView()
        
        // 複数選択可にする
        tagsTableView.allowsMultipleSelection = true
         //udが空の時のクラッシュ回避
        if ud.array(forKey: "selectedTags") == nil {
            ud.set([], forKey: "selectedTags")
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadTagList()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //チェックマーク表示をキープ
//        var tagObject = tagsList[indexPath.row].object(forKey: "tagName") as! String
//        var selectedTagList = ud.array(forKey:  "selectedTags") as![String]
//        if selectedTagList.contains(tagObject)  == true {
//            cell?.accessoryType = .checkmark
//
//        } else {
//            cell?.accessoryType = .none
//        }
            
        
        print(tagsList)
        
        cell?.textLabel?.text = tagsList[indexPath.row].object(forKey: "tagName") as! String
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タッチしたセルの値をpostViewControllerのselectedtags配列に値渡し
        //        let preNC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! PostViewController
        //        preNC.selectedTag = self.tagsList[indexPath.row]
        // チェックマークを表示
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        print(cell?.accessoryType)
        
//         selectedTagsにtaglistを追加して、udに"selectedtags"で登録する
        let ud = UserDefaults.standard
        selectedTags.append(tagsList[indexPath.row].object(forKey: "tagName") as! String)
        ud.set(selectedTags, forKey: "selectedTags")
       

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
//                userDefaultsからデータを取り出す
        //        String型の配列にダウンキャストする
        selectedTags = ud.array(forKey:  "selectedTags") as![String]
        //selectedTagにセルをタッチして追加されたタグと、tagsList[indexPath.row].object(forKey: "tagName")が一致したものを削除して、udに再代入
        for i in 0...tagsList.count {
            if selectedTags[i] == tagsList[indexPath.row].object(forKey: "tagName")as! String {
               selectedTags.remove(at: i)
                
                // for分から抜ける
                break
                
            }
        }
        ud.set(selectedTags, forKey: "selectedTags")
        
    
        
        
        
        
    
}
// セルをタッチしてスワイプできる
func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
    
}
//　スワイプしたセルを削除
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
        tagsList[indexPath.row].deleteInBackground { (error) in
            if error != nil {
                print(error)
            } else {
                self.loadTagList()
            }
            
            
            
            
        }
    }
    
    
    
}

func loadTagList() {
    let query = NCMBQuery(className: "Tag")
    query?.whereKey("user", equalTo: NCMBUser.current())
    
    query?.findObjectsInBackground({ (result, error) in
        if error != nil {
            print(error)
        } else {
            self.tagsList = result as! [NCMBObject]
            self.tagsTableView.reloadData()
            PKHUD.sharedHUD.hide()
            
        }
    })
}

@IBAction func AddTags() {
    
    
    var alertTextField: UITextField?
    
    let alert = UIAlertController(
        title: "Edit Name",
        message: "Enter new name",
        preferredStyle: UIAlertController.Style.alert)
    alert.addTextField(
        configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            
            textField.placeholder = "新しいタグ"
            
    })
    alert.addAction(
        UIAlertAction(
            title: "Cancel",
            style: UIAlertAction.Style.cancel,
            handler: nil))
    alert.addAction(
        UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    let object = NCMBObject(className: "Tag")
                    object?.setObject(NCMBUser.current(), forKey: "user")
                    object?.setObject(text, forKey: "tagName")
                    object?.saveInBackground({ (error) in
                        if error != nil {
                            print(error)
                        } else {
                            self.loadTagList()
                        }
                    })
                }
        }
    )
    
    self.present(alert, animated: true, completion: nil)
}
}




