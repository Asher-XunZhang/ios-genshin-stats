//
//  ModelController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 11/4/21.
//

import Foundation
import UIKit

struct LevelModifyRecord{
    var BaseHP: Int
    var BaseATK:Int
    var BaseDEF:Int
    
    init(hp: Int, atk: Int, def: Int) {
        BaseHP = hp
        BaseATK = atk
        BaseDEF = def
    }
}


struct CharacterItem {
    var name : String{
        didSet{
            isNameChanged = true
        }
    }
    var rarity : CharacterRarity
    var avatar : Data
    var rating: Double = 0
    var role : String
    var data : [SCharacter]
    var weapon : String
    var comment : String
    var element : String
    var ascension : String
    var isNameChanged = false
    init(_ initdata: [SCharacter]) {
        let info = initdata[initdata.startIndex]
        name = info.name
        rarity = CharacterRarity.get(info.rarity)
        role = info.mainRole
        data = initdata
        avatar = info.avatar
        rating = info.rating
        weapon = info.weapon
        comment = info.comment
        element = info.element
        ascension = info.ascension
    }
    
    init(new:Bool){
        let levels: [Float] = [1,
                               20, 20.5,
                               40, 40.5,
                               50, 50.5,
                               60, 60.5,
                               70, 70.5,
                               80, 80.5,
                               90]
        var SCharacters: [SCharacter] = []
        for level in levels {
            var scharacter = SCharacter(sync: true)
            scharacter.level = level
            scharacter.save()
            SCharacters.append(scharacter)
        }
        self.init(SCharacters)
    }
    
    func save() -> (success: Bool, msg: String?){
        print(name)
        if isNameChanged, let list = Genshin_Stater.characterList, list.contains(self.name){
            return (false, "Duplicated character name, please change or edit in the existing character.")
        }else{
            let success = data.reduce(into: [true, "Success"], {res, curr in
                if res[0] as! Bool{
                    curr.name = self.name
                    curr.rating = self.rating
                    curr.mainRole = self.role
                    curr.rarity = self.rarity.value()
                    curr.avatar = self.avatar
                    curr.weapon = self.weapon
                    curr.comment = self.comment
                    curr.element = self.element
                    curr.ascension = self.ascension
                    if !curr.save() {
                        res[0] = false
                        res[1] = "Error when save \(curr.name) at level \(curr.level)"
                    }
                }
            })
            return (success[0] as! Bool, success[1] as? String)
        }
    }
}

class CharacterContainer {
    var characters : [CharacterItem] = []
    
    init() {
        Genshin_Stater.exportDataFromCoreData().forEach{ char in
            characters.append(CharacterItem(char))
        }
    }
    
    func reload(){
        characters = []
        Genshin_Stater.exportDataFromCoreData().forEach{ char in
            characters.append(CharacterItem(char))
        }
    }
}
