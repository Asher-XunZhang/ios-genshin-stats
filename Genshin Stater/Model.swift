//
//  ViewController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 10/26/21.
//

import UIKit
import CoreData

class SCharacter: CustomStringConvertible{
    var NSCharacter: Character!
    var name = ""
    var level = 0
    var rarity = 0
    var element = ""
    var weapon = ""
    var mainRole = ""
    var ascension = ""
    var baseHP = 0
    var baseATK = 0
    var baseDEF = 0
    var rating: Double = 0.0
    
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
            var newSCharacter = SCharacter()
            newSCharacter.NSCharacter = (data as! Character)
            newSCharacter.name = data.value(forKey: "name") as! String
            if let num = data.value(forKey: "level") as? NSNumber {
                newSCharacter.level = num.intValue
            }
            if let num = data.value(forKey: "rarity") as? NSNumber {
                newSCharacter.rarity = num.intValue
            }
            newSCharacter.element   = data.value(forKey: "element") as! String
            newSCharacter.weapon    = data.value(forKey: "weapon") as! String
            newSCharacter.mainRole  = data.value(forKey: "mainRole") as! String
            newSCharacter.ascension = data.value(forKey: "ascension") as! String
            if let num = data.value(forKey: "baseHP") as? NSNumber {
                newSCharacter.baseHP = num.intValue
            }
            if let num = data.value(forKey: "baseATK") as? NSNumber {
                newSCharacter.baseATK = num.intValue
            }
            if let num = data.value(forKey: "baseDEF") as? NSNumber {
                newSCharacter.baseDEF = num.intValue
            }
            if let num = data.value(forKey: "rating") as? NSNumber {
                newSCharacter.rating = num.doubleValue
            }
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

