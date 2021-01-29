//
//  AddTagViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/24.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import  NCMB
import PKHUD

class AddTagViewController: UIViewController, UITextFieldDelegate ,UICollectionViewDelegate, UICollectionViewDataSource{
    
    var inputTags = [NCMBObject]()
    
    @IBOutlet var inputTagTextField: UITextField!
    
    @IBOutlet var temporalilyStoredTagCellectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AddTagCollectionViewCell", bundle: nil)
        temporalilyStoredTagCellectionView.register(nib, forCellWithReuseIdentifier: "AddTagCell")
        
        inputTagTextField.delegate = self
        
        temporalilyStoredTagCellectionView.dataSource = self
        temporalilyStoredTagCellectionView.delegate = self
        
        // 作るNCMB
        loadTag()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadTag()
    }
    
    //inpuTagTextFieldのデリゲートメソッド
    //1 「return」キーを押す と閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true 
    }
    //2 キーボード以外をタッチで閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

           self.view.endEditing(true)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if inputTags.count == 0 {
//            return 0
//        } else {
//            return inputTags.count
//        }
        print("みみりん")
        print(inputTags.count)
        print(inputTags)
        return inputTags.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTagCell", for: indexPath) as! AddTagCollectionViewCell
        
        cell.setTagLabel.text = inputTags[indexPath.row].object(forKey: "inputTags") as! String
        print(inputTags)
        
        return cell
    }
    
//    セルを選択したときに呼ばれる関数
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        セルを触る度に保存する
//        let ud = UserDefaults.standard
//
//        let data = try! NSKeyedArchiver.archivedData(withRootObject: inputTags[indexPath.row], requiringSecureCoding: false)
//        ud.set(data, forKey: "input")

        //タッチしたセルの値をpostViewControllerのselectedCommunitiesに値渡し
//        let preNC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2]  as! PostViewController
//        preNC.selectedTag = self.inputTags[indexPath.row]  //ここで値渡し
//
     
    }
    
    
    @IBAction func saveTag() {
        PKHUD.sharedHUD.show()

let object = NCMBObject(className: "imputTags")
        object?.setObject(inputTagTextField.text, forKey: "inputTags")
object?.saveInBackground({ (error) in
    if error != nil {
        print(error)
    } else {
        print("sucsess")
        self.inputTagTextField.text = ""
        self.loadTag()
//        let alertController = UIAlertController(title: "保存完了", message: "メモの保存が完了しました", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default) { (action) in
//            self.navigationController?.popViewController(animated: true)
//        }
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//
    }
    
})
          //戻る
       // self.dismiss(animated: true, completion: nil)
}
    
    func loadTag() {
        let query = NCMBQuery(className: "imputTags")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error)
            } else {
                self.inputTags = result as! [NCMBObject]
                print("aaaaaaaaaaaaaaaaaaaaaa")
                print(self.inputTags)
                self.temporalilyStoredTagCellectionView.reloadData()
                PKHUD.sharedHUD.hide()
            
            }
        })
    
    

    
    
    

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
