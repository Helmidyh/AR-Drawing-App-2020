
import UIKit
import ARKit
class HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var newDrawingBtn:UIButton!
    @IBOutlet weak var drawingsTable:UITableView!
    var drawings: [String] = [] // var tableData
    var loadedMAP:ARWorldMap?
    var loadedMapData:Drawing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDrawingBtn.layer.cornerRadius = 10
        drawingsTable.dataSource = self
        drawingsTable.delegate = self
        drawingsTable.register(UITableViewCell.self, forCellReuseIdentifier: "DrawingTableViewCell")
        drawings = DocumentHelper.getParsedDocumentsContent()
        print(DocumentHelper.getDocumentsContent())
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
        print("item clicked")
        print(DocumentHelper.getFilePath(f: drawings[indexPath.item] + ".arexperience"))
        let loadedWorldmap = DocumentHelper.getWorldMapAtPath(path: DocumentHelper.getFilePath(f: drawings[indexPath.item] + ".arexperience"))
        let loadedWorldmapData = DocumentHelper.getWorldMapData(title: drawings[indexPath.item] ) /// deze meegeven met prepare
        let destination = ARController()
        
        loadedMAP = loadedWorldmap
        loadedMapData = loadedWorldmapData
        performSegue(withIdentifier: "loadSCN", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let x =  DocumentHelper.getDocumentsContent()
            
            print(x[indexPath.row])
            DocumentHelper.removeFromDocuments(fileUrl: x[indexPath.row])
            DocumentHelper.removeFromDocuments(fileUrl: DocumentHelper.getFilePath(f: drawings[indexPath.row] + "ARDATA.plist"))
           
            drawings.remove(at: indexPath.row)
            //remove row from tableview en documents
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print(DocumentHelper.getDocumentsContent())
            
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
