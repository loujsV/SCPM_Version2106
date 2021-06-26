//
//  GageHistoryCell.swift
//  Socal_2106
//
//  Created by Long Bui on 6/25/21.
//

import UIKit

class GageHistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var RowNumber: UILabel!
    
    @IBOutlet weak var DateMod: UILabel!
    
    @IBOutlet weak var Workstation: UILabel!
    
    @IBOutlet weak var ID: UILabel!
    
    @IBOutlet weak var Name: UILabel!
    
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
