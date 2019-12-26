import UIKit
import SceneKit
import ARKit
import Toast_Swift

class ARController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var drawBtn: UIButton!
    @IBOutlet var sizeSlider:UISlider!
    private var currentColor:UIColor?
    private var placedNodes = [SCNNode]()
    private var savingHelper:SavingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        savingHelper = SavingHelper()
        savingHelper?.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let defaults = UserDefaults.standard
        let colorData = defaults.object(forKey: "selectedColor") as? Data ?? Data()
        let propertyListDecoder = PropertyListDecoder()
        if let decodedColor = try? propertyListDecoder.decode(Color.self,from: colorData){
            print(decodedColor.self.uiColor)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    // deze functionaliteit kan mss in een aparte controler komen
    @IBAction func displayOptionsForSelectedItem (_ sender:UIButton!) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        let actionSave = UIAlertAction(title: "Save", style: .default, handler: {action in
            self.saveDrawing()
        } )
        actionSave.setValue(UIImage(systemName: "square.and.arrow.down.fill")?.withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(actionSave)
        let actionColor = UIAlertAction(title: "Colors", style: .default, handler: {action in self.performSegue(withIdentifier: "colorPickerSegue", sender: nil) })
        actionColor.setValue(UIImage(systemName: "pencil.tip")?.withRenderingMode(.alwaysOriginal), forKey: "image")
        alert.addAction(actionColor)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
        self.present(alert, animated: true)
    }
    
    // MARK: - SaveHelper <- veranderen naar ARHelper
    
    @IBAction func saveDrawing () {
        let fileCount = DocumentHelper.getDocumentsContent().count
        
        guard let savingReturn = (savingHelper?.saveDrawing(scene: self.sceneView)) else {
            return
        } //condition drawing is gesaved ?
        self.present(savingReturn,animated: true,completion: {
            if fileCount < DocumentHelper.getDocumentsContent().count {
                self.view.makeToast("Drawing opgeslagen")
            }
        })
    }
    
    @IBAction func drawButtonPressed() {
        addNodeInFront(createNode(color: self.currentColor ?? UIColor.black))
    }
    
    // MARK: - NODE LOGICA
    
    private func createNode(color: UIColor) -> SCNNode {
        let geometry: SCNGeometry
        let meters: CGFloat
        meters = CGFloat(sizeSlider.value)
        geometry = SCNSphere(radius: meters)
        geometry.firstMaterial?.diffuse.contents = color
        return SCNNode(geometry: geometry)
    }
    
    func addNodeInFront (_ node: SCNNode){
        guard let currentFrame = sceneView.session.currentFrame else { return }
        var translation = matrix_identity_float4x4
        //Node 30 cm voor de camera plaatsen
        translation.columns.3.z = -0.6
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        addNodeToSceneRoot(node)
    }
    
    func addNodeToSceneRoot(_ node:SCNNode){
        let cloneNode = node.clone()
        sceneView.scene.rootNode.addChildNode(cloneNode)
        placedNodes.append(cloneNode)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorPickerSegue" {
            let colorPickerController = segue.destination as! ColorPickerController
            colorPickerController.delegate = self
        }
    }
}

// MARK: - COLORPICKER DELEGATE

extension ARController : ColorPickerDelegate {
    func didSetDrawingColor(_ color: Color) {
        self.currentColor = color.uiColor
        self.drawBtn.tintColor = color.uiColor
    }
}

extension ARController : Saving {
    func didSave() {
        var style = ToastStyle()
        style.messageColor = .cyan
        self.view.makeToast("Drawing saved succesfully !", duration: 2.0, position: .center, style: style)
    }
}




