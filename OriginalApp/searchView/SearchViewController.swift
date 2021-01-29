//
//  SearchViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/11/12.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD
import SwiftDate

class SearchViewController: UIViewController,UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource{
    
    // Postの"tag","charactors","communitiea"を入れるためのString配列
    
    var tagItems = [[String]]()
    var charactorsItems = [[String]]()
    var communitiesItems = [[String]]()
    
    
    
    
    var searchBar: UISearchBar!
    
    var searchViewPosts = [NCMBObject]()
    
    var scopeTitleArray = ["全て","タグ一覧","タグ","人物","コミュニティー"]
    
    @IBOutlet var searchViewTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        
        searchViewTableView.dataSource = self
        searchViewTableView.delegate = self
        searchViewTableView.rowHeight = 300
        
        
        
        
        
        //Cellの取得
        let nib = UINib(nibName: "SearchViewTimeLineTableViewCell", bundle: nil)
        searchViewTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        searchViewTableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.white
        searchViewTableView.backgroundColor = UIColor.white
        
        // 表示させたいリストをセット
        self.searchBar.searchTextField.text = "aaa"
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setSearchBar() {
        // NavigationBarにSearchBarをセット
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "キーワード検索"
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
            
            searchBar.showsSearchResultsButton = true
            searchBar.prompt = "test1"
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = UIColor.hex(string: "#9DDCDC", alpha: 1.0)
            searchBar.tintColor = UIColor.hex(string: "#E67A7A", alpha: 0.5)
            searchBar.barTintColor = UIColor.hex(string: "#4D4136", alpha: 0.4)
            searchBar.scopeButtonTitles = scopeTitleArray
            searchBar.showsScopeBar = true
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
            
            
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSearchViewTableView(searchText: nil, seletedScopeTitle: scopeTitleArray[searchBar.selectedScopeButtonIndex] )
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SearchViewTimeLineTableViewCell else
        {return}
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchViewTimeLineTableViewCell
        
        let user = searchViewPosts[indexPath.row].object(forKey: "user") as! NCMBUser
        cell.searchViewUserNameLabel.text = user.object(forKey: "userName")as! String
        
        let userImageUrl = "https://mbaas.api.cloud.nifty.com/2013-09-01/applications/lVmAG2rPiTWPHrzE/publicFiles/" + user.objectId
        //        cell.searchViewUserImage.kf.setImage(with:URL(string: userImageUrl),placeholder: UIImage(named: "placeholder.jpg") )
        
        cell.searchViewCommentTextView.text = searchViewPosts[indexPath.row].object(forKey: "text") as! String
        let imageUrl = searchViewPosts[indexPath.row].object(forKey: "imageUrl") as! String
        print(imageUrl)
        cell.searchViewPhotoImageView.kf.setImage(with: URL(string: imageUrl))
        
        cell.searchViewDateLable.text = searchViewPosts[indexPath.row].object(forKey: "postDate") as! String
        
        // cellの色を変更
        cell.backgroundColor = UIColor.hex(string: "#FFF4E1", alpha: 1.5)
        cell.searchViewCommentTextView.backgroundColor = UIColor.hex(string: "#FFF4E1", alpha: 1.5)
        
        cell.searchViewTagLabel.backgroundColor = UIColor.hex(string: "#E67A7A", alpha: 1.5)
        cell.searchViewCommunitiesLabel.backgroundColor = UIColor.hex(string: "#E67A7A", alpha: 1.5)
        cell.searchViewCharactorsLabel.backgroundColor = UIColor.hex(string: "#E67A7A", alpha: 1.5)
        
        cell.searchViewTagLabel.textColor = .white
        cell.searchViewCommunitiesLabel.textColor = .white
        cell.searchViewCharactorsLabel.textColor = .white
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        // Labelを丸くする
        cell.searchViewTagLabel.layer.cornerRadius = 5
        cell.searchViewTagLabel.clipsToBounds = true
        cell.searchViewCommunitiesLabel.layer.cornerRadius = 5
        cell.searchViewCommunitiesLabel.clipsToBounds = true
        cell.searchViewCharactorsLabel.layer.cornerRadius = 5
        cell.searchViewCharactorsLabel.clipsToBounds = true
        
        //cellを丸くする
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        
        
        
        
        
        
        
        
        
        
        //タグ表示
        var showTags = ""
        let tagList = searchViewPosts[indexPath.row].object(forKey: "tag") as! [String]
        for tagsName in tagList {
            if tagsName == tagList.last {
                showTags = showTags + tagsName
            } else {
                showTags = showTags + tagsName + ","
            }
        }
        cell.searchViewTagLabel.text = showTags
        
        //コミュニティータグ表示
        
        var showCommunities = ""
        let communitiesList = searchViewPosts[indexPath.row].object(forKey: "communities") as! [String]
        for communitiesName in communitiesList {
            if communitiesName == tagList.last {
                showCommunities = showCommunities + communitiesName
            } else {
                showCommunities = showCommunities + communitiesName + ","
            }
        }
        cell.searchViewCommunitiesLabel.text = showCommunities
        
        // キャラクタタグ表示
        var ShowCharactors = ""
        let charactorsList = searchViewPosts[indexPath.row].object(forKey: "characters") as! [String]
        for charactorsName in charactorsList {
            if charactorsName == charactorsList.last {
                ShowCharactors = ShowCharactors + charactorsName
            } else {
                ShowCharactors = ShowCharactors + charactorsName + ","
            }
        }
        cell.searchViewCharactorsLabel.text = ShowCharactors
        
        
        return cell
        
        
        
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight:CGFloat = 5
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear  // 背景色を透過させる
        return marginView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude  // 完全に表示させないようにする
    }
    ////検索文字が更新されるたびに,loadSearchViewが呼ばれる
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadSearchViewTableView(searchText: searchText, seletedScopeTitle: scopeTitleArray[searchBar.selectedScopeButtonIndex])
    }
    
    
    
    
    func loadSearchViewTableView(searchText:String?,seletedScopeTitle:String?) {
        guard let currentUser = NCMBUser.current() else {
            //ログインに戻る
            //ログアウト登録成功
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let RootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = RootViewController
            //ログアウト状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
        }
        let query = NCMBQuery(className: "Post")
        //　自分の投稿を絞り込み
        query?.whereKey("user", equalTo: NCMBUser.current())
        // 降順
        query?.order(byDescending: "createDate")
        //searchtextがnilじゃなくてかつ、scopebarで"タグ"が選択されていたら、NCMBのタグfieldでsearchTextと同じものを絞り込む
        if searchText != nil && seletedScopeTitle == "タグ" {
            query?.whereKey("tag", equalTo: searchText)
            
        }
        if  searchText != nil && seletedScopeTitle == "人物" {
            query?.whereKey("characters", equalTo: searchText)
            
        }
        if searchText != nil && seletedScopeTitle == "コミュニティー" {
            query?.whereKey("communities", equalTo: searchText)
            
            
            
        }
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        //        print(searchText)
        //        print(searchCharactors)
        //        print(searchCommunities)
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        
        // フォロー中の人 + 自分の投稿だけ持ってくる
        //query?.whereKey("user", containedIn: followings)
        
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                HUD.flash(.error, delay: 1.5)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.searchViewPosts = [NCMBObject]()
                self.searchViewPosts = result as! [NCMBObject]
                
                print(result)
                
                // Postの"tag","charactors","communitiea"を入れる
                for i in self.searchViewPosts{
                    
                    print(self.searchViewPosts)
                    
                    let tagItem = i.object(forKey: "tag") as! [String]
                    let charactorsItem = i.object(forKey: "characters") as! [String]
                    let communitiesItem = i.object(forKey: "communities") as! [String]
                    
                    self.tagItems.append(tagItem)
                    self.charactorsItems.append(charactorsItem)
                    self.communitiesItems.append(communitiesItem)
                    
                    
                }
                
                
                
                
                
                
                
                
                
                //                        let imageUrl = postObject.object(forKey: "imageUrl") as! String
                //                        let text = postObject.object(forKey: "text") as! String
                //
                //                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                //                        let post = Post(objectId: postObject.objectId, user: userModel, imageUrl: imageUrl, text: text, createDate: postObject.createDate)
                //
                //                        // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                //                        let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                //                        if likeUsers?.contains(NCMBUser.current().objectId) == true {
                //                            post.isLiked = true
                //                        } else {
                //                            post.isLiked = false
                //                        }
                //
                //                        // いいねの件数
                //                        if let likes = likeUsers {
                //                            post.likeCount = likes.count
                //                        }
                //
                //                        // 配列に加える
                //                        self.posts.append(post)
                //                    }
                //                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.searchViewTableView.reloadData()
            }
        })
    }
    
    //    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    //        return true
    //    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        loadSearchViewTableView(searchText: searchBar.searchTextField.text, seletedScopeTitle: scopeTitleArray[searchBar.selectedScopeButtonIndex])
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.searchTextField.text = ""
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
