//
//  ViewController_Gage_Segment_Modify.swift
//  Socal_2106
//
//  Created by Long Bui on 6/24/21.
//

import UIKit
import QuartzCore

struct Gage_machineName: Decodable {
    let MachineName: String
}


class ViewController_Gage_Segment_Modify: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, MyDataSendingDelegateProtocol {
    
    var UsingCamera : Bool = false
    
    @IBAction func toCameraGage(_ sender: Any) {
        performSegue(withIdentifier: "GageScanner", sender: self)
        UsingCamera = true
        MachineText.text = ""
    }
    
    @IBOutlet weak var MachineText: UITextField!
    
    @IBOutlet weak var UpdateBtnView: UIButton!
    
    @IBAction func UpdateButton(_ sender: Any) {
        
        let restEndPoint: String = "http://172.24.98.71:27394/api/\(InputDetails.details._gageno)"

                guard let url = URL(string: restEndPoint) else {
                    print("Error")
                    return
                }

                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "PUT"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                //urlRequest.setValue("KJLHJJGBMNMNB", forHTTPHeaderField: "APIKey")

                let jsonDictionary = NSMutableDictionary()
        //        jsonDictionary.setValue(954, forKey: "ID")
                jsonDictionary.setValue(MachineText.text, forKey: "GageLocName")
                jsonDictionary.setValue(InputDetails.details.username, forKey: "WHO")

                let jsonData: Data

                do
                {
                    jsonData = try JSONSerialization.data (withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions())
                    urlRequest.httpBody = jsonData
                }
                catch{
                    print("Error creating JSON")
                    return
                }

                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)

                 let task = session.dataTask(with: urlRequest) { data, response, error in
                     guard let data = data, error == nil else {
                         print(error?.localizedDescription ?? "No data")
                        
                         return
                     }
                    
                     let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                     if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        
                     }
                    
                 }
                
                task.resume()
                updategageList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        UpdateBtnView.layer.cornerRadius = 20
        UpdateBtnView.layer.masksToBounds = true
        
        gageListLoadJSON()
        
        Machine_Picker.delegate = self
        Machine_Picker.dataSource = self
        
        //Test print
       
        print("Mod user: " + InputDetails.details.username)
        print("Mod user gageno: " + InputDetails.details._gageno)
        print("Mod user gagename: " + InputDetails.details._gagename)
    }
    
    //Gage Machine List Loading
    var gage_list = [Gage_machineName] ()
        
//    @IBOutlet weak var Machine_Picker: UIPickerView!
    @IBOutlet weak var Machine_Picker: UIPickerView!
    
    func gageListLoadJSON() {
            let url = URL(string: "http://172.24.98.71:27394/api/machine")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.gage_list = try JSONDecoder().decode([Gage_machineName].self, from: data!)
                    }
                    catch {
                        print("Parse error")
                    }
                    //print(self.gage_list.count)
                    DispatchQueue.main.async {
                        self.Machine_Picker.reloadComponent(0)
                    }
                }
                
            }.resume()
        }

    //Gage Machine List Picker View
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return gage_list.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return gage_list[row].MachineName
        }
        
        //delegate gage machine list
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedMachine = gage_list[row].MachineName
            MachineText.text = selectedMachine
        }
        
        func updategageList() {
            //Close current view controller
            dismiss(animated: true, completion: nil)
        }
    
    // Delegate Method from Barcode Scanner
        func sendDataToFirstViewController(myData: String) {
            if UsingCamera == true {
                self.MachineText.text = myData
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "GageScanner" {
                let secondVC: ViewController_Gage_Segment_CAM = segue.destination as! ViewController_Gage_Segment_CAM
                secondVC.delegate = self
            }
        }

}
