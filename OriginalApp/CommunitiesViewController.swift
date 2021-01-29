//
//  CommunitiesViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/11/01.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB
import PKHUD


class CommunitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ud = UserDefaults.standard
    
    @IBOutlet var communitiesTableView: UITableView!
    
    var selectedCommunities = [String]()
    
    var communitiesList = [NCMBObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communitiesTableView.dataSource = self
        communitiesTableView.delegate = self
        
        communitiesTableView.tableFooterView = UIView()
        
        // 複数選択可にする
        communitiesTableView.allowsMultipleSelection = true
        //udが空の時のクラッシュ回避
        if ud.array(forKey: "selectedCommunities") == nil {
            ud.set([], forKey: "selectedCommunities")
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadCommunitiesList()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communitiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = communitiesList[indexPath.row].object(forKey: "communityName") as! String
        cell?.selectionStyle = .none
        return cell!
    }
    //タッチしたセルの値をpostViewControllerのselectedCommunitiesに値渡し
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        print(cell?.accessoryType)
        
        // selectedTagsにtaglistを追加して、udに"selectedtags"で登録する
        let ud = UserDefaults.standard
        selectedCommunities.append(communitiesList[indexPath.row].object(forKey: "communityName") as! String)
        ud.set(selectedCommunities, forKey: "selectedCommunities")
//                  let preNC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! PostViewController
//                preNC.selectedCommunities = self.communitiesList[indexPath.row]
//        
//                self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        //        userDefaultsからデータを取り出す
        //        String型の配列にダウンキャストする
        selectedCommunities = ud.array(forKey:  "selectedCommunities") as![String]
        //selectedCommunitiesにセルをタッチして追加されたタグと、communitiesList[indexPath.row].object(forKey: "comubityName")が一致したものを削除して、udに再代入
        for i in 0...communitiesList.count {
            if selectedCommunities[i] == communitiesList[indexPath.row].object(forKey: "communityName")as! String {
                selectedCommunities.remove(at: i)
                
                // for分から抜ける
                break
                
            }
        }
        ud.set(selectedCommunities, forKey: "selectedCommunities")
        
    }
    
    // セルをタッチしてスワイプできる
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //スワイプしたセルを削除　※arrayNameは変数名に変更してください
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            communitiesList[indexPath.row].deleteInBackground { (error) in
                if error != nil {
                    print(error)
                } else {
                    self.loadCommunitiesList()
                }
                
                
                
                
            }
        }
        
        
        
    }
    func loadCommunitiesList() {
        let query = NCMBQuery(className: "Communities")
        query?.whereKey("user", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                self.communitiesList = result as! [NCMBObject]
                self.communitiesTableView.reloadData()
                PKHUD.sharedHUD.hide()
                
            }
        })
    }
    
    @IBAction func AddCommunities() {
        
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
                        let object = NCMBObject(className: "Communities")
                        object?.setObject(NCMBUser.current(), forKey: "user")
                        object?.setObject(text, forKey: "communityName")
                        object?.saveInBackground({ (error) in
                            if error != nil {
                                print(error)
                            } else {
                                self.loadCommunitiesList()
                            }
                        })
                    }
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}



