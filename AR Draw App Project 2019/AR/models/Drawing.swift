//
//  Drawing.swift
//  AR Draw App Project 2019
//
//  Created by Helmi Dayyeh on 02/12/2019.
//  Copyright © 2019 Helmi Dayyeh. All rights reserved.
//

import UIKit

struct Drawing: Codable {
    let title:String
    let WRLDPath:String
    let colors: [Color]
    let radia: [CGFloat]
}
// blijkbaar zijn arrays met codable types op hun beurt ook weer codable dus al deze code hieronder is waardeloos
//    static var supportsSecureCoding: Bool {
//        return true
//    }
//
//    init(title:String,path:String,colors:[Color],radia:[CGFloat]) {
//        self.title = title
//        self.WRLDPath = path
//        self.colors = colors
//        self.radia = radia
//    }
//
//
//    func encode(with coder: NSCoder) {
//        coder.encode(title as NSString ,forKey: "title")
//        coder.encode(WRLDPath as NSString ,forKey: "path")
//        let cl: [AnyObject] = colors.map{ $0 as! AnyObject}
//        coder.encode(cl,forKey: "colors")
//        let ra: [AnyObject] = colors.map{ $0 as! AnyObject}
//        coder.encode(ra,forKey: "radia")
//    }
//
//    required convenience init?(coder: NSCoder) {
//        let title = coder.decodeObject(of: NSString.self, forKey: "title") as String? ?? ""
//        let path = coder.decodeObject(of: NSString.self, forKey: "path") as String? ?? ""
//        let cl = coder.decodeObject(forKey: "colors") as![AnyObject]
//        let cw: [Color] = cl.map{$0 as! Color}
//        let rl = coder.decodeObject(forKey: "radia") as![AnyObject]
//        let rw: [CGFloat] = cl.map{$0 as! CGFloat}
//
//        self.init(title: title,path: path,colors: cw,radia: rw)
//
//    }
//
//
//}
//
