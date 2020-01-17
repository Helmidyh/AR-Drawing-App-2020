
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
        return getDocumentsContent().map{ $0.lastPathComponent }
    }
    
    static func getFilePath(f:String) -> URL{
        return getDocumentsContent().first(where: {$0.lastPathComponent == f})!
    }
    
 // static func getDrawingAtUrl(path:URL) -> Drawing {
 //
 //  }
    
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
    
    static func removeFromDocuments(fileUrl:URL){
        do {
            try FileManager.default.removeItem(at: fileUrl)
        } catch {
            print("Error trying to delete file: \(error)")
        }
    }
    
}
