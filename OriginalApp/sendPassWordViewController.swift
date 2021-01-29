//
//  sendPassWordViewController.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/12/01.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit
import NCMB

class sendPassWordViewController: UIViewController {
    
    @IBOutlet var mailadressTextfield: UITextField!
    
    @IBOutlet var sendPassWordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hex(string: "#9DDCDC", alpha: 0.8)
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        sendPassWordButton.layer.cornerRadius = 10
        
        // 2.影の設定
        // 影の濃さ
        sendPassWordButton.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        sendPassWordButton.layer.shadowRadius = 3
        // 影の色
        sendPassWordButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        sendPassWordButton
            .layer.shadowOffset = CGSize(width: 5, height: 5)
        
        
        
        
        
    }
    
    
    
    @IBAction func sendPassword() {
        //アラートを出してメアド入力してもらう
        let result = NCMBUser.requestPasswordResetForEmail(inBackground: mailadressTextfield.text) { (error) in
            if error != nil {
                print("error")
            }else{
                print("success")
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
    
}
