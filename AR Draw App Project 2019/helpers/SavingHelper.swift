//
//  SavingHelper.swift
//  AR Draw App Project 2019
//
//  Created by Helmi Dayyeh on 10/12/2019.
//  Copyright © 2019 Helmi Dayyeh. All rights reserved.
//

import UIKit
import ARKit

protocol Saving : class {
    func  didSave()
}

class SavingHelper {
    
    private var tField: UITextField!
    private var wrldMap:ARWorldMap?
    var delegate: Saving?
    func saveDrawing( scene: ARSCNView,colors: [Color],radia:[CGFloat]) -> (UIAlertController) {
        
        func configurationTextField(textField: UITextField!) {
            textField.placeholder = "Enter an item"
            tField = textField
        }
        
        func handleCancel(alertView: UIAlertAction!)  {
            //doe niks
        }
        
        let alert = UIAlertController(title: "Enter the name of the drawing", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{ (UIAlertAction) in
            
            scene.session.getCurrentWorldMap { worldMap, error in
                guard let map = worldMap
                    
                    else {  return }
                self.wrldMap = map
                
                let title = self.tField.text ?? "drawing"
                let newDrawing = Drawing(title: title, WRLDPath: title, colors:colors, radia:radia)
                let currentScene = scene.scene
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let mapURL = documentsDirectory.appendingPathComponent(newDrawing.title + ".arexperience")
                /// data die hoort bij de worldmap, kleuren + radia
                
                
                do {
                    /// Schrijf de worldmap weg
                    let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                    try data.write(to: mapURL, options: [.atomic])
                } catch {
                    fatalError("Can't save map: \(error.localizedDescription)")
                }
                do {
                    let dataURL = documentsDirectory.appendingPathComponent(newDrawing.title + "ARDATA").appendingPathExtension("plist")
                    let propertyListEncoder = PropertyListEncoder()
                    let encodedData = try? propertyListEncoder.encode(newDrawing)
                    try? encodedData?.write(to: dataURL,options: .noFileProtection)
                    
                } catch{
                    fatalError("Could not persist data:\(error.localizedDescription)")
                }
                self.delegate?.didSave()
                
            }
            
        }))
        
        return alert
        
    }
}




