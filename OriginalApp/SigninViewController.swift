//
//  SigninViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/14.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB
import DTGradientButton

class SigninViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var userIdTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var forgetPassWordButton: UIButton!
    
    @IBOutlet var createAccountButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // ボタンのタップ領域だけを大きくする
        //        signInButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        //        forgetPassWordButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        //        createAccountButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
        
        userIdTextField.delegate = self
        passwordTextField.delegate = self
        
        //　ボタンの背景色 グラデーション
        signInButton.setGradientBackgroundColors([UIColor(hex:"#9DDCDC"),UIColor(hex:"#E67A7A")], direction: .toBottom, for: .normal)
        
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        signInButton.layer.cornerRadius = 10
        
        // 2.影の設定
        // 影の濃さ
        signInButton.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        signInButton.layer.shadowRadius = 3
        // 影の色
        signInButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        signInButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
        
        
        
        
        
        
    }
    //キーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    @IBAction func signIn() {
        if (userIdTextField.text?.count)! > 0 && (passwordTextField.text?.count)! > 0 {
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    //振動させる（バイブ）UIkit
                    let generetor = UINotificationFeedbackGenerator()
                    generetor.notificationOccurred(.error)
                    print("振動")
                } else {
                    //ログイン成功
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //ログイン状態の保持
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                }
            }
        }
        
        
        
        
        
        
    }
    
    
  
    
//    class ExpansionButton: UIButton {
//
//        var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//            var rect = bounds
//            rect.origin.x -= insets.left
//            rect.origin.y -= insets.top
//            rect.size.width += insets.left + insets.right
//            rect.size.height += insets.top + insets.bottom
//
//            // 拡大したViewサイズがタップ領域に含まれているかどうかを返します
//            return rect.contains(point)
//        }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */



