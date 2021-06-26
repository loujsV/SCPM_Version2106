//
//  GageHistory.swift
//  Socal_2106
//
//  Created by Long Bui on 6/25/21.
//

import Foundation


class GageHistory: Codable {
    let RowNumber: String
    //let Serial: String
    let Workstation: String
    let ID: String
    let Name: String
    let DateMod: String

    
    init(
         RowNumber: String,
         //Serial: String,
         Workstation: String,
         ID: String,
         Name: String,
         DateMod: String
        )
    {
        self.RowNumber = RowNumber
        //self.Serial = Serial
        self.Workstation = Workstation
        self.ID = ID
        self.Name = Name
        self.DateMod = DateMod
    }

}
