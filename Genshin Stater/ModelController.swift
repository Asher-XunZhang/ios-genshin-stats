//
//  ModelController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 11/4/21.
//

import Foundation

struct CharacterItem {
    var name : String
    var rarity : CharacterRarity
    var rating: Double = 0
    var role : String
    var data : [SCharacter]
    init(_ initdata: [SCharacter]) {
        let info = initdata[initdata.startIndex]
        name = info.name
        rarity = CharacterRarity.get(info.rarity)
        role = info.mainRole
        data = initdata
    }
    
    init(new:Bool){
        self.init([SCharacter(sync: false)])
    }
    
    func save(){
        
    }
}

class CharacterContainer {
    var characters : [CharacterItem] = []
    
    init() {
        Genshin_Stater.exportDataFromCoreData().forEach{ char in
            characters.append(CharacterItem(char))
        }
    }
}
