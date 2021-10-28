//
//  ViewController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 10/26/21.
//

import UIKit

struct CharacterItem {
    var name : String {
        didSet {
            data.forEach{ raw in
                raw.name = self.name
            }
        }
    }
    
    var rarity : CharacterRarity {
        didSet {
            data.forEach{ raw in
                raw.rarity = self.rarity.value()
            }
        }
    }
    
    var rating: Double = 0 {
        didSet {
            data.forEach{ raw in
                raw.rating = self.rating
            }
        }
    }
    var role : String {
        didSet {
            data.forEach{ raw in
                raw.mainRole = self.role
            }
        }
    }
    
    var data : [SCharacter] = []
    
    init(_ initdata: SCharacter) {
        name = initdata.name
        rarity = CharacterRarity.get(initdata.rarity)
        role = initdata.mainRole
    }
}

class CharacterContainer {
    var characters : [String: CharacterItem] = [:]
    var indexRef : [Int : String] = [:]
    
    init() {
        Genshin_Stater.exportDataFromCoreData().forEach{ char in
            if self.characters.contains(where: {$0.key == char.name}){
                self.characters[char.name]?.data.append(char)
            } else {
                self.characters[char.name] = CharacterItem(char)
                self.indexRef[characters.count - 1] = char.name
            }
        }
    }
}

class MainViewController : UIViewController {
    var tableView : CharacterViewController!
    @IBAction func toggleEdit(){
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CharacterViewController,
           segue.identifier == "CharacterTableSegue" {
            self.tableView = vc
        }
    }
}


class CharacterViewController: UITableViewController {
    var content = CharacterContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterGeneral", for: indexPath) as! CharacterCell
        let item = content.characters[content.indexRef[indexPath.row]!]
        cell.characterName.text = item?.name
        cell.characterRarity.image = UIImage(named: "star_\(item!.rarity.value())")
        cell.characterRarity.clipsToBounds = true
        cell.characterRarity.contentMode = .scaleAspectFit
        cell.charavterRating.text = String(format: "%01.1f", 0.0)
        cell.characterImage.image = UIImage(named: item!.name)
        cell.characterImage.clipsToBounds = true
        cell.characterImage.contentMode = .scaleAspectFit
        cell.characterRole.text = "N/A"
        
        switch item!.rarity {
            case .Special:
                cell.backgroundColor = UIColor(named: "pink")?.withAlphaComponent(0.8)
                cell.characterName.textColor = .white
                cell.characterRole.textColor = .systemGray
                cell.charavterRating.textColor = .white
                
            case .Four:
                cell.backgroundColor = UIColor(named: "purple")?.withAlphaComponent(0.8)
                cell.characterName.textColor = .white
                cell.characterRole.textColor = .systemGray
                cell.charavterRating.textColor = .white
                
            case .Fire:
                cell.backgroundColor = UIColor(named: "gold")?.withAlphaComponent(0.8)
                cell.characterName.textColor = .darkText
                cell.charavterRating.textColor = .darkText
                cell.characterRole.textColor = .darkGray
                cell.tintColor = .darkGray
        }
        
        cell.layer.borderColor = UIColor.darkText.cgColor
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.selectionStyle = .none
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection
                            section: Int) -> String? {
        return "Total \(self.content.indexRef.count) characters in Genshin Impact."
    }
}

class CharacterCell : UITableViewCell {
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var characterRarity : UIImageView!
    @IBOutlet var characterName : UILabel!
    @IBOutlet var characterRole : UILabel!
    @IBOutlet var charavterRating : UILabel!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 15
            frame.size.height -= 5
            frame.size.width -= 2 * 15
            super.frame = frame
        }
    }
}

