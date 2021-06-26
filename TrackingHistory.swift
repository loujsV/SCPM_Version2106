//
//  TrackingHistory.swift
//  Socal_2106
//
//  Created by Long Bui on 6/25/21.
//

import Foundation




class TrackingHistory: Codable {
    let WIP: String
    let Action: String
    let Qty: String
    let MachineName: String
    let Name: String
    let DateModified: String
    let Note: String

    
    init(
        WIP: String,
        Action: String,
        Qty: String,
        MachineName: String,
        Name: String,
        DateModified: String,
        Note: String
        )
    {
        self.WIP = WIP
        self.Action = Action
        self.Qty = Qty
        self.MachineName = MachineName
        self.Name = Name
        self.DateModified = DateModified
        self.Note = Note
    }

}
