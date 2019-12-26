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
    var delegate: Saving?
    
    func saveDrawing( scene: ARSCNView) -> (UIAlertController) {
                
        func configurationTextField(textField: UITextField!) {
            print("generating the TextField")
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
            
            //logica voor het wegschrijven
            let title = self.tField.text ?? "drawing (deze waarde mss incrementen)"
            let newDrawing = Drawing(title: title, SCNPath: title)
            let currentScene = scene.scene
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let archiveURL = documentsDirectory.appendingPathComponent(newDrawing.title + ".scn")
        
         
            currentScene.write(to: archiveURL, options: nil, delegate: nil, progressHandler: nil)
            self.delegate?.didSave()
        }))
        
        return alert
        
    }
}




