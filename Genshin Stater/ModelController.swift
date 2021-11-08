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
    var isNameChanged = false
    init(_ initdata: [SCharacter]) {
        let info = initdata[initdata.startIndex]
        name = info.name
        rarity = CharacterRarity.get(info.rarity)
        role = info.mainRole
        data = initdata
        avatar = info.avatar
        rating = info.rating
    }
    
    init(new:Bool){
        self.init([SCharacter(sync: false)])
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
