//
//  CalenderViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/11/17.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import FSCalendar
import NCMB
import PKHUD
class CalenderViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate {
    
    
    var posts = [NCMBObject]()
    
    
    // storyboardから繋いであるFSCalendar
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet var calenderTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート　データソースせ宣言
        calendar.delegate = self
        calendar.dataSource = self
        
        calenderTableView.delegate = self
        calenderTableView.dataSource = self
        //Cellの取得
        let nib = UINib(nibName: "SearchViewTimeLineTableViewCell", bundle: nil)
        calenderTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        calenderTableView.tableFooterView = UIView()
        calenderTableView.backgroundColor = UIColor.white
        calenderTableView.rowHeight = 300
        
        print(Date())
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //今日の日付を入れる
        let todaysDate = String(Date().year) + "/" + String(Date().month) + "/" +  String(Date().day)
        
        loadTimeLine(selectedDate:todaysDate )
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
        let selectedDate = String(date.year) + "/" + String( date.month) + "/" + String(date.day)
        print(selectedDate,"!!!!")
        loadTimeLine(selectedDate:selectedDate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchViewTimeLineTableViewCell
        
        let user = posts[indexPath.row].object(forKey: "user") as! NCMBUser
        cell.searchViewUserNameLabel.text = user.object(forKey: "userName")as! String
        
        let userImageUrl = "https://mbaas.api.cloud.nifty.com/2013-09-01/applications/lVmAG2rPiTWPHrzE/publicFiles/" + user.objectId
        //        cell.searchViewUserImage.kf.setImage(with:URL(string: userImageUrl),placeholder: UIImage(named: "placeholder.jpg") )
        
        cell.searchViewCommentTextView.text = posts[indexPath.row].object(forKey: "text") as! String
        let imageUrl = posts[indexPath.row].object(forKey: "imageUrl") as! String
        print(imageUrl)
        cell.searchViewPhotoImageView.kf.setImage(with: URL(string: imageUrl))
        
        cell.searchViewDateLable.text = posts[indexPath.row].object(forKey: "postDate") as! String
        
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
    
    func loadTimeLine(selectedDate:String?) {
        
        
        
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
        
        // 投稿したユーザーの情報も同時取得
        query?.includeKey("user")
        print("1221345678432145")
        print(selectedDate)
        
        if selectedDate != nil {
            query?.whereKey("postDate", equalTo: selectedDate)
        }
        
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
                
                
                
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.calenderTableView.reloadData()
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
