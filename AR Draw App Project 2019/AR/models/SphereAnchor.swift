//
//  SphereAnchor.swift
//  AR Draw App Project 2019
//
//  Created by Helmi Dayyeh on 13/01/2020.
//  Copyright © 2020 Helmi Dayyeh. All rights reserved.
//

import UIKit
import ARKit
class SphereAnchor: ARAnchor {
    
    var loc : [[Float]] = []
    var color: Color = Color(col: .black)
    
    override init(name:String, transform: simd_float4x4) {
        super.init(name:name,transform: transform)
    }
    
    required init?(coder: NSCoder) {
        if let locations = coder.decodeObject(forKey: "locList") as? [[Float]],
            
            let sColor = coder.decodeObject(forKey: "color") as? Color{
            self.loc = locations
            
            self.color = sColor
        } else {
            return nil
        }
        
        super.init(coder: coder)
    }
    required init(anchor: ARAnchor) {
        self.loc = (anchor as! SphereAnchor).loc
        self.color = (anchor as! SphereAnchor).color
        super.init(anchor: anchor)
    }
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(loc, forKey: "locList")
        coder.encode(color, forKey: "color")
    }
}

//func encodeColors(){
//    var encodedColors = [Data]()
//    for c in items {
//        if let encodedColor = try? c.encodeColor() {
//            encodedColors.append(encodedColor)
//        }
//    }
//    defaults.set(encodedColors,forKey: "encodedArray")
//}
//
//func decodeColors() -> [Color] {
//    var decodedColors = [Color]()
//    let colorDataArray = defaults.object(forKey: "encodedArray") as? [Data] ?? [Data]()
//    let propertyListDecoder = PropertyListDecoder()
//    for d in colorDataArray {
//        if let decodedColor = try? propertyListDecoder.decode(Color.self,from: d){
//            decodedColors.append(decodedColor)
//        }
//    }
//    return decodedColors
//}
