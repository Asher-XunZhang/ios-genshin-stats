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
        data.append(initdata)
    }
    
    init(){
        let temp = SCharacter()
        name = temp.name
        rarity = CharacterRarity.get(temp.rarity)
        role = temp.mainRole
        data.append(temp)
//        if addDataToCoreData(temp) {
//            data.append(temp)
//        }
    }
}

class CharacterContainer {
    var characters : [String: CharacterItem] = [:]
    var indexRef : [Int: String] = [:]
    
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
    
    func createNewCharacter(){
        // TODO: Need fix the string
        var newItem = CharacterItem()
        self.indexRef.values.forEach { v in
            if v.contains(newItem.name){
                let index = v.suffix(1)
                if let i = Int(index) {
                    newItem.name.append("\(i)")
                }else{
                    newItem.name.append("0")
                }
            }else{
                newItem.name.append("0")
            }
        }
        characters["\(newItem.name)"] = newItem
        
        // add to the table
        if !indexRef.isEmpty {
            indexRef[characters.count - 1] = indexRef[0]
            indexRef[0] = newItem.name
        }else{
            self.indexRef[0] = newItem.name
        }
    }
    
    func deleteCharacter(index: Int)->Bool{
        if let key = indexRef[index],
            let c = characters.index(forKey: key),
            let i = indexRef.index(forKey: index)
        {
            characters.remove(at: c)
            indexRef.remove(at: i)
            return true
        }
        
        return false
    }
}

class MainViewController : UIViewController {
    var tableView : CharacterViewController!
    @IBOutlet var editBtn : UIButton!
    
    @IBAction func toggleEdit(){
        if tableView.isEditing{
            editBtn.setTitle("Edit", for: .normal)
            editBtn.setTitleColor(.black, for: .normal)
            tableView.setEditing(!tableView.isEditing, animated: true)
        }else{
            editBtn.setTitle("Done", for: .normal)
            editBtn.setTitleColor(UIColor.init(named: "red"), for: .normal)
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
        //TODO: add deletate for remove action
    }
    
    @IBAction func create(){
        self.tableView.tableView.beginUpdates()
        tableView.content.createNewCharacter()
        self.tableView.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        if let containerView = tableView.tableView.footerView(forSection: 0) {
            containerView.textLabel!.text = "Total \(self.tableView.content.indexRef.count) characters in Genshin Impact."
            containerView.sizeToFit()
        }
        self.tableView.tableView.endUpdates()
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
                cell.backgroundColor = UIColor(named: "pink")?.withAlphaComponent(0.9)
                cell.characterName.textColor = .white
                cell.characterRole.textColor = .systemGray
                cell.charavterRating.textColor = .white
                
            case .Four:
                cell.backgroundColor = UIColor(named: "purple")?.withAlphaComponent(0.9)
                cell.characterName.textColor = .white
                cell.characterRole.textColor = .systemGray
                cell.charavterRating.textColor = .white
                
            case .Fire:
                cell.backgroundColor = UIColor(named: "gold")?.withAlphaComponent(0.9)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            if content.deleteCharacter(index: indexPath.row){
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
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
            frame.origin.x += 20
            frame.size.height -= 5
            frame.size.width -= 2 * 20
            super.frame = frame
        }
    }
    
    
}

