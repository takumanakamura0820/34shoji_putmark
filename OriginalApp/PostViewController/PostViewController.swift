//
//  PostViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/15.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NYXImagesKit
import UITextViewPlaceholder
import PKHUD
import FDFullscreenPopGesture
import NCMB
import Kingfisher



class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate,UITableViewDataSource, UITextViewDelegate{
    
    
    let ud = UserDefaults.standard
    
    var putTag = ""
    var putCharactors =  ""
    var putCommunities =  ""
    
    
    
    
    
    var showTags = [NCMBObject]()
    // Cellをタッチして値渡しされた値を格納するための配列
    var selectedTags = [String]()
    
    var selectedCharactors = [String]()
    
    var selectedCommunities = [String]()
    
    
    var sectionTitles = ["タグ","人物","コミュニティー"]
    
    // Cellをタッチして値渡しされた値を格納するための配列
    
//    @IBOutlet var setTagLabel: UILabel!
//
//    @IBOutlet weak var setCharactorsLabel: UILabel!
//
//    @IBOutlet weak var setCommunitiesLabel: UILabel!
    
    //datePicker
    @IBOutlet var dateField: UITextField!
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    
    
    
    let placeholderImage =  UIImage(named: "photo-placeholder")
    
    var resizedImage: UIImage!
    
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var postTextView: UITextView!
    
    @IBOutlet var postButton: UIBarButtonItem!
    
    
    
    //    @IBOutlet weak var showTagCollectionView: UICollectionView!
    
    @IBOutlet weak var tagTableView: UITableView!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        postTextView.placeholder = "テキスト入力"
        
        let ud = UserDefaults.standard
        
        ud.object(forKey: "input")
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        
        
        //
        
        
        //        let nib = UINib(nibName: "ShowTagCollectionViewCell", bundle: nil)
        //        showTagCollectionView.register(nib, forCellWithReuseIdentifier: "showTagCell")
        //
        //                let tableViewNib = UINib(nibName: "ShowTagTableViewCell", bundle: nil)
        //                tagTableView.register(tableViewNib, forCellReuseIdentifier: "Cell")
        
        tagTableView.delegate = self
        
        tagTableView.dataSource = self
        
        
        
        
        
        
        postImageView.image = placeholderImage
        
        postButton.isEnabled = false
        
        postTextView.delegate = self
        
        //UINavigationControllerで画面のどこをスワイプしても戻れるようにしてあげる
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
        
        
        loadTag()
        
        
        
        
    }
    //    // view表示でキーボードが出てきて、すぐ入力できる
    //    override func viewDidAppear(_ animated: Bool) {
    //        postTextView.becomeFirstResponder()
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadTag()
        transition()
        
        //　遷移から戻ってきたときに、どのセルを洗濯していたか分かる
        if let indexPathForSelectedRow = tagTableView.indexPathForSelectedRow {
            tagTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
        
        
        
        
        
        
        
        
    }
    // UIDatePickerのDoneを押したら発火
    @objc func done() {
        dateField.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
        
        formatter.dateFormat = "yyyy,MM,dd,EEE"
        
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        dateField.text = "\(formatter.string(from: datePicker.date))"
        
        print(datePicker.date)
        
        
        
    }
    
    //画面が移り変わるときに、Labelを空にするため、udに空の値を入れる
    override func viewWillDisappear(_ animated: Bool) {
        //        ud.set([], forKey: "selectedTags")
        //        ud.set([], forKey: "selectedCommunities")
        //        ud.set([], forKey: "selectedCharactors")
    }
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return 1
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showTagCell", for: indexPath) as! ShowTagCollectionViewCell
    //
    //
    //        cell.showTagLabel.text =  selectedTag.object(forKey: "inputTags") as! String
    //        //showTags[indexPath.row].object(forKey: "inputTags") as! String
    //
    //        return cell
    //    }
    //　pickerから画像を取り出す
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // UIImsgeのサイズが大きいから、リサイズするNYXImagakit
        resizedImage = selectedImage.scale(byFactor: 0.3)
        
        postImageView.image = resizedImage
        
        picker.dismiss(animated: true, completion: nil)
        
        confirmContent()
        
        //tag 3項目のデリゲートメソッド
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // sectionタイトルを設定する
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return 0
            
        }
        //        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        
        if indexPath.section == 0 {
            for i in 0...putTag.count {
                print("hhhhhsstfgfhgffssfghsg")
                print(putTag)
                cell?.textLabel?.text = putTag
            }
            
            
        }
        if indexPath.section == 1 {
            for i in 0...putCharactors.count {
                cell?.textLabel?.text = putCharactors
            }
        }
        
        if indexPath.section == 2 {
            for i in 0...putCommunities.count {
                cell?.textLabel?.text = putCommunities
            }
        }
        
        //        if indexPath.section == 0 {
        //            cell?.textLabel?.text = selectedTags[indexPath.row]
        //        } else if indexPath.section == 1 {
        //            cell?.textLabel?.text = selectedCharactors[indexPath.row]
        //
        //        } else if indexPath.section == 2 {
        //            cell?.textLabel?.text = selectedCommunities[indexPath.row]
        //
        //        }
        
        
        //        if indexPath.row == 0 {
        //            cell?.textLabel?.text = "タグ"
        //
        //
        //        } else if indexPath.row == 1 {
        //            cell?.textLabel?.text = "人物"
        //        } else if indexPath.row == 2 {
        //            cell?.textLabel?.text = "コミュニティー"
        //
        //        }
        
        
        
        
        return cell!
    }
    // segueのIDをつける
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            self.performSegue(withIdentifier: "toAddTag", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "toAddCharactors", sender: nil)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "toAddCommunities", sender: nil)
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func selectImage() {
        let alertController = UIAlertController(title: "画像選択", message: "シェアする画像画像を洗濯してください", preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
                
            } else {
                print("このカメラは使用できません")
            }
        }
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            //　アルバム起動
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker,animated: true, completion:nil)
            } else {
                print("この機種ではフォトライブラリが使用できません")
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sharePhoto() {
        PKHUD.sharedHUD.show()
        
        //撮影した画像をデータ化したときに右に90°回転してしまう問題の解消
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = UIImage.pngData(resizedImage)
        
        
        let file = NCMBFile.file(with: data()) as! NCMBFile
        //        画像ファイルをNCMBのファイルストアに送る
        file.saveInBackground { (error) in
            if error != nil {
                PKHUD.sharedHUD.hide()
                let alert = UIAlertController(title: "画像アップロード", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //画像アップロードが成功
                let postObject = NCMBObject(className: "Post")
                
                if self.postTextView.text.count == 0 {
                    print("入力されていません")
                    return
                }
                postObject?.setObject(self.postTextView.text!, forKey: "text")
                postObject?.setObject(NCMBUser.current(), forKey: "user")
                postObject?.setObject(self.selectedTags, forKey: "tag")
                postObject?.setObject(self.selectedCharactors, forKey: "characters")
                postObject?.setObject(self.selectedCommunities, forKey: "communities")
                postObject?.setObject(self.dateField.text, forKey: "date")
                
                // 2000/6/20 でpostdateに送る
                let postDate =  String(self.datePicker.date.year) + "/" + String( self.datePicker.date.month) + "/" + String(self.datePicker.date.day)
                postObject?.setObject(postDate, forKey: "postDate")
                
                let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/lVmAG2rPiTWPHrzE/publicFiles/" + file.name
                //file.nameってのが画像ファイルのIDにあたるもの
                postObject?.setObject(url, forKey: "imageUrl")
                //                postObject?.setObject(self.selectedTag.object(forKey: "inputTag")as! String, forKey: "tag")
                
                
                
                postObject?.saveInBackground({ (error) in
                    if error != nil {
                        HUD.flash(.error, delay: 1.0)
                    } else {
                        PKHUD.sharedHUD.hide()
                        // postviewが二つある？
                        self.postImageView.image = nil
                        self.postImageView.image = UIImage(named: "photo-placeholder")
                        self.postTextView.text = nil
                        self.tabBarController?.selectedIndex = 0
                    }
                })
            }
            
            
        }
        
        
        
        
        
        
    }
    
    func confirmContent() {
        if postTextView.text.count > 0 && postImageView.image != placeholderImage {
            postButton.isEnabled = true
        } else {
            postButton.isEnabled = false
        }
    }
    
    @IBAction func cancel() {
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
        }
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を変更しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.postTextView.text = nil
            self.postImageView.image = UIImage(named: "photo-placeholder")
            self.confirmContent()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadTag() {
        let query = NCMBQuery(className: "imputTags")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                
                self.showTags = result as! [NCMBObject]
                print("aaaaaaaaaaaaaaaaaaaaaa")
                print(self.showTags)
                //                self.showTagCollectionView.reloadData()
                PKHUD.sharedHUD.hide()
                
            }
        })
    }
    // udにセットされた値をlabelに並べる
    func transition() {
        
        if ud.array(forKey: "selectedCharactors") != nil  {
            
            selectedCharactors = ud.array(forKey: "selectedCharactors") as! [String]
            
            var ShowCharactors = ""
            
            for charactorsName in selectedCharactors {
                if charactorsName == selectedCharactors.last {
                    ShowCharactors = ShowCharactors + charactorsName
                } else {
                    ShowCharactors = ShowCharactors + charactorsName + ","
                }
            }
            
            putCharactors = ShowCharactors
            
//            setCharactorsLabel.text = ShowCharactors
            
            
            
            
            //            setCharactorsLabel.text = selectedCharactors.object(forKey: "character") as! String
            
        }
        
        if ud.array(forKey: "selectedCommunities")  != nil  {
            
            selectedCommunities = ud.array(forKey: "selectedCommunities") as! [String]
            
            var showCommunities = ""
            
            for communitiesName in selectedCommunities {
                if communitiesName == selectedCommunities.last {
                    showCommunities = showCommunities + communitiesName
                } else {
                    showCommunities = showCommunities + communitiesName + ","
                }
            }
            putCommunities = showCommunities
            print(showCommunities)
//            setCommunitiesLabel.text = showCommunities
            //showで遷移した時の値渡し（前のやつ）
            //            setCommunitiesLabel.text = selectedCommunities.object(forKey:"communityName") as! String
        }
        
        if ud.array(forKey: "selectedTags")  != nil {
            
            selectedTags = ud.array(forKey: "selectedTags") as! [String]
            print(selectedTags)
            
            var showTag = ""
            for tagName in selectedTags {
                print(tagName)
                print(showTag)
                if tagName == selectedTags.last {
                    showTag = showTag + tagName
                } else {
                    showTag = showTag + tagName + "、"
                }
            }
            putTag = showTag
//            setTagLabel.text = showTag
        }
        
        tagTableView.reloadData()
    }
    
    
    
    
    
    
}





