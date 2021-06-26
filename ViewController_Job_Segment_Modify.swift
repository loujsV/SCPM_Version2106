//
//  ViewController_Job_Segment_Modify.swift
//  Socal_2106
//
//  Created by Long Bui on 6/26/21.
//

import UIKit

struct Job_Machine: Decodable {
    let MachineName: String
}
struct Wip_list: Decodable {
    let wipwip_name: String
}

class ViewController_Job_Segment_Modify: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func Update_btn_Tapped(_ sender: Any) {
        
        let restEndPoint: String = "http://172.24.98.71:27394/api/trackingnumber/\(InputDetails_Job.details._id_Track)"

                guard let url = URL(string: restEndPoint) else {
                    print("Error")
                    return
                }

                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "PUT"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                //urlRequest.setValue("KJLHJJGBMNMNB", forHTTPHeaderField: "APIKey")

                let jsonDictionary = NSMutableDictionary()
                jsonDictionary.setValue(WIP_name.text, forKey: "WIP_NAME")
                jsonDictionary.setValue(Machine_text.text, forKey: "MACHINE")
                jsonDictionary.setValue(Qty_text.text, forKey: "QUANTITY")
                jsonDictionary.setValue(InputDetails_Job.details._username_, forKey: "WHO")

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
                updateList_to_Main()
    }
    
    func updateList_to_Main() {
        //Close current view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var Machine_text: UITextField!
    
    @IBOutlet weak var WIP_name: UITextField!
    
    @IBOutlet weak var Qty_text: UITextField!
    
    //@IBOutlet weak var _Picker: UIPickerView!
    
    var machine_selection   = UIPickerView()
    var wip_selection       = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        _Picker.delegate = self
//        _Picker.dataSource = self
        MACHINE_ListLoadJSON()
        WIP_ListLoadJSON()
        
        WIP_name.inputView = wip_selection
        Machine_text.inputView = machine_selection
        
        wip_selection.delegate = self
        wip_selection.dataSource = self
        
        machine_selection.delegate = self
        machine_selection.dataSource = self

        wip_selection.tag = 1
        machine_selection.tag = 2
        
        
    }
    
    
    
    var machine_list = [Job_Machine] ()
    
    func MACHINE_ListLoadJSON() {
            let url = URL(string: "http://172.24.98.71:27394/api/track_machine")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.machine_list = try JSONDecoder().decode([Job_Machine].self, from: data!)
                    }
                    catch {
                        print("Parse error")
                    }
                    //print(self.gage_list.count)
                    DispatchQueue.main.async {
                        self.machine_selection.reloadComponent(0)
                    }
                }
                
            }.resume()
        }
    
    var listWIP = [Wip_list] ()
    
    func WIP_ListLoadJSON() {
            let url = URL(string: "http://172.24.98.71:27394/api/wipname")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do {
                        self.listWIP = try JSONDecoder().decode([Wip_list].self, from: data!)
                    }
                    catch {
                        print("Parse error")
                    }
                    //print(self.gage_list.count)
                    DispatchQueue.main.async {
                        self.wip_selection.reloadComponent(0)
                    }
                }
                
            }.resume()
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return machine_list.count
        switch pickerView.tag {
        case 1:
            return listWIP.count
        case 2:
            return machine_list.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return machine_list[row].MachineName
        switch pickerView.tag {
        case 1:
            return listWIP[row].wipwip_name
        case 2:
            return machine_list[row].MachineName
        default:
            return ""
        }
    }
    
    //delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedMachine = machine_list[row].MachineName
//        Machine_text.text = selectedMachine
        switch pickerView.tag {
        case 1:
            WIP_name.text = listWIP[row].wipwip_name
            WIP_name.resignFirstResponder()
            
        case 2:
            Machine_text.text = machine_list[row].MachineName
            Machine_text.resignFirstResponder()
            
        default:
            return
        }
    }
    
}
