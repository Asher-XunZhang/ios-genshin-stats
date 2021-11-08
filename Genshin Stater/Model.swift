import UIKit
import CoreData

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let CONTEXT: NSManagedObjectContext = APPDELEGATE.persistentContainer.viewContext

enum CharacterRarity{
    case Four
    case Five
    case Special

    static func get(_ r: Int) -> CharacterRarity{
        switch r {
        case 4:
            return .Four
        case 5:
            return .Five
        case 6:
            return .Special
        default:
            return .Four
        }
    }

    func value()-> Int {
        switch self {
        case .Four:
            return 4
        case .Five:
            return 5
        case .Special:
            return 6
        }
    }
}

class SCharacter: CustomStringConvertible{
    var NSCharacter:Character
    var name:String{
        didSet{
            NSCharacter.name = name
        }
    }
    var avatar:Data{
        didSet{
            NSCharacter.avatar = avatar
        }
    }
    var level:Float{
        didSet{
            NSCharacter.level = level
        }
    }
    var rarity:Int{
        didSet{
            NSCharacter.rarity = Int32("\(rarity)")!
        }
    }
    var element:String{
        didSet{
            NSCharacter.element = element
        }
    }
    var weapon:String{
        didSet{
            NSCharacter.weapon = weapon
        }
    }
    var mainRole:String{
        didSet{
            NSCharacter.mainRole = mainRole
        }
    }
    var ascension:String{
        didSet{
            NSCharacter.ascension = ascension
        }
    }
    var baseHP: Int{
        didSet{
            NSCharacter.baseHP = Int32("\(baseHP)")!
        }
    }
    var baseATK: Int{
        didSet{
            NSCharacter.baseATK = Int32("\(baseATK)")!
        }
    }
    var baseDEF: Int{
        didSet{
            NSCharacter.baseDEF = Int32("\(baseDEF)")!
        }
    }
    var rating:Double{
        didSet{
            NSCharacter.rating = rating
        }
    }
    var comment:String{
        didSet{
            NSCharacter.comment = comment
        }
    }
    
    init(){
        self.NSCharacter = Character(context: CONTEXT)
        self.name = "New Character"
        self.avatar = UIImage(named: "default_character")!.pngData()!
        self.level = 1.0
        self.rarity = 4
        self.weapon = "Undefined"
        self.element = "Undefined"
        self.mainRole = "Undefined"
        self.ascension = "Undefined"
        self.baseHP = 0
        self.baseDEF = 0
        self.baseATK = 0
        self.rating = 0.0
        self.comment = ""
    }
    
    convenience init(sync:Bool){
        self.init()
        if sync {
            do {
                try CONTEXT.save()
                print("Create a new Character in Core Data successfully!")
            } catch {
                print("Fail to create a new Character in Core Data!")
            }
        }
    }

    init(character: Character) {
        self.NSCharacter = character
        self.name = character.name!
        self.avatar = character.avatar!
        self.level = character.level
        self.rarity = Int("\(character.rarity)")!
        self.weapon = character.weapon!
        self.element = character.element!
        self.mainRole = character.mainRole!
        self.ascension = character.ascension!
        self.baseHP = Int("\(character.baseHP)")!
        self.baseDEF = Int("\(character.baseDEF)")!
        self.baseATK = Int("\(character.baseATK)")!
        self.rating = character.rating
        self.comment = character.comment!
    }
    
    public var description: String{
        return String("\n|>name:\(name)\tavatar\(avatar)\tlevel:\(level)\trarity:\(rarity)\telement:\(element)\tweapon:\(weapon)\tmainRole:\(mainRole)\tascension:\(ascension)\tbaseHP:\(baseHP)\tbaseATK:\(baseATK)\tbaseDEF:\(baseDEF)\trating:\(rating)\t\(comment)<|\n")
    }
    
    func save() -> Bool{
        do {
            try CONTEXT.save()
            return true
        } catch {
            return false
        }
    }
}

func importDataToCoreData(_ csvName: String){
    let filepath = Bundle.main.path(forResource: csvName, ofType: "csv")
    if let content = try? String(contentsOfFile:filepath!, encoding: String.Encoding.utf8){
        var lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
        lines.removeFirst()
        lines = lines.filter({$0 != ""})
        //TODO: Remove in the future
        print("Reset Core Data...")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try CONTEXT.execute(deleteRequest)
            try CONTEXT.save()
        } catch {
            print ("There is an error in deleting records")
        }
        //TODO: Remove in the future above
        
        var recordLevels: [Int] = []
        print("Saving Data..")
        for line in lines{
            var values = line.split(separator: ",")
            let newCharacter  = Character(context: CONTEXT)
            newCharacter.setValue(String(values[0]), forKey: "name")
            newCharacter.setValue(UIImage(named: String(values[0]))!.pngData()!, forKey: "avatar")
            if Int(values[1]) == 90 {
                recordLevels = []
            }else{
                if recordLevels.contains(Int(values[1])!){
                    values[1] += ".5"
                }else{
                    recordLevels.append(Int(values[1])!)
                }
            }
            newCharacter.setValue(Float(values[1])!, forKey: "level")
            newCharacter.setValue(Int32(values[2])!, forKey: "rarity")
            newCharacter.setValue(String(values[3]), forKey: "element")
            newCharacter.setValue(String(values[4]), forKey: "weapon")
            newCharacter.setValue(String(values[5]), forKey: "mainRole")
            newCharacter.setValue(String(values[6]), forKey: "ascension")
            newCharacter.setValue(Int32(values[7])!, forKey: "baseHP")
            newCharacter.setValue(Int32(values[8])!, forKey: "baseATK")
            newCharacter.setValue(Int32(values[9])!, forKey: "baseDEF")
            newCharacter.setValue(Double(0.0), forKey: "rating")
            newCharacter.setValue("", forKey: "comment")
            do {
                try CONTEXT.save()
//                print("Storing data finished")
            } catch {
                print("Storing data Failed")
            }
        }
    }
}

var characterList : [String]? = nil

func exportDataFromCoreData()-> [[SCharacter]]{
    var charactersByName:[[SCharacter]] = []
    var namesCharacter: [String] = []
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
    request.returnsObjectsAsFaults = false
    do {
        let result = try CONTEXT.fetch(request)
        for data in result as! [NSManagedObject?] {
            if data != nil {
                let newSCharacter = SCharacter(character: (data as! Character))
                if !namesCharacter.contains(newSCharacter.name){
                    namesCharacter.append(newSCharacter.name)
                    charactersByName.append(getCharacterByName(newSCharacter.name))
                }
            }
        }
        print("Fetching data finished")
    } catch {
        print("Fetching data Failed")
    }
    
    characterList = namesCharacter
    return charactersByName
}

func deleteDataFromCoreData(_ deleteObj: SCharacter)->Bool{
    CONTEXT.delete(deleteObj.NSCharacter)
    do {
        try CONTEXT.save()
        print("Deleting data finished")
        return true
    } catch {
        print("Deleting data Failed")
        return false
    }
}

func getCharacterByName(_ nameP: String)->[SCharacter]{
    var certainCharacterByName:[SCharacter] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
    let predicate = NSPredicate(format: "name == %@", nameP)
    let sort = NSSortDescriptor(key: "level", ascending: true)
    request.sortDescriptors = [sort]
    request.predicate = predicate
    
    var Characters:[Character] = []
//    print("Fetching Data..")
    do{
        Characters = try context.fetch(request) as! [Character]
        Characters.forEach{character in
            let newCharacter = SCharacter(character: character)
            certainCharacterByName.append(newCharacter)
        }
    }catch{
        print("Fetching Data failed")
    }
    return certainCharacterByName
}
