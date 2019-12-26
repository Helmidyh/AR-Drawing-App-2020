
import UIKit

class HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var newDrawingBtn:UIButton!
    @IBOutlet weak var drawingsTable:UITableView!
    var drawings: [String] = [] // var tableData
    
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
    //    @IBAction func loadDrawing(_ :Any){
    //        performSegue(withIdentifier: "loadSCN", sender: nil)
    //
    //
    //    }
    //
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
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let x =  DocumentHelper.getDocumentsContent()
            DocumentHelper.removeFromDocuments(fileUrl: x[indexPath.row])
            drawings.remove(at: indexPath.row)
            //remove row from tableview en documents
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
