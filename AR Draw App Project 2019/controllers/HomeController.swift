
import UIKit
import ARKit
class HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var newDrawingBtn:UIButton!
    @IBOutlet weak var drawingsTable:UITableView!
    var drawings: [String] = []
    var loadedMAP:ARWorldMap?
    var loadedMapData:Drawing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDrawingBtn.layer.cornerRadius = 10
        drawingsTable.dataSource = self
        drawingsTable.delegate = self
        drawingsTable.register(UITableViewCell.self, forCellReuseIdentifier: "DrawingTableViewCell")
        drawings = DocumentHelper.getParsedDocumentsContent()
    }
    override func viewWillAppear(_ animated: Bool) {
        drawings = DocumentHelper.getParsedDocumentsContent()
        self.drawingsTable.reloadData()
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func newDrawing(_ :Any){
        performSegue(withIdentifier: "toNewSCN", sender: nil)
        
    }
    
    @IBAction func loadDrawing(_ :Any){
        performSegue(withIdentifier: "loadSCN", sender: nil)
    }
    
    // MARK: - TABELVIEW DEL + SRC
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawingTableViewCell", for: indexPath)
        cell.textLabel?.text = drawings[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loadedWorldmap = DocumentHelper.getWorldMapAtPath(path: DocumentHelper.getFilePath(f: drawings[indexPath.item] + ".arexperience"))
        let loadedWorldmapData = DocumentHelper.getWorldMapData(title: drawings[indexPath.item] )
        /// meegeven met prepare
        loadedMAP = loadedWorldmap
        loadedMapData = loadedWorldmapData
        performSegue(withIdentifier: "loadSCN", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let x =  DocumentHelper.getDocumentsContent()
            /// eerst de data deleten, dan het label
            DocumentHelper.removeFromDocuments(fileUrl: DocumentHelper.getFilePath(f: drawings[indexPath.row] + "ARDATA.plist"))
                  DocumentHelper.removeFromDocuments(fileUrl: x[indexPath.row])
            drawings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadSCN" {
            let arController = segue.destination as! ARController
            arController.worldMap = loadedMAP
            arController.worldMapData = loadedMapData
            arController.isLoading = true
        }
    }
}
