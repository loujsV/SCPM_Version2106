//
//  TrackingHistoryCell.swift
//  Socal_2106
//
//  Created by Long Bui on 6/25/21.
//

import UIKit

class TrackingHistoryCell: UITableViewCell {

    @IBOutlet weak var WIP: UILabel!
    
    
    @IBOutlet weak var Qty: UILabel!
    
    @IBOutlet weak var Action_: UILabel!
    
    @IBOutlet weak var Machine_Name: UILabel!
    
    @IBOutlet weak var Name_: UILabel!
    
    @IBOutlet weak var Note_: UILabel!
    
    @IBOutlet weak var DateMod_: UILabel!
    
    
    @IBOutlet weak var TrackCell_HIS: UIView!
    
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
