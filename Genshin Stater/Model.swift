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


//extension Notification.Name {
//    static let didChangeName = Notification.Name("didChangeName")
//    static let failedChangeName = Notification.Name("failedChangeName")
//
//    static let didChangeLevel = Notification.Name("didChangeLevel")
//    static let failedChangeLevel = Notification.Name("failedChangeLevel")
//
//    static let didChangeRarity = Notification.Name("didChangerarity")
//    static let failedChangeRarity = Notification.Name("failedChangeName")
//
//    static let didChangeElement = Notification.Name("didChangeElement")
//    static let failedChangeElement = Notification.Name("failedChangeElement")
//
//    static let didChangeWeapon = Notification.Name("didChangeWeapon")
//    static let failedChangeWeapon = Notification.Name("failedChangeWeapon")
//
//    static let didChangeMainRole = Notification.Name("didChangeMainRole")
//    static let failedChangeMainRole = Notification.Name("failedChangeMainRole")
//
//    static let didChangeAscension = Notification.Name("didChangeAscension")
//    static let failedChangeAscension = Notification.Name("failedChangeAscension")
//
//    static let didChangeBaseHP = Notification.Name("didChangeBaseHP")
//    static let failedChangeBaseHP = Notification.Name("failedChangeBaseHP")
//
//    static let didChangeBaseATK = Notification.Name("didChangeBaseATK")
//    static let failedChangeBaseATK = Notification.Name("failedChangeBaseATK")
//
//    static let didChangeBaseDEF = Notification.Name("didChangeBaseDEF")
//    static let failedChangeBaseDEF = Notification.Name("failedChangeBaseDEF")
//
//    static let didChangeRating = Notification.Name("didChangeRating")
//    static let failedChangeRating = Notification.Name("failedChangeRating")
//
//    static let didChangeComment = Notification.Name("didChangeComment")
//    static let failedChangeComment = Notification.Name("failedChangeComment")
//}

class SCharacter: CustomStringConvertible{
    var NSCharacter:Character
    var name:String{
        didSet{
            NSCharacter.name = name
            do {
                try CONTEXT.save()
//                NotificationCenter.default.post(name: .didChangeName, object: nil)
                print("Update name successfully!")
            } catch {
                NSCharacter.name = oldValue
                name = oldValue
//                NotificationCenter.default.post(name: .failedChangeName, object: nil)
                print("Fail to update name!")
            }
        }
    }
    
    var level:Int{
        didSet{
            NSCharacter.level = Int32("\(level)")!
            do {
                try CONTEXT.save()
//                NotificationCenter.default.post(name: .didChangeLevel, object: nil)
                print("Update level successfully!")
            } catch {
                NSCharacter.level = Int32("\(oldValue)")!
                level = oldValue
//                NotificationCenter.default.post(name: .failedChangeLevel, object: nil)
                print("Fail to update level!")
            }
        }
    }
    
    var rarity:Int{
        didSet{
            NSCharacter.rarity = Int32("\(rarity)")!
            do {
                try CONTEXT.save()
//                NotificationCenter.default.post(name: .didChangeRarity, object: nil)
                print("Update rarity successfully!")
            } catch {
                NSCharacter.rarity = Int32("\(oldValue)")!
                rarity = oldValue
//                NotificationCenter.default.post(name: .didChangeName, object: nil)
                print("Fail to update rarity!")
            }
        }
    }
    
    var element:String{
        didSet{
            NSCharacter.element = element
            do {
                try CONTEXT.save()
                print("Update element successfully!")
            } catch {
                NSCharacter.rarity = Int32("\(oldValue)")!
                element = oldValue
                print("Fail to update element!")
            }
        }
    }
    
    var weapon:String{
        didSet{
            NSCharacter.weapon = weapon
            do {
                try CONTEXT.save()
                print("Update weapon successfully!")
            } catch {
                NSCharacter.weapon = oldValue
                weapon = oldValue
                print("Fail to update weapon!")
            }
        }
    }
    
    var mainRole:String{
        didSet{
            NSCharacter.mainRole = mainRole
            do {
                try CONTEXT.save()
                print("Update mainRole successfully!")
            } catch {
                NSCharacter.mainRole = oldValue
                mainRole = oldValue
                print("Fail to update mainRole!")
            }
        }
    }
    
    var ascension:String{
        didSet{
            NSCharacter.ascension = ascension
            do {
                try CONTEXT.save()
                print("Update ascension successfully!")
            } catch {
                NSCharacter.ascension = oldValue
                ascension = oldValue
                print("Fail to update ascension!")
            }
        }
    }
    
    var baseHP: Int{
        didSet{
            NSCharacter.baseHP = Int32("\(baseHP)")!
            do {
                try CONTEXT.save()
                print("Update baseHP successfully!")
            } catch {
                NSCharacter.baseHP = Int32("\(oldValue)")!
                baseHP = oldValue
                print("Fail to update baseHP!")
            }
        }
    }
    var baseATK: Int{
        didSet{
            NSCharacter.baseATK = Int32("\(baseATK)")!
            do {
                try CONTEXT.save()
                print("Update baseATK successfully!")
            } catch {
                NSCharacter.baseATK = Int32("\(oldValue)")!
                baseATK = oldValue
                print("Fail to update baseATK!")
            }
        }
    }
    var baseDEF: Int{
        didSet{
            NSCharacter.baseDEF = Int32("\(baseDEF)")!
            do {
                try CONTEXT.save()
                print("Update baseDEF successfully!")
            } catch {
                NSCharacter.baseDEF = Int32("\(oldValue)")!
                baseDEF = oldValue
                print("Fail to update baseDEF!")
            }
        }
    }
    
    var rating:Double{
        didSet{
            NSCharacter.rating = rating
            do {
                try CONTEXT.save()
                print("Update rating successfully!")
            } catch {
                NSCharacter.rating = oldValue
                rating = oldValue
                print("Fail to update rating!")
            }
        }
    }
    
    var comment:String{
        didSet{
            NSCharacter.comment = comment
            do {
                try CONTEXT.save()
                print("Update comment successfully!")
            } catch {
                NSCharacter.comment = oldValue
                comment = oldValue
                print("Fail to update comment!")
            }
        }
    }

    init(){
        self.NSCharacter = Character(context: CONTEXT)
        self.name = "New Character"
        self.level = 1
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
        self.level = Int("\(character.level)")!
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
        return String("\n|>name:\(name)\tlevel:\(level)\trarity:\(rarity)\telement:\(element)\tweapon:\(weapon)\tmainRole:\(mainRole)\tascension:\(ascension)\tbaseHP:\(baseHP)\tbaseATK:\(baseATK)\tbaseDEF:\(baseDEF)\trating:\(rating)\t\(comment)<|\n")
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
        
        print("Saving Data..")
        for line in lines{
            let values = line.split(separator: ",")
            let newCharacter  = Character(context: CONTEXT)
            newCharacter.setValue(String(values[0]), forKey: "name")
            newCharacter.setValue(Int32(values[1])!, forKey: "level")
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

func exportDataFromCoreData()-> [[SCharacter]]{
    var charactersByName:[[SCharacter]] = []
    var namesCharacter: [String] = []
//    print("Fetching Data..")
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
    request.returnsObjectsAsFaults = false
    do {
        let result = try CONTEXT.fetch(request)
        for data in result as! [NSManagedObject] {
            var newSCharacter = SCharacter(character: (data as! Character))
            if !namesCharacter.contains(newSCharacter.name){
                namesCharacter.append(newSCharacter.name)
                charactersByName.append(getCharacterByName(newSCharacter.name))
            }
        }
        print("Fetching data finished")
    } catch {
        print("Fetching data Failed")
    }
    return charactersByName
}


//func addDataToCoreData(_ characterP:SCharacter)->Bool{
//    characterP.NSCharacter = Character(context: CONTEXT)
//    characterP.NSCharacter.name = characterP.name
//    characterP.NSCharacter.level = Int32("\(characterP.level)")!
//    characterP.NSCharacter.rarity  = Int32("\(characterP.rarity)")!
//    characterP.NSCharacter.element = characterP.element
//    characterP.NSCharacter.weapon  = characterP.weapon
//    characterP.NSCharacter.mainRole = characterP.mainRole
//    characterP.NSCharacter.ascension = characterP.ascension
//    characterP.NSCharacter.baseHP  = Int32("\(characterP.baseHP)")!
//    characterP.NSCharacter.baseATK = Int32("\(characterP.baseATK)")!
//    characterP.NSCharacter.baseDEF = Int32("\(characterP.baseDEF)")!
//    characterP.NSCharacter.rating = characterP.rating
//    do {
//        try CONTEXT.save()
//        print("Adding data finished")
//        return true
//    } catch {
//        print("Adding data Failed")
//        return false
//    }
//}


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

//func changeDataFromCoreData(_ changeObj: SCharacter, newValue:Any, forKey:String)->Bool{
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//    switch(forKey){
//    case "character":
//        changeObj.NSCharacter.name = newValue as! String
//    case "level":
//        changeObj.NSCharacter.level = Int32("\(newValue)")!
//    case "rarity":
//        changeObj.NSCharacter.rarity = Int32("\(newValue)")!
//    case "element":
//        changeObj.NSCharacter.element = newValue as! String
//    case "weapon":
//        changeObj.NSCharacter.weapon = newValue as! String
//    case "mainRole":
//        changeObj.NSCharacter.mainRole = newValue as! String
//    case "ascension":
//        changeObj.NSCharacter.ascension = newValue as! String
//    case "baseHP":
//        changeObj.NSCharacter.baseHP = Int32("\(newValue)")!
//    case "baseATK":
//        changeObj.NSCharacter.baseATK = Int32("\(newValue)")!
//    case "baseDEF":
//        changeObj.NSCharacter.baseDEF = Int32("\(newValue)")!
//    case "rating":
//        changeObj.NSCharacter.rating = Double("\(newValue)")!
//    default:
//        return false
//    }
//    do {
//        try context.save()
//        print("Changing data finished")
//        return true
//    } catch {
//        print("Changing data Failed")
//        return false
//    }
//}


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

