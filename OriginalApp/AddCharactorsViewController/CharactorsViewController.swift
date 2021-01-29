//
//  TagListViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/30.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB
import PKHUD

class CharactorsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let ud = UserDefaults.standard
    
    @IBOutlet var charactorsTableView: UITableView!
    
    var charactorsLists = [NCMBObject]()
    
    var selectedCharactors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactorsTableView.dataSource = self
        charactorsTableView.delegate = self
        
        charactorsTableView.tableFooterView = UIView()
        //
        //        let nib = UINib(nibName: "TagListTableViewCell", bundle: nil)
        //        tagListTableView.register(nib, forCellReuseIdentifier: "listTagCell")
        
        self.view.backgroundColor = UIColor.white
        charactorsTableView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        
        // 複数選択可にする
        charactorsTableView.allowsMultipleSelection = true
         //udが空の時のクラッシュ回避
        if ud.array(forKey: "selectedCharactors") == nil {
            ud.set([], forKey: "selectedCharactors")
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadListTag()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactorsLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTagCell")
        
        cell?.textLabel?.text = charactorsLists[indexPath.row].object(forKey: "character") as! String
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        print(cell?.accessoryType)
        
        let ud = UserDefaults.standard
        selectedCharactors.append(charactorsLists[indexPath.row].object(forKey: "character") as! String)
        ud.set(selectedCharactors, forKey: "selectedCharactors")
        
        
            
        
        
        
        
        
        
         //タッチしたセルの値をpostViewControllerのselectedCharactors配列に値渡し
//                let preNC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! PostViewController
//                preNC.selectedCharactors = self.charactorsLists[indexPath.row]
//                self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
//        userDefaultsからデータを取り出す
//        String型の配列にダウンキャストする
       selectedCharactors =  ud.array(forKey:  "selectedCharactors") as![String]
        for i in 0...selectedCharactors.count {
            if selectedCharactors[i] == charactorsLists[indexPath.row].object(forKey: "character")as! String {
                selectedCharactors.remove(at: i)
                
                // for分から抜ける
                break
                
            }
        }
          ud.set(selectedCharactors, forKey: "selectedCharactors")
        
        print(ud.array(forKey: "selectedCharactors"))
        
        
        
        
    }
    // セルをタッチスワイプ削除できる
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    
    //スワイプしたセルを削除　※arrayNameは変数名に変更してください
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            charactorsLists[indexPath.row].deleteInBackground { (error) in
                if error != nil {
                    print(error)
                } else {
                    //                    tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
                    self.loadListTag()
                }
            }
            
            
        }
    }
    
    func loadListTag() {
        let query = NCMBQuery(className: "Charactors")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                print(result)
                self.charactorsLists = result as! [NCMBObject]
                self.charactorsTableView.reloadData()
                PKHUD.sharedHUD.hide()
            }
        })
        
    }
    @IBAction func AddCharactors () {
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
                        let object = NCMBObject(className: "Charactors")
                        object?.setObject(NCMBUser.current(), forKey: "user")
                        object?.setObject(text, forKey: "character")
                        object?.saveInBackground({ (error) in
                            if error != nil {
                                print(error)
                            } else {
                                self.loadListTag()
                            }
                        })
                    }
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
}






