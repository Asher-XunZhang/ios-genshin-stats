import UIKit
import CoreData

enum CharacterRarity{
    case Four
    case Fire
    case Special

    static func get(_ r: Int) -> CharacterRarity{
        switch r {
        case 4:
            return .Four
        case 5:
            return .Fire
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
        case .Fire:
            return 5
        case .Special:
            return 6
        }
    }
}

class SCharacter: CustomStringConvertible{
    var NSCharacter:Character
    var name:String
    var level:Int
    var rarity:Int
    var element:String
    var weapon:String
    var mainRole:String
    var ascension:String
    var baseHP: Int
    var baseATK: Int
    var baseDEF: Int
    var rating:Double

    init(){
        self.NSCharacter = Character()
        self.name = "Undefined"
        self.level = 0
        self.rarity = 0
        self.weapon = "Undefined"
        self.element = "Undefined"
        self.mainRole = "Undefined"
        self.ascension = "Undefined"
        self.baseHP = 0
        self.baseDEF = 0
        self.baseATK = 0
        self.rating = 0.0
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
    }

    
    public var description: String{
        return String("[name:\(name)\tlevel:\(level)\trarity:\(rarity)\telement:\(element)\tweapon:\(weapon)\tmainRole:\(mainRole)\tascension:\(ascension)\tbaseHP:\(baseHP)\tbaseATK:\(baseATK)\tbaseDEF:\(baseDEF)\trating:\(rating)]")
    }
}

func importDataToCoreData(_ csvName: String){
    let filepath = Bundle.main.path(forResource: csvName, ofType: "csv")
    if let content = try? String(contentsOfFile:filepath!, encoding: String.Encoding.utf8){
        var lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
        lines.removeFirst()
        lines = lines.filter({$0 != ""})
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        print("Reset Core Data...")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There is an error in deleting records")
        }
        
        print("Saving Data..")
        for line in lines{
            let values = line.split(separator: ",")
            let newCharacter  = Character(context: context)
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
            do {
                try context.save()
                print("Storing data finished")
            } catch {
                print("Storing data Failed")
            }
        }
    }
}

func exportDataFromCoreData()-> [SCharacter]{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    var SCharacters:[SCharacter] = []
    print("Fetching Data..")
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Character")
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            var newSCharacter = SCharacter(character: (data as! Character))
            SCharacters.append(newSCharacter)
        }
        print("Fetching data finished")
    } catch {
        print("Fetching data Failed")
    }
    return SCharacters
}

func addDataToCoreData(_ characterP:SCharacter)->Bool{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    characterP.NSCharacter = Character(context: context)
    characterP.NSCharacter.name = characterP.name
    characterP.NSCharacter.level = Int32("\(characterP.level)")!
    characterP.NSCharacter.rarity  = Int32("\(characterP.rarity)")!
    characterP.NSCharacter.element = characterP.element
    characterP.NSCharacter.weapon  = characterP.weapon
    characterP.NSCharacter.mainRole = characterP.mainRole
    characterP.NSCharacter.ascension = characterP.ascension
    characterP.NSCharacter.baseHP  = Int32("\(characterP.baseHP)")!
    characterP.NSCharacter.baseATK = Int32("\(characterP.baseATK)")!
    characterP.NSCharacter.baseDEF = Int32("\(characterP.baseDEF)")!
    characterP.NSCharacter.rating = characterP.rating
    do {
        try context.save()
        print("Adding data finished")
        return true
    } catch {
        print("Adding data Failed")
        return false
    }
}


func deleteDataFromCoreData(_ deleteObj: SCharacter)->Bool{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    context.delete(deleteObj.NSCharacter)
    do {
        try context.save()
        print("Deleting data finished")
        return true
    } catch {
        print("Deleting data Failed")
        return false
    }
}

func changeDataFromCoreData(_ changeObj: SCharacter, newValue:Any, forKey:String)->Bool{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    switch(forKey){
    case "character":
        changeObj.NSCharacter.name = newValue as! String
    case "level":
        changeObj.NSCharacter.level = Int32("\(newValue)")!
    case "rarity":
        changeObj.NSCharacter.rarity = Int32("\(newValue)")!
    case "element":
        changeObj.NSCharacter.element = newValue as! String
    case "weapon":
        changeObj.NSCharacter.weapon = newValue as! String
    case "mainRole":
        changeObj.NSCharacter.mainRole = newValue as! String
    case "ascension":
        changeObj.NSCharacter.ascension = newValue as! String
    case "baseHP":
        changeObj.NSCharacter.baseHP = Int32("\(newValue)")!
    case "baseATK":
        changeObj.NSCharacter.baseATK = Int32("\(newValue)")!
    case "baseDEF":
        changeObj.NSCharacter.baseDEF = Int32("\(newValue)")!
    case "rating":
        changeObj.NSCharacter.rating = Double("\(newValue)")!
    default:
        return false
    }
    do {
        try context.save()
        print("Changing data finished")
        return true
    } catch {
        print("Changing data Failed")
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
    print("Fetching Data..")
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
