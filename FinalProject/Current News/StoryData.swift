import Foundation

class StoryData {
    class StoryEntry {
        let title : String
        let abstract : String
        var imageURL : String?
        
        init(title:String, abstract: String){
            self.title = title
            self.abstract = abstract
        }
    }
}