//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by zxx_mbp on 2018/4/1.
//  Copyright © 2018年 zxx_mbp. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
//    MARK:Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
