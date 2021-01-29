//
//  SignUpViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/14.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userIdTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet var signUPButton: ExpansionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // ボタンのタップ領域だけを大きくする
//        signUPButton.insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
//        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        signUPButton.layer.cornerRadius = 10
        
        // 2.影の設定
        // 影の濃さ
        signUPButton.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        signUPButton.layer.shadowRadius = 3
        // 影の色
        signUPButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        signUPButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        //　ボタンの背景色
        signUPButton.setGradientBackgroundColors([UIColor(hex:"9DDCDC"),UIColor(hex:"#7EC2C2")], direction: .toBottom, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp() {
        let user = NCMBUser()
        
        if userIdTextField.text!.count <= 4 {
            print("文字数が足りません")
            return
        }
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        if passwordTextField.text == confirmTextField.text {
            user.password = passwordTextField.text!
        } else {
            print("パスワードの不一致")
        }
        
        user.signUpInBackground { (error) in
            if error != nil {
                // エラーがあった場合
                print(error)
            } else {
                //登録成功
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
    
        class ExpansionButton: UIButton {
            
            var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
                var rect = bounds
                rect.origin.x -= insets.left
                rect.origin.y -= insets.top
                rect.size.width += insets.left + insets.right
                rect.size.height += insets.top + insets.bottom
                
                // 拡大したViewサイズがタップ領域に含まれているかどうかを返します
                return rect.contains(point)
            }
    }

    
    
    
    
    
}




