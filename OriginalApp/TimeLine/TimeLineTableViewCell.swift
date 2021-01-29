//
//  TImeLineTableViewCell.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/10/15.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
   
    
    
  

    @IBOutlet var userNameLabel: UILabel!

    @IBOutlet var photoImageView: UIImageView!

    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var dateLabel: UILabel!
    
//    @IBOutlet var tagCollectionView: UICollectionView!
    
    @IBOutlet var tagLabel: UILabel!
    
    @IBOutlet var charactorslabel: UILabel!
    
    @IBOutlet var communitiesLabel: UILabel!
    
    var list = ["鳥取","GeekSalon","エビス"]
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let nib = UINib(nibName: "tagCollectionViewCell", bundle: nil)
//        tagCollectionView.register(nib, forCellWithReuseIdentifier: "tagCell")
        
        
        
        
//        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
//        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func setCollectionViewDataSourceDelegate
//        <D: UICollectionViewDataSource & UICollectionViewDelegate>
//        (dataSourceDelegate: D, forRow row: Int) {
//
//        tagCollectionView.delegate = dataSourceDelegate
//        tagCollectionView.dataSource = dataSourceDelegate
//        tagCollectionView.tag = row
////        tagCollectionView.
//        tagCollectionView.reloadData()
//    }
//    
    
}
