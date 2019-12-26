
import UIKit

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
    
    static func removeFromDocuments(fileUrl:URL){
       do {
           try FileManager.default.removeItem(at: fileUrl)
       } catch {
           print("Error trying to delete file: \(error)")
       }
    }
    
}
