//
//  ViewController_JobSegment.swift
//  Socal_2106
//
//  Created by Long Bui on 6/25/21.
//

import UIKit

class ViewController_JobSegment: UIViewController {

    @IBOutlet weak var _TrackingNumber: UILabel!
    
    var Tracking_info : Job?
    
    @IBOutlet weak var _Seg_Mod: UIView!
    @IBOutlet weak var _Seg_His: UIView!
    
    @IBAction func _switchTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            _Seg_Mod.isHidden = false
            _Seg_His.isHidden = true

        }
        else
        {
            _Seg_Mod.isHidden = true
            _Seg_His.isHidden = false

        }
    }
    //Khong xai
    @IBOutlet weak var _switchView: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _TrackingNumber.text = InputDetails_Job.details._TrackingNum
        
    }
    

}
