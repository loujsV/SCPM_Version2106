//
//  ViewController_Gag_Segment_History.swift
//  Socal_2106
//
//  Created by Long Bui on 6/24/21.
//

import UIKit

class ViewController_Gag_Segment_History: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var tableViewGageHis: UITableView!
    
//    private var datalist = [Gage]()
//    var Gagefilter : [Gage] = []
//    var Gageduplist : [Gage] = [Gage]()
    
    private var datalist = [GageHistory]()
    var Gagefilter : [GageHistory] = []
    var Gageduplist : [GageHistory] = [GageHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("His user: " + InputDetails.details.username)
//        print("His user gageno: " + InputDetails.details._gageno)
//        print("His user gagename: " + InputDetails.details._gagename)
        
        downloadJson_GageHistory()
        
    }
    
    
    final let url = URL(string: "http://172.24.98.71:27394/api/ghistory/\(InputDetails.details._gageno)")
    
    func downloadJson_GageHistory() {
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
                    let downloadedjson1 = try decoder1.decode([GageHistory].self, from: dataGage)
                    self.datalist = downloadedjson1
                    self.Gageduplist = self.datalist
                    DispatchQueue.main.async {
                        self.tableViewGageHis.reloadData()
                        //self.tableViewGageHis.refreshControl?.endRefreshing()
                    }
                }
                catch
                {
                    print("wrong after download")
                }
            }.resume()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Gageduplist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableViewGageHis.dequeueReusableCell(withIdentifier: "GageHisCell") as? GageHistoryCell else {return UITableViewCell()}
        
        //Fetch data
        cell.RowNumber.text = Gageduplist[indexPath.row].RowNumber
        cell.DateMod.text = Gageduplist[indexPath.row].DateMod
        cell.ID.text = Gageduplist[indexPath.row].ID
        cell.Name.text = Gageduplist[indexPath.row].Name
        cell.Workstation.text = "Work Station: " + Gageduplist[indexPath.row].Workstation

        
        return cell
    }
    

}
