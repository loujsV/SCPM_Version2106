//
//  Gage.swift
//  Socal_2106
//
//  Created by Long Bui on 6/23/21.
//

import UIKit


class Gage: Codable {
    let GageNo: String
    let Serial: String
    let Size: String
    let Fraction: String
    let Color: String
    let Modified: String
    let Location: String
    let CalDate: String
    let DueDate: String
    let Note: String
    
    init(
        GageNo: String,
        Serial: String,
        Size:String,
        Fraction: String,
        Color: String,
        Modified: String,
        Location: String,
        CalDate: String,
        DueDate: String,
        Note: String
        )
    {
        self.GageNo = GageNo
        self.Serial = Serial
        self.Size = Size
        self.Fraction = Fraction
        self.Color = Color
        self.Modified = Modified
        self.Location = Location
        self.CalDate = CalDate
        self.DueDate = DueDate
        self.Note = Note
    }

}
