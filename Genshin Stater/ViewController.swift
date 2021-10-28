//
//  ViewController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 10/26/21.
//

import UIKit

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

class Charcter {
    var name : String
    var rarity : CharacterRarity
    var rating : Float = 0.0
    
    init(name: String, rarity: Int) {
        self.name = name
        self.rarity = CharacterRarity.get(rarity)
    }
    
    convenience init(random : Bool) {
        if random {
            let name = ["Amber", "Barbara", "Bennett", "Fischl"]
            let r = [CharacterRarity.Fire , CharacterRarity.Four, CharacterRarity.Special]
            self.init(name: name.randomElement()!, rarity: r.randomElement()!.value())
            print(self)
        } else {
            self.init(name: "Template Character", rarity: 5)
        }
    }
}

class CharacterContainer {
    var characters = [Charcter]()
    
    init() {
        for _ in 1...40{
            add()
        }
    }
    
    @discardableResult func add() -> Charcter {
        let newCharacter = Charcter(random: true)
        self.characters.append(newCharacter)
        return newCharacter
    }
}

class CharacterViewController: UITableViewController {
    var content = CharacterContainer()
    var supposedHeight: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterGeneral", for: indexPath) as! CharacterCell
        let item = content.characters[indexPath.row]
        cell.characterName.text = item.name
        cell.characterRarity.image = UIImage(named: "star_\(item.rarity.value())")
        cell.characterRarity.clipsToBounds = true
        cell.characterRarity.contentMode = .scaleAspectFit
        cell.charavterRating.text = String(format: "%01.1f", item.rating)
        cell.characterImage.image = UIImage(named: item.name)
        cell.characterImage.clipsToBounds = true
        cell.characterImage.contentMode = .scaleAspectFit
        cell.characterRole.text = "N/A"
        
        switch item.rarity {
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

