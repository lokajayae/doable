//
//  ToDoItemCell.swift
//  doable
//
//  Created by Evan Lokajaya on 23/05/24.
//

import UIKit
import SwipeCellKit

class ToDoItemCell: SwipeTableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    static let identifier = "ToDoItemCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ToDoItemCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
