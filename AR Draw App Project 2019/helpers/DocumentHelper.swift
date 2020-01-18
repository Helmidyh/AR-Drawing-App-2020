
import UIKit
import SceneKit
import ARKit
public class DocumentHelper {
    
    static func getDocumentsContent() -> [URL]{
        var urls = [URL]()
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            urls = fileURLs
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return urls
    }
    
    static func getParsedDocumentsContent() -> [String]{
        /// wat er allemaal moet gebeuren :
        /// enkel files met de AREXPERIENCE extension mogen getoond worden
        /// daarna moet de .arexperience van de title gehaald worden
        // tekst
        var x = getDocumentsContent().map{ $0.lastPathComponent }
        var y = x.filter{ $0.contains(".arexperience")}.map{ $0.substring(to: $0.firstIndex(of: ".")!)}
        return y
    }
    
    static func getFilePath(f:String) -> URL{
        return getDocumentsContent().first(where: {$0.lastPathComponent == f })!
    }
    
    static func getWorldMapAtPath(path:URL) -> ARWorldMap {
        /// hier dan worldmap ophalen en in ARCONTROLLER worldmap binden aan scene
        let data = try?  Data(contentsOf: path)
        
        do {
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data!)
                else { fatalError("No ARWorldMap in archive.") }
            return worldMap
        } catch {
            fatalError("Can't unarchive ARWorldMap from file data: \(error)")
        }
    }
    
    static func getWorldMapData(title:String) -> Drawing {
        var drawing = Drawing(title: "", WRLDPath: "", colors: [Color](), radia:[CGFloat]())
        /// naam.arexperience - .arexperience + ARDATA.plist
        let dataString = title + "ARDATA.plist"
        let dataPath = getFilePath(f: dataString)
        /// Decode de data naar een Drawing object
        let propertyListDecoder = PropertyListDecoder()
        if let retrDrawingData = try? Data(contentsOf: dataPath),
            let decodedDrawing = try? propertyListDecoder.decode(Drawing.self, from: retrDrawingData){
            print(decodedDrawing)
            drawing = decodedDrawing
        }
        return drawing
    }
    
    static func removeFromDocuments(fileUrl:URL){
        do {
            try FileManager.default.removeItem(at: fileUrl)
        } catch {
            print("Error trying to delete file: \(error)")
        }
    }
    
}
