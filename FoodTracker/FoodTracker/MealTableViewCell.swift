//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Guido Corazza on 8/22/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    
    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
