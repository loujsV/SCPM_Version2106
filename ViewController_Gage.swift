//
//  ViewController_Gage.swift
//  Socal_2106
//
//  Created by Long Bui on 6/23/21.
//

import UIKit
import QuartzCore

struct InputDetails {
    static var details: InputDetails = InputDetails()

    var username: String = ""
    var _gageno: String = ""
    var _gagename: String = ""
}

class ViewController_Gage: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate, MySerialSendingDelegateProtocol {
    
    
    var user_name_pass_gage = String()

    @IBAction func Return_Menu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableviewGage: UITableView!
   
    final let url1 = URL(string: "http://172.24.98.71:27394/api/")
    
    private var datalist = [Gage]()
    var Gagefilter : [Gage] = []
    var GagesearchActive : Bool = false
    var Gageduplist : [Gage] = [Gage]()
    
    @IBOutlet weak var GageSearch_: UISearchBar!
    //Search Gage : Serial or Size
    var Search_Toogle_Switch : Bool = true
    
    @IBOutlet weak var QrCodeSerial: UIButton!
    
    var SerialUsingCamera : Bool = false
    
    var AfterUpdate_Serial : String = ""
    
    @IBAction func QrCodeSerial(_ sender: Any) {
        performSegue(withIdentifier: "GageSerialSegue", sender: self)
        SerialUsingCamera = true
    }
    
    @IBAction func SerialSearch_Switch(_ sender: UISwitch) {
        if (sender.isOn == true)
                {
                    GageSearch_.text = ""
                    Search_Toogle_Switch = true
                    GageSearch_.placeholder = "Search by Size"
                    QrCodeSerial.isHidden = true
                }
                else
                {
                    GageSearch_.text = ""
                    Search_Toogle_Switch = false
                    GageSearch_.placeholder = "Search by Serial"
                    QrCodeSerial.isHidden = false
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //print("Gage List: " + user_name_pass_gage)
        InputDetails.details.username = user_name_pass_gage.uppercased()
        //print("Gage Main: " + InputDetails.details.username)
        
        overrideUserInterfaceStyle = .light

                downloadJson_Gage()
                Gagefilter = datalist
                GageSearch_.delegate = self
                GageSearch_.backgroundImage = UIImage()
                GageSearch_.keyboardType = .numbersAndPunctuation
                GageSearch_.layer.borderWidth = 0
            
                if Search_Toogle_Switch == false {
                    GageSearch_.placeholder = "Search by Serial"
                    QrCodeSerial.isHidden = false
                }
                else if Search_Toogle_Switch == true {
                    GageSearch_.placeholder = "Search by Size"
                    QrCodeSerial.isHidden = true
                }
                
                //Pull to Update
                tableviewGage.refreshControl = UIRefreshControl()
                tableviewGage.refreshControl?.addTarget(self, action: #selector(PulltoRefresh), for: .valueChanged)
                
                //select for Open Gage Detail when Tapped cell
                self.tableviewGage.delegate = self
                
                //Hidden line separator between 2 cells
                self.tableviewGage.separatorStyle = UITableViewCell.SeparatorStyle.none
               
                //Update after press Update 2/3
        //        NotificationCenter.default.addObserver(self, selector: #selector(update_gageList), name: Notification.Name("update_gageList"), object: nil)
            }
    
    //Pull to Refresh
    @objc private func PulltoRefresh() {
        GageSearch_.text = ""
        downloadJson_Gage()
    }
    
    func downloadJson_Gage() {
            datalist.removeAll()
            guard let downloadGageURL = url1 else { return }
            URLSession.shared.dataTask(with: downloadGageURL) { data1, urlResponse1, error1 in
                guard let dataGage = data1, error1 == nil, urlResponse1 != nil else {
                    print("Wrong")
                    return
                }
                //print("Gage downloaded")
                do
                {
                    let decoder1 = JSONDecoder()
                    let downloadedjson1 = try decoder1.decode([Gage].self, from: dataGage)
                    self.datalist = downloadedjson1
                    self.Gageduplist = self.datalist
                    DispatchQueue.main.async {
                        self.tableviewGage.reloadData()
                        self.tableviewGage.refreshControl?.endRefreshing()
                    }
                }
                catch
                {
                    print("wrong after download")
                }
            }.resume()
        }
        
        func tableView(_ tableViewGage: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return datalist.count
            if GagesearchActive {
                return Gagefilter.count
            }
            return self.Gageduplist.count
        }
    
    //select for Open Gage Detail when Tapped cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You tapped me")

        performSegue(withIdentifier: "GageUpdateSegue", sender: self) //segment controller
        
    }

    
    func tableView(_ tableViewGage: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableViewGage.dequeueReusableCell(withIdentifier: "GageCell") as? GageCell else {return UITableViewCell()}
            
            //Fetch data
       
            cell.GageNo.text = Gageduplist[indexPath.row].GageNo
            cell.SerialGage.text = Gageduplist[indexPath.row].Serial
            cell.SizeGage.text = "Size: " + Gageduplist[indexPath.row].Size
            cell.FractionGage.text = "Fraction: " + Gageduplist[indexPath.row].Fraction
            cell.Color.text = "Color: " + Gageduplist[indexPath.row].Color
            cell.ModifiedGage.text = "Modified: " + Gageduplist[indexPath.row].Modified
            cell.LocationGage.text = "Location: " + Gageduplist[indexPath.row].Location
            cell.CalDate.text = "Cal Date: " + Gageduplist[indexPath.row].CalDate
            cell.DueDate.text = "Due Date: " + Gageduplist[indexPath.row].DueDate
            cell.NoteGage.text = "Note: " + Gageduplist[indexPath.row].Note
            
            //Design
        
            cell.GageNo.isHidden = true
        
            cell.GageCellView.layer.cornerRadius = cell.GageCellView.frame.height / 6
            cell.GageCellView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            cell.SerialGage.layer.cornerRadius = 6
            cell.SerialGage.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
            cell.SerialGage.font = UIFont.boldSystemFont(ofSize: 22)
            cell.SerialGage.layer.shadowColor = UIColor.white.cgColor
            cell.SerialGage.layer.shadowOpacity = 0.2
            cell.SerialGage.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.SerialGage.layer.shadowRadius = 2.0
            //increasing space between letters
            cell.SerialGage.addCharacterSpacing()
            
            cell.SizeGage.font = UIFont.boldSystemFont(ofSize: 17)
            cell.SizeGage.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            cell.SizeGage.layer.shadowColor = UIColor.white.cgColor
            cell.SizeGage.layer.shadowOpacity = 0.2
            cell.SizeGage.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.SizeGage.layer.shadowRadius = 2.0
            cell.SizeGage.addCharacterSpacing()
            
            cell.FractionGage.textColor = .black
            cell.ModifiedGage.textColor = .black
            cell.LocationGage.textColor = .black
            cell.CalDate.textColor = .black
            cell.DueDate.textColor = .blue
            cell.NoteGage.textColor = .black
            
            if (Gageduplist[indexPath.row].Color == "Blue") { cell.Color.textColor = .blue }
            else if (Gageduplist[indexPath.row].Color == "Black") { cell.Color.textColor = .black }
            else if (Gageduplist[indexPath.row].Color == "Gold") { cell.Color.textColor = .orange }
            else if (Gageduplist[indexPath.row].Color == "Green") { cell.Color.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Metal P") { cell.Color.textColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Metal S") { cell.Color.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Purple") { cell.Color.textColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Red") { cell.Color.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Yellow") { cell.Color.textColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1) }
            else { cell.Color.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
            
            if (Gageduplist[indexPath.row].Color == "Blue") { cell.Color.backgroundColor = .blue }
            else if (Gageduplist[indexPath.row].Color == "Black") { cell.Color.backgroundColor = .black }
            else if (Gageduplist[indexPath.row].Color == "Gold") { cell.Color.backgroundColor = .orange }
            else if (Gageduplist[indexPath.row].Color == "Green") { cell.Color.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Metal P") { cell.Color.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Metal S") { cell.Color.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Purple") { cell.Color.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Red") { cell.Color.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
            else if (Gageduplist[indexPath.row].Color == "Yellow") { cell.Color.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1) }
            else { cell.Color.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
            
            //import QuartzCore -> to make radius
            cell.Color.layer.cornerRadius = 10
            cell.Color.layer.shadowOpacity = 0.2
            cell.Color.layer.shadowOffset = CGSize(width: 1, height: 2)
            cell.Color.layer.shadowRadius = 2.0
            cell.Color.layer.masksToBounds = true
            

        
            return cell
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.Gageduplist = searchText.isEmpty ?datalist : datalist.filter({
                (cell) -> Bool in
                
                if (Search_Toogle_Switch == true) {
                    return cell.Size.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                return cell.Serial.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                
                            
            })
            self.tableviewGage.reloadData()
        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            GageSearch_.text = ""
            GageSearch_.showsCancelButton = false
            GageSearch_.endEditing(true)
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            GageSearch_.showsCancelButton = true
        }
    
    //for pass value to Gage Detail
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
//            //send Serial to next View Controller
            if segue.identifier == "GageUpdateSegue" {
                    if let destination = segue.destination as? ViewController_GageSegment
                    {
                        //Pass [SerialNumber]
                        destination.Gage_info_Detail = Gageduplist[(tableviewGage.indexPathForSelectedRow?.row)!]
                        tableviewGage.deselectRow(at: tableviewGage.indexPathForSelectedRow!, animated: true)
                        
                        
                        //Set gia tri khi Tap bang cach goi lai gia tri ben Segmen View controller
                        InputDetails.details._gageno = (destination.Gage_info_Detail?.GageNo)!
                        InputDetails.details._gagename = (destination.Gage_info_Detail?.Serial)!

                    }
            }
            
            //Delegate Method from Barcode Scanner
            else if segue.identifier == "GageSerialSegue" {
                let secondVC: ViewController_GageSerialCam = segue.destination as! ViewController_GageSerialCam
                secondVC.delegate = self
            }
            
       
        }
    /*
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
     */
    // Delegate Method from Barcode Scanner
        func sendSerialToFirstViewController(myData: String) {
            if SerialUsingCamera == true {
                
                AfterUpdate_Serial = myData //for Update reload
                
                let myString = myData // "SOUTHERN CALIFORNI01:;:265SC"
                let replaced = myString.replacingOccurrences(of: "SOUTHERN CALIFORNI01:;:", with: "") // "265SC"
                
                //self.GageSearch_.text = myData
                self.GageSearch_.text = replaced
               
                //UPDATE RESULT SEARCH (LIKE from func searchBar above)
                self.Gageduplist = replaced.isEmpty ?datalist : datalist.filter({
                    
                    (cell) -> Bool in
                    
                    return cell.Serial.range(of: replaced, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil
                    
                })
                
                self.tableviewGage.reloadData()
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





/*
 let dataToBeSent_gage = self.gagename
 let dataToBeSent_user = self.user_name_pass_
 self.delegate_Modify?.Segment_Gage_and_Username(myGage: dataToBeSent_gage, myUser: dataToBeSent_user)
 */
