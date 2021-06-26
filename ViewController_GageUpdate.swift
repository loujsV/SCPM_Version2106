//
//  ViewController_GageUpdate.swift
//  Socal_2106
//
//  Created by Long Bui on 6/24/21.
//

import UIKit

struct Gage_machineName: Decodable {
    let MachineName: String
}

class ViewController_GageUpdate: UIViewController {
    
    var user_name_pass_ = String()
    var gage_serial_pass = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(user_name_pass_)
        print(gage_serial_pass)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
