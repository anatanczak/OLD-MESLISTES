
import Foundation

import RealmSwift

class NoteImageObject: Object {
    @objc dynamic var name          : String = ""
    @objc dynamic var pathString    : String = ""
    @objc dynamic var position      : Int = 0
    
}
