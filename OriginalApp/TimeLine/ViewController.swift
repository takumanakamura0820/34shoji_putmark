//
//  ViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/06.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import PKHUD
import SwiftDate

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var posts = [NCMBObject]()
    
    @IBOutlet var timeLineTableView: UITableView!
    
    var tag = [String]()
    
    @IBOutlet weak var TagcollectionView: UICollectionView!
    
//    @IBOutlet var toPostButton: UIButton!
    
    var postBarButton: UIBarButtonItem!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //　ボタンの背景色 グラデーション
//        toPostButton
//            .setGradientBackgroundColors([UIColor(hex:"E21F70"),UIColor(hex:"FF402C")], direction: .toBottom, for: .normal)
//
        // ボタンのタップ領域だけを大きくする
        //        signInButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        //        forgetPassWordButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        //        createAccountButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
        
        
        //        print("aaaaaaaaaaaaaaaaaaar")
        //        print(NCMBUser.current())
        //timeLineTableView.rowHeight =
        timeLineTableView.dataSource = self
        timeLineTableView.delegate = self
        
        timeLineTableView.rowHeight = 300
        
        
        loadTimeLine()
        //Cellの取得
        let nib = UINib(nibName: "SearchViewTimeLineTableViewCell", bundle: nil)
        timeLineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        timeLineTableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.white
        timeLineTableView.backgroundColor = UIColor.white
        
        // 背景の透過
        UITabBar.appearance().backgroundImage = UIImage()
        // 境界線の透過
        UITabBar.appearance().shadowImage = UIImage()
        
        UITabBar.appearance().barTintColor = UIColor.red
        
//        // 1.角丸設定
//        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
//        toPostButton.layer.cornerRadius = 10
//        
//        // 2.影の設定
//        // 影の濃さ
//        toPostButton.layer.shadowOpacity = 0.7
//        // 影のぼかしの大きさ
//        toPostButton.layer.shadowRadius = 3
//        // 影の色
//        toPostButton.layer.shadowColor = UIColor.black.cgColor
//        // 影の方向（width=右方向、height=下方向）
//        toPostButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadTimeLine()
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        print(tag.count)
    //        return tag.count
    //    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagCollectionViewCell
    //        print(tag[indexPath.row])
    //        cell.tagLabel.text = tag[indexPath.row]
    //        cell.layer.borderWidth = 1
    //              cell.layer.borderColor = UIColor.gray.cgColor
    //
    //
    //        return cell
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let width = view.frame.width/5
    //        let height = view.frame.height/100
    //        return CGSize(width: 10, height:30 )
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TimeLineTableViewCell else { return }
        
        //tagTableViewCell.swiftで設定したメソッドを呼び出す(indexPath.section)
        //        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    //    ❷
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchViewTimeLineTableViewCell
        
        //        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        //        cell.tagCollectionView.reloadData()
        
        
        
        
        
        //        cell.delegate = self
        cell.tag = indexPath.row
        
        
        
        let user = posts[indexPath.row].object(forKey: "user") as! NCMBUser
        print(user)
        
        cell.searchViewUserNameLabel.text = user.object(forKey: "userName") as! String
        
        let userImageUrl = "https://mb.api.cloud.nifty.com/2013-09-01/applications/lVmAG2rPiTWPHrzE/publicFiles/" + user.objectId
        //        cell.userImageView.kf.setImage(with:URL(string: userImageUrl),placeholder: UIImage(named: "placeholder.jpg") )
        //
        cell.searchViewCommentTextView.text = posts[indexPath.row].object(forKey: "text") as! String
        let imageUrl = posts[indexPath.row].object(forKey: "imageUrl") as! String
        print(imageUrl)
        cell.searchViewPhotoImageView.kf.setImage(with: URL(string: imageUrl))
        // 日付の表示
        // 日付のフォーマット
        let formatter = DateFormatter()
        
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
        
        formatter.dateFormat = "yyyy年MM月dd日"
        
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        print(posts[indexPath.row].object(forKey: "postDate"))
        cell.searchViewDateLable.text = posts[indexPath.row].object(forKey: "postDate") as! String
        
        //        cell.dateLabel.text = String(posts[indexPath.row].object(forKey: "postDate")as! Date)
        
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
        let tagList = posts[indexPath.row].object(forKey: "tag") as! [String]
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
        let communitiesList = posts[indexPath.row].object(forKey: "communities") as! [String]
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
        let charactorsList = posts[indexPath.row].object(forKey: "characters") as! [String]
        for charactorsName in charactorsList {
            if charactorsName == charactorsList.last {
                ShowCharactors = ShowCharactors + charactorsName
            } else {
                ShowCharactors = ShowCharactors + charactorsName + ","
            }
        }
        cell.searchViewCharactorsLabel.text = ShowCharactors
        
        
        return cell
        
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
        
    }
    // DetailViewControllerに遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let detailViewController = segue.destination as! DetailViewController
    //        let selectedIndexPath = timeLineTableView.indexPathForSelectedRow!
    //    }
    
    func loadTimeLine() {
        
        
        
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
        // 降順
        query?.order(byDescending: "createDate")
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        
        // フォロー中の人 + 自分の投稿だけ持ってくる
        //query?.whereKey("user", containedIn: followings)
        print(NCMBUser.current())
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                HUD.flash(.error, delay: 1.5)
                
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [NCMBObject]()
                self.posts = result as! [NCMBObject]
                
                //                for postObject in result as! [NCMBObject] {
                //                    // ユーザー情報をUserクラスにセット
                //                    let user = postObject.object(forKey: "user") as! NCMBUser
                //
                //                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                //                    if user.object(forKey: "active") as? Bool != false {
                //                        // 投稿したユーザーの情報をUserモデルにまとめる
                //                        let userModel = User(objectId: user.objectId, userName: user.userName)
                //                        userModel.displayName = user.object(forKey: "displayName") as? String
                //
                //                        // 投稿の情報を取得
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
                self.timeLineTableView.reloadData()
            }
        })
    }
    
    @IBAction func toPost() {
        
        // postViewへ画面遷移
        let nc = tabBarController?.viewControllers?[3] as! UINavigationController
        //    ncの配下で、一番親になってるものを取得(つまりCalculateViewController)
        let vc = nc.topViewController as! PostViewController
        
        tabBarController?.selectedViewController = nc
        
        
    }
    
    
}



