//
//  GageCell.swift
//  Socal_2106
//
//  Created by Long Bui on 6/23/21.
//

import UIKit

class GageCell: UITableViewCell {

    
    @IBOutlet weak var GageNo: UILabel!
    
    @IBOutlet weak var SerialGage: UILabel!
    
    @IBOutlet weak var SizeGage: UILabel!
    
    @IBOutlet weak var FractionGage: UILabel!
    
    @IBOutlet weak var Color: UILabel!
    
    @IBOutlet weak var ModifiedGage: UILabel!
    
    @IBOutlet weak var LocationGage: UILabel!
    
    @IBOutlet weak var GageCellView: UIView!
    
    @IBOutlet weak var CalDate: UILabel!
    
    @IBOutlet weak var DueDate: UILabel!
    
    @IBOutlet weak var NoteGage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
            super.layoutSubviews()
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5))
            
        }
}
