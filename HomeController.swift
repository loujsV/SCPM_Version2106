//
//  HomeController.swift
//  Socal_2106
//
//  Created by Long Bui on 6/22/21.
//

import UIKit

class HomeController: UIViewController {

    var user_name_pass = String()
    
    
    @IBOutlet weak var Top_Title_username: UILabel!
    
    @IBOutlet weak var socal_name: UILabel!
    @IBOutlet weak var JobButton: UIButton!
    @IBOutlet weak var GageButton: UIButton!
    
    
    @IBAction func JobButton_Tapped(_ sender: Any) {
        performSegue(withIdentifier: "JobSegue", sender: self)
    }
    
    @IBAction func GageButton_Tapped(_ sender: Any) {
        performSegue(withIdentifier: "GageSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Lay duoc ten username
        print("Welcome " + user_name_pass.uppercased())
        Top_Title_username.text = "Welcome " + user_name_pass.uppercased()
        
        self.Top_Title_username.font = UIFont(name: "Cochin", size: 30.0)
        
        self.socal_name.font = UIFont(name: "Courier New", size: 45.0)
        self.socal_name.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        self.socal_name.text = "Socal Precision Machining"
        
        self.JobButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        self.JobButton.layer.cornerRadius = 15
        self.JobButton.layer.masksToBounds = true
        self.JobButton.setTitleColor(.white, for: .normal)
        JobButton.frame = CGRect(x: 73, y: 366, width: 277, height: 206)
//        self.JobButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        self.GageButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        self.GageButton.layer.cornerRadius = 15
        self.GageButton.layer.masksToBounds = true
        self.GageButton.setTitleColor(.white, for: .normal)
        GageButton.frame = CGRect(x: 448, y: 366, width: 277, height: 206)
   
        overrideUserInterfaceStyle = .light
    }
    
    
    //Pass Username to Job or Gage
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "JobSegue") {
            let vc = segue.destination as! ViewController_Job
            vc.user_name_pass_job = user_name_pass
        }
        if (segue.identifier == "GageSegue") {
            let vc1 = segue.destination as! ViewController_Gage
            vc1.user_name_pass_gage = user_name_pass
        }
    }
    
    //Lock khong cho xoay (OrientationLock) Lock2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
        
    }
    //Lock khong cho xoay (OrientationLock) Lock3
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppDelegate.AppUtility.lockOrientation(.all)
    }
}
