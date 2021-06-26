//
//  Job.swift
//  Socal_2106
//
//  Created by Long Bui on 6/23/21.
//

import Foundation

class Job: Codable {
    let id: String
    let TrackingNumber: String
    let NeedBy: String
    let WIPName: String
    let DateModified: String
    
    let PartNumber: String
    let Quantity: String
    let Customer: String
    let JobNumber: String
    let JobIn: String
    let Material: String
    let Color: String
    let CusDueDate: String
    let JobType: String
    let By: String
    
    init(
         id: String,
         TrackingNumber: String,
         NeedBy:String,
         WIPName: String,
         DateModified: String,
         
         PartNumber: String,
         Quantity: String,
         Customer: String,
         JobNumber: String,
         JobIn: String,
         Material: String,
         Color: String,
         CusDueDate: String,
         JobType: String,
         By: String
         )
    {
        self.id = id
        self.TrackingNumber = TrackingNumber
        self.NeedBy = NeedBy
        self.WIPName = WIPName
        self.DateModified = DateModified
        
        self.PartNumber = PartNumber
        self.Quantity = Quantity
        self.Customer = Customer
        self.JobNumber = JobNumber
        self.JobIn = JobIn
        self.Material = Material
        self.Color = Color
        self.CusDueDate = CusDueDate
        self.JobType = JobType
        self.By = By
    }

}
