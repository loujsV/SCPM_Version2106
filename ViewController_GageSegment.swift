//
//  ViewController_GageSegment.swift
//  Socal_2106
//
//  Created by Long Bui on 6/24/21.
//

import UIKit


class ViewController_GageSegment: UIViewController {


    
    
    @IBOutlet weak var SegView_Modify: UIView!
    
    @IBOutlet weak var SegView_History: UIView!

    //Phai co dong nay de gan bien vao struct easier
    var Gage_info_Detail : Gage?
    var gagename : String = ""

    
    @IBOutlet weak var Gage_name: UILabel!

    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            SegView_Modify.isHidden = false
            SegView_History.isHidden = true

        }
        else
        {
            SegView_Modify.isHidden = true
            SegView_History.isHidden = false

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        gagename = (Gage_info_Detail?.Serial)!
        Gage_name.text = gagename

        
    }
    

}
