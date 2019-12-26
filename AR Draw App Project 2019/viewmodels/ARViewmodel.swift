
import UIKit


class ARViewmodel: Saving {
    
    func saveDrawing(){
        
        func configurationTextField(textField: UITextField!) {
            print("generating the TextField")
            textField.placeholder = "Enter an item"
            tField = textField
        }
        
        func handleCancel(alertView: UIAlertAction!) {
            print("Cancelled !!")
        }
        
        var alert = UIAlertController(title: "Enter the name of the drawing", message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
            print("Done !!")
          self.view.makeToast("Drawing opgeslagen")
            //logica voor het wegschrijven
            var title = self.tField.text ?? "drawing (deze waarde mss incrementen)"
            let newDrawing = Drawing(title: title, SCNPath: title)
            let currentScene = self.sceneView.scene
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let archiveURL = documentsDirectory.appendingPathComponent(newDrawing.title + ".scn")
            currentScene.write(to: archiveURL, options: nil, delegate: nil, progressHandler: nil)

            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                // process files
                print(fileURLs)
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
            
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

}
