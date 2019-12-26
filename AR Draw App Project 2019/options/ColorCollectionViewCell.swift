//
//  ColorCell.swift
//  AR Draw App Project 2019
//
//  Created by Helmi Dayyeh on 11/11/2019.
//  Copyright © 2019 Helmi Dayyeh. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    var myColor: Color?
   
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.borderWidth = 5
            }
            else {
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 1
            }
        }
    }
}
