import UIKit
import SceneKit
import ARKit
import Toast_Swift

class ARController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var drawBtn: UIButton!
    @IBOutlet var sizeSlider:UISlider!
    private var currentColor:UIColor = .black
    private var currentSize: CGFloat = 0.05
    private var placedNodes = [SCNNode]()
    private var dataIndex = 0
    public var colors = [Color]()
    public var radia = [CGFloat]()
    private var savingHelper:SavingHelper?
    public var worldMap:ARWorldMap?
    public var worldMapData:Drawing?
    public var isLoading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        savingHelper = SavingHelper()
        savingHelper?.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.sizeSlider.addTarget(self, action: #selector(ARController.onSizeChange), for: UIControl.Event.valueChanged)
        
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
        configuration.initialWorldMap = worldMap
        if isLoading {
            colors = worldMapData!.colors
            radia = worldMapData!.radia
        }
        /// bij meegeven van worldmap ook de kleur van de prev sessie opslagen en hier initten TODO

        // hier komt de state van de opgeslagen sessie
        // configuration.initialWorldMap
        sceneView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        /// waneer we in de loading state zijn moeten we de node attr. initialiseren met de arrays Colors, Sizes
        var nodeColor:Color  = Color(col: currentColor )
        var nodeSize:CGFloat = currentSize
        if isLoading {
            nodeColor = colors[dataIndex]
            nodeSize = radia[dataIndex]
            dataIndex += 1
            if dataIndex > colors.count {
                dataIndex = 0
                isLoading = false
            }
        }
        
        guard !(anchor is ARPlaneAnchor) else {return}
        
        let spNode = createNode(color: nodeColor, radius: nodeSize)
        
        DispatchQueue.main.async {
            node.addChildNode(spNode)
        }
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
        
        guard let savingReturn = (savingHelper?.saveDrawing(scene: self.sceneView,colors: colors,radia: radia)) else {
            return
        } //condition drawing is gesaved ?
        self.present(savingReturn,animated: true,completion: {
            if fileCount < DocumentHelper.getDocumentsContent().count {
                self.view.makeToast("Drawing opgeslagen")
            }
        })
    }
    
    @IBAction func drawButtonPressed() {
        /// anchor locatie voor waar de node komt
        guard let currentFrame = sceneView.session.currentFrame else { return }
        var translation = matrix_identity_float4x4
        /// Node 30 cm voor de camera plaatsen
        translation.columns.3.z = -0.6
        /// simdTransform is wat we gaan gebruiken om een nieuwe anchor aan te maken
        let anchor = ARAnchor(transform: matrix_multiply(currentFrame.camera.transform, translation))
        
        sceneView.session.add(anchor: anchor)
        
    }
    
    // MARK: - NODE LOGICA
    
    private func createNode(color:Color,radius:CGFloat) -> SCNNode {
        let node = SCNNode()
        let geometry: SCNGeometry
        geometry = SCNSphere(radius: radius)
        node.geometry = geometry
        node.geometry?.firstMaterial?.diffuse.contents = color.uiColor
        colors.append(Color(col: currentColor))
        radia.append(currentSize)
        return node
    }
    
    
    @objc func onSizeChange(){
        DispatchQueue.main.async {
            self.currentSize = CGFloat(self.sizeSlider.value)
        }
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




