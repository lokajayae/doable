//
//  CategoryCellTableViewCell.swift
//  doable
//
//  Created by Evan Lokajaya on 22/05/24.
//

import UIKit
import SwipeCellKit

class CategoryCell: SwipeTableViewCell{
    
    @IBOutlet weak var emojiLogo: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    
    
    static let identifier = "CategoryCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
