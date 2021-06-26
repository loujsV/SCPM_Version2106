//
//  ViewController_Job_Segment_History.swift
//  Socal_2106
//
//  Created by Long Bui on 6/25/21.
//

import UIKit

class ViewController_Job_Segment_History: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Gageduplist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableviewJobHis.dequeueReusableCell(withIdentifier: "TrackingHistoryCell") as? TrackingHistoryCell else {return UITableViewCell()}
        
        //Fetch data
        cell.WIP.text = "WIP: " + Gageduplist[indexPath.row].WIP
        cell.Action_.text = "Action: " + Gageduplist[indexPath.row].Action
        cell.Qty.text = "Qty: " + Gageduplist[indexPath.row].Qty
        cell.Machine_Name.text = "Machine: " + Gageduplist[indexPath.row].MachineName
        cell.Name_.text = "Name: " + Gageduplist[indexPath.row].Name
        cell.DateMod_.text = Gageduplist[indexPath.row].DateModified
        cell.Note_.text = "Note: " + Gageduplist[indexPath.row].Note

        
        cell.TrackCell_HIS.layer.cornerRadius = cell.TrackCell_HIS.frame.height / 6
        cell.TrackCell_HIS.backgroundColor = #colorLiteral(red: 0.666644454, green: 0.9282013774, blue: 0.878238976, alpha: 1)
        
        return cell
    }
    
    @IBOutlet weak var tableviewJobHis: UITableView!
    
    private var datalist = [TrackingHistory]()
    var Gagefilter : [TrackingHistory] = []
    var Gageduplist : [TrackingHistory] = [TrackingHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewJobHis.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        downloadJson_JobHistory()
        
    }
    
    final let url = URL(string: "http://172.24.98.71:27394/api/info/\(InputDetails_Job.details._id_Track)")
    
    func downloadJson_JobHistory() {
            datalist.removeAll()
        

        guard let downloadGageURL = url else { return }
        
            URLSession.shared.dataTask(with: downloadGageURL) { data1, urlResponse1, error1 in
                guard let dataGage = data1, error1 == nil, urlResponse1 != nil else {
                    print("Wrong")
                    return
                }
                print("Gage HIS downloaded")
                do
                {
                    let decoder1 = JSONDecoder()
                    let downloadedjson1 = try decoder1.decode([TrackingHistory].self, from: dataGage)
                    self.datalist = downloadedjson1
                    self.Gageduplist = self.datalist
                    DispatchQueue.main.async {
                        self.tableviewJobHis.reloadData()
                        //self.tableViewGageHis.refreshControl?.endRefreshing() cau lenh nay de refresh
                    }
                }
                catch
                {
                    print("wrong after download")
                }
            }.resume()
        }
    
   

}
