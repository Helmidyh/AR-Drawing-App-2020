
import UIKit
import EFColorPicker

protocol ColorPickerDelegate: class {
    func didSetDrawingColor(_ color: Color)
}

class ColorPickerController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIPopoverPresentationControllerDelegate, EFColorSelectionViewControllerDelegate{
    
    var delegate:ColorPickerDelegate?
    @IBOutlet var col:UICollectionView!
    private var items = [Color]()
    private var currentColorIndex = 0
    private var newColor:Color = Color(col: UIColor.black)
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deColors = decodeColors()
        if(deColors.count > items.count){
            items = deColors
        } else {
            items.append(Color(col: UIColor.blue))
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // alle kleuren moeten geEncode worden en dan weggeschreven worden in userDefaults
        encodeColors()
    }
    
    // MARK: - ENCODING
    
    func encodeColors(){
        var encodedColors = [Data]()
        for c in items {
            if let encodedColor = try? c.encodeColor() {
                encodedColors.append(encodedColor)
            }
        }
        defaults.set(encodedColors,forKey: "encodedArray")
    }
    
    func decodeColors() -> [Color] {
        var decodedColors = [Color]()
        let colorDataArray = defaults.object(forKey: "encodedArray") as? [Data] ?? [Data]()
        let propertyListDecoder = PropertyListDecoder()
        for d in colorDataArray {
            if let decodedColor = try? propertyListDecoder.decode(Color.self,from: d){
                decodedColors.append(decodedColor)
            }
        }
        return decodedColors
    }
    
    // MARK: - COLLECTION VIEW IMPL
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColorCollectionViewCell
        cell.backgroundColor = items[indexPath.item].uiColor
        cell.myColor = items[indexPath.item]
        let selectedCell = defaults.object(forKey: "selectedIndex") as? Int ?? Int()
        currentColorIndex = selectedCell
        cell.isSelected = false
        
        if indexPath.item == selectedCell {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            cell.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentColorIndex = indexPath.item
        
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
        defaults.set(indexPath.item, forKey: "selectedIndex")
        
        if let encodedColor = try? cell.myColor?.encodeColor() {
            defaults.set(encodedColor, forKey: "selectedColor")
        }
        
        delegate?.didSetDrawingColor(items[currentColorIndex])
    }
    
    // MARK: - COLOR PICKER LOGICA
    
    
    @IBAction func presentColorPicker() {
        let colorSelectionController = EFColorSelectionViewController()
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)
        navCtrl.navigationBar.backgroundColor = UIColor.white
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = view
        navCtrl.popoverPresentationController?.sourceRect = view.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        colorSelectionController.delegate = self
        colorSelectionController.color = self.view.backgroundColor ?? UIColor.white
        if UIUserInterfaceSizeClass.compact == self.traitCollection.horizontalSizeClass {
            let doneBtn: UIBarButtonItem = UIBarButtonItem(
                title: NSLocalizedString("Done", comment: ""),
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(ef_dismissViewController(sender:))
            )
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        }
        self.present(navCtrl, animated: true, completion: nil)
    }
    
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        //wanneer de gebruiker een kleur selecteerd maken we een nieuwe kleur aan
        newColor = Color(col: color)
    }
    
    @objc func ef_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            [weak self] in
            if let _ = self {
                //wanneer de colorPicker gesloten wordt dan voegen we de nieuwe kleur to aan de kleuren Array
                //daarna voegen we ook een nieuwe kleurencell toe aan de collectionview
                self!.items.append(self!.newColor)
                self!.col.insertItems(at: [IndexPath(row:(self?.items.count)! - 1,section: 0)])
            }
        }
    }
    
}
