//
//  YTListTableViewCell.swift
//  YTRxSwiftNewsDemo
//
//  Created by tangyin on 19/03/2018.
//  Copyright © 2018 ytang. All rights reserved.
//

import UIKit

class YTListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var morePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
