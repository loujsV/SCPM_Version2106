//
//  JobTrackingCell.swift
//  Socal_2106
//
//  Created by Long Bui on 6/23/21.
//

import UIKit

class JobTrackingCell: UITableViewCell {
    
//        @IBOutlet weak var Tracking: UILabel!
//        @IBOutlet weak var WIP: UILabel!
//        @IBOutlet weak var Modified: UILabel!
//        @IBOutlet weak var Needby: UILabel!
//
//        @IBOutlet weak var JobCell: UIView!
    
    
    @IBOutlet weak var JobCell: UIView!
    
    
    @IBOutlet weak var Tracking: UILabel!
    @IBOutlet weak var WIP: UILabel!
    @IBOutlet weak var Modified: UILabel!
    @IBOutlet weak var Needby: UILabel!
    
    
    @IBOutlet weak var _id: UILabel!
    @IBOutlet weak var Quantity: UILabel!
    @IBOutlet weak var Partnumber: UILabel!
    @IBOutlet weak var Customer: UILabel!
    @IBOutlet weak var JobNumber: UILabel!
    @IBOutlet weak var JobIn: UILabel!
    @IBOutlet weak var Material: UILabel!
    @IBOutlet weak var Color: UILabel!
    @IBOutlet weak var Jobtype: UILabel!
    @IBOutlet weak var ModBy: UILabel!
    @IBOutlet weak var CusDueDate: UILabel!
    
    
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
