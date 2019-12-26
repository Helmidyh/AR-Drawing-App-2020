//
//  Color.swift
//  AR Draw App Project 2019
//
//  Created by Helmi Dayyeh on 17/11/2019.
//  Copyright © 2019 Helmi Dayyeh. All rights reserved.
//
// https://www.hackingwithswift.com/example-code/language/how-to-store-nscoding-data-using-codable
import UIKit

class Color:Codable {
    
    private enum CodingKeys: CodingKey { case color }
    
    let uiColor:UIColor
    
    init(col:UIColor) {
        self.uiColor = col
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorData = try container.decode(Data.self, forKey: .color)
        uiColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? UIColor.black
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }
    
    public func encodeColor() throws -> Data {
        let propertyListEncoder = PropertyListEncoder()
        return try propertyListEncoder.encode(self)
    }
}
