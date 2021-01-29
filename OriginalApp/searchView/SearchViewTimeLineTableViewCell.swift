//
//  SearchViewTimeLineTableViewCell.swift
//  OriginalApp
//
//  Created by 岡野将士 on 2020/11/14.
//  Copyright © 2020 net.shojiokano. All rights reserved.
//

import UIKit

class SearchViewTimeLineTableViewCell: UITableViewCell {
    
   
    @IBOutlet var searchViewUserNameLabel: UILabel!
    @IBOutlet var searchViewPhotoImageView: UIImageView!
    @IBOutlet var searchViewCommentTextView: UITextView!
    @IBOutlet var searchViewTagLabel: UILabel!
    @IBOutlet var searchViewCharactorsLabel: UILabel!
    @IBOutlet var searchViewCommunitiesLabel: UILabel!
    @IBOutlet weak var searchViewDateLable: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

    }
    
}
