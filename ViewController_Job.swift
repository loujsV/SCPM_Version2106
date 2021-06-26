//
//  ViewController_Job.swift
//  Socal_2106
//
//  Created by Long Bui on 6/23/21.
//

import UIKit
import QuartzCore

struct InputDetails_Job {
    static var details: InputDetails_Job = InputDetails_Job()

    var _username_: String = ""
    var _id_Track: String = ""
    var _TrackingNum: String = ""
}


class ViewController_Job: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate, TrackingNo_SendingDelegateProtocol {

    var user_name_pass_job = String()
    
    
    var switch_selected: Int = 1
    
    @IBAction func _switch_SEARCH(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
           
            Jobsearch_.placeholder = "Search by Tracking"
            switch_selected = 1
        }
        else if sender.selectedSegmentIndex == 1
        {
            
            Jobsearch_.placeholder = "Search by Part"
            switch_selected = 2
        }
        else
        {
            Jobsearch_.placeholder = "Search by Job Number"
            switch_selected = 3
        }
    }
    
    
    
    @IBAction func onCameraButton(_ sender: Any) {
        performSegue(withIdentifier: "TrackNoCamSegue", sender: self)
                UsingCamera = true
    }
    
    var UsingCamera : Bool = false
    
    @IBAction func Return_Menu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    final let url = URL(string: "http://172.24.98.71:27394/api/trackingnumber")
        
        private var datalist = [Job]()
        var Jobfilter : [Job] = []
        var JobsearchActive : Bool = false
        var Jobduplist : [Job] = [Job]()
    
    @IBOutlet weak var Jobsearch_: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(user_name_pass_job)
        InputDetails_Job.details._username_ = user_name_pass_job.uppercased() //Xong bien 1
        
        overrideUserInterfaceStyle = .light
                
        downloadJson()
                
        Jobfilter = datalist
        
        Jobsearch_.delegate = self
                Jobsearch_.placeholder = "Tracking Number"
                Jobsearch_.layer.cornerRadius = 8
                Jobsearch_.backgroundImage = UIImage()
                Jobsearch_.keyboardType = .numberPad
                
        //Pull to Update
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPulltoRefresh), for: .valueChanged)
                
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //To Open Job Tracking History
        self.tableView.delegate = self
    }
    
    @objc private func didPulltoRefresh(){
            Jobsearch_.text = ""
            downloadJson()
        }
        func downloadJson()
        {
            datalist.removeAll()
            guard let downloadURL = url else { return }
            URLSession.shared.dataTask(with: downloadURL) {
                data, URLResponse, error in
                guard let data = data, error == nil, URLResponse != nil else {
                    //print("Something is wrong")
                    return
                }
                //print("Downloaded")
                do
                {
                    let decoder = JSONDecoder()
                    let downloadedjson = try decoder.decode([Job].self, from: data)
                    self.datalist = downloadedjson
                    self.Jobduplist = self.datalist
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                    }
    //               print(downloadedjson[0].DateModified)
                }
                catch
                {
                    //print("Something wrong after downloaded")
                }
            }.resume()
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return datalist.count
            if JobsearchActive { return Jobfilter.count }
            return self.Jobduplist.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobTrackingCell") as? JobTrackingCell else {return UITableViewCell()}
            
            //Fetch data
            cell._id.text = Jobduplist[indexPath.row].id
            cell.Tracking.text = Jobduplist[indexPath.row].TrackingNumber
            cell.Modified.text = "Modified: " + Jobduplist[indexPath.row].DateModified
            cell.WIP.text = "WIP: " + Jobduplist[indexPath.row].WIPName
            cell.Needby.text = "Need by: " + Jobduplist[indexPath.row].NeedBy
            
            cell.Partnumber.text = "Part: " + Jobduplist[indexPath.row].PartNumber
            cell.Quantity.text = "Quantity: " + Jobduplist[indexPath.row].Quantity
            cell.Customer.text = "Customer: " + Jobduplist[indexPath.row].Customer
            cell.JobNumber.text = "Job Number: " + Jobduplist[indexPath.row].JobNumber
            cell.JobIn.text = "Job In: " + Jobduplist[indexPath.row].JobIn
            cell.Material.text = "Material: " + Jobduplist[indexPath.row].Material
            cell.Color.text = "Color: " + Jobduplist[indexPath.row].Color
            cell.CusDueDate.text = "Customer Due: " + Jobduplist[indexPath.row].CusDueDate
            cell.Jobtype.text = "Job Type: " + Jobduplist[indexPath.row].JobType
            cell.ModBy.text = "By: " + Jobduplist[indexPath.row].By
            
            //Design
            cell._id.isHidden = true
            
            if (Jobduplist[indexPath.row].Color == "Black") { cell.Color.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Yellow") { cell.Color.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Blue") { cell.Color.backgroundColor = .blue }
            else if (Jobduplist[indexPath.row].Color == "Green") { cell.Color.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Red") { cell.Color.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Purple") { cell.Color.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1) }
            else { cell.Color.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
            
            if (Jobduplist[indexPath.row].Color == "Black") { cell.Color.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Yellow") { cell.Color.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Blue") { cell.Color.textColor = .blue }
            else if (Jobduplist[indexPath.row].Color == "Green") { cell.Color.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Red") { cell.Color.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
            else if (Jobduplist[indexPath.row].Color == "Purple") { cell.Color.textColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1) }
            else { cell.Color.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)}
            
            cell.Color.layer.cornerRadius = 10
            cell.Color.layer.shadowOpacity = 0.2
            cell.Color.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.Color.layer.shadowRadius = 2.0
            cell.Color.layer.masksToBounds = true
            
            cell.JobCell.layer.cornerRadius = cell.JobCell.frame.height / 6
            cell.JobCell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            
            cell.Tracking.layer.cornerRadius = 6
            cell.Tracking.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            cell.Tracking.font = UIFont.boldSystemFont(ofSize: 22)
            cell.Tracking.layer.shadowOpacity = 0.2
            cell.Tracking.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.Tracking.layer.shadowRadius = 2.0
            cell.Tracking.layer.shadowColor = UIColor.white.cgColor
            //increasing space between letters
            cell.Tracking.addCharacterSpacing()
            
            cell.Needby.font = UIFont.boldSystemFont(ofSize: 17)
            cell.Needby.textColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
            cell.Needby.layer.shadowOpacity = 0.2
            cell.Needby.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.Needby.layer.shadowRadius = 2.0
            
            cell.WIP.textColor = .black
            cell.Modified.textColor = .black
            cell.Partnumber.textColor = .black
            cell.Quantity.textColor = .black
            cell.Customer.textColor = .black
            cell.JobNumber.textColor = .black
            cell.JobIn.textColor = .black
            cell.Material.textColor = .black
//            cell.Color.textColor = .black
            cell.CusDueDate.textColor = .black
            cell.Jobtype.textColor = .black
            cell.ModBy.textColor = .black
            
            return cell
        }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.Jobduplist = searchText.isEmpty ?datalist : datalist.filter({
                (cell) -> Bool in
                
                if (switch_selected == 1) {
                    return cell.TrackingNumber.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                else if (switch_selected == 2) {
                    return cell.PartNumber.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                else if (switch_selected == 3) {
                    return cell.JobNumber.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                return cell.TrackingNumber.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
            })
            self.tableView.reloadData()
        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            Jobsearch_.text = ""
            Jobsearch_.showsCancelButton = false
            Jobsearch_.endEditing(true)
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            Jobsearch_.showsCancelButton = true
        }
    
    // Delegate Method from Barcode Scanner
        func send_TrackingNo_ToFirstViewController(myData: String) {
            if UsingCamera == true {
                //UPDATE RESULT SEARCH (LIKE from func searchBar above)
                self.Jobduplist = myData.isEmpty ?datalist : datalist.filter({
                    (cell) -> Bool in
                    
                    if (switch_selected == 1) {
                        return cell.TrackingNumber.range(of: myData, options: .caseInsensitive, range: nil, locale: nil) != nil
                    }
                    else if (switch_selected == 2) {
                        return cell.PartNumber.range(of: myData, options: .caseInsensitive, range: nil, locale: nil) != nil
                    }
                    else if (switch_selected == 3) {
                        return cell.JobNumber.range(of: myData, options: .caseInsensitive, range: nil, locale: nil) != nil
                    }
                    return cell.TrackingNumber.range(of: myData, options: .caseInsensitive, range: nil, locale: nil) != nil

                                
                })
                
                self.tableView.reloadData()
            }
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "TrackNoCamSegue" {
                let secondVC: ViewController_Job_CAM = segue.destination as! ViewController_Job_CAM
                secondVC.delegate = self
            }
            
            else if segue.identifier == "TrackingDetail_Segue" {
                if let destination = segue.destination as? ViewController_JobSegment
                {
                    //Pass [info]
                    destination.Tracking_info = Jobduplist[(tableView.indexPathForSelectedRow?.row)!]
                    tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
                    
                    //Set gia tri khi Tap bang cach goi lai gia tri ben Segmen View controller
                    InputDetails_Job.details._id_Track = (destination.Tracking_info?.id)!
                    InputDetails_Job.details._TrackingNum = (destination.Tracking_info?.TrackingNumber)!
                }
            }
        }
    
    //Open Detail History and Modify
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped me")
        performSegue(withIdentifier: "TrackingDetail_Segue", sender: self) //segment controller
        
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


//increasing space between letters
extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.5) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
