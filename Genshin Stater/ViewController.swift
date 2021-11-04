//
//  ViewController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 10/26/21.
//

import UIKit
import DropDown

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
}

class CharacterContainer {
    var characters : [CharacterItem] = []
    
    init() {
        Genshin_Stater.exportDataFromCoreData().forEach{ char in
            characters.append(CharacterItem(char))
        }
    }
}

class CharacterViewController: UITableViewController {
    var content = CharacterContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        self.navigationItem.rightBarButtonItem=self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.characters.count
    }
    
    @IBAction func onAddBtnAction(_ sender: UIBarButtonItem) {
        content.characters.insert(CharacterItem(new: true), at: .zero)
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        if let containerView = tableView.footerView(forSection: 0) {
            containerView.textLabel!.text = "Total \(content.characters.count) characters in Genshin Impact."
            containerView.sizeToFit()
        }
        tableView.reloadData()
        self.performSegue(withIdentifier: "AddNewCharacter", sender: self)
    }
    
    //TODO: Fix the characters' border raduis when delete
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterGeneral", for: indexPath) as! CharacterCell
        let item = content.characters[indexPath.row]
        cell.characterName.text = item.name
        cell.characterRarity.image = UIImage(named: "star_\(item.rarity.value())")
        cell.characterRarity.clipsToBounds = true
        cell.characterRarity.contentMode = .scaleAspectFit
        cell.charavterRating.text = String(format: "%01.1f", 0.0)
        cell.characterImage.image = UIImage(named: item.name)
        cell.characterImage.clipsToBounds = true
        cell.characterImage.contentMode = .scaleAspectFit
        cell.characterRole.text = item.role
        
        switch item.rarity {
            case .Special:
                cell.backgroundColor = UIColor(named: "pink")?.withAlphaComponent(0.9)
                cell.characterName.textColor = .white
                cell.characterRole.textColor = .white
                cell.charavterRating.textColor = .white
                
            case .Four:
                cell.backgroundColor = UIColor(named: "purple")?.withAlphaComponent(0.9)
                cell.characterName.textColor = .white
                cell.characterRole.textColor = .white
                cell.charavterRating.textColor = .white
                
            case .Five:
                cell.backgroundColor = UIColor(named: "gold")?.withAlphaComponent(0.9)
                cell.characterName.textColor = .darkText
                cell.charavterRating.textColor = .darkText
                cell.characterRole.textColor = .darkText
                cell.tintColor = .darkGray
        }
        
        cell.layer.borderColor = UIColor.darkText.cgColor
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.selectionStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterDetailSegue" {
            let controller = segue.destination as! CharacterDetailController
        }else if segue.identifier == "AddNewCharacter" {
            let from = sender as! CharacterViewController
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alertWithConfrim(title: "Delete Confitm", msg: "Do you want to delete?", callback:{
                action in
                if self.content.characters[self.content.characters.index(self.content.characters.startIndex, offsetBy: indexPath.row)].data.reduce(true, {res, char in
                    res && deleteDataFromCoreData(char)
                }){
                    self.content.characters.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection
                            section: Int) -> String? {
        return "Total \(self.content.characters.count) characters in Genshin Impact."
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CharacterDetailSegue", sender: self)
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
            frame.origin.x += 20
            frame.size.height -= 5
            frame.size.width -= 2 * 20
            super.frame = frame
        }
    }
}

class CharacterDetailController : UIViewController {
    var data : CharacterItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterDetailSegue" {
            let controller = segue.destination as! CharacterDetailController
        }else if segue.identifier == "AddNewCharacter" {
            print("Adding new character...")
            let from = sender as! CharacterViewController
        }
        
        if segue.identifier == "leveldetial" {
            let controller = segue.destination as! CharacterLevelController
        }
    }
}

class CharacterLevelController : UIViewController {
    let level : DropDown = {
        let level = DropDown()
        level.dataSource = ["Level 10", "Lev"]
        return level
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let rootView = UIView(frame: navigationController?.navigationBar.frame ?? .zero)
    }
}
