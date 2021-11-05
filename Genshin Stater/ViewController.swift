//
//  ViewController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 10/26/21.
//

import UIKit
import DropDown
import Cosmos

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
        let newCharacter = CharacterItem(new: true)
        content.characters.insert(newCharacter, at: .zero)
        tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        if let containerView = tableView.footerView(forSection: 0) {
            containerView.textLabel!.text = "Total \(content.characters.count) characters in Genshin Impact."
            containerView.sizeToFit()
        }
        tableView.reloadData()
        self.performSegue(withIdentifier: "AddNewCharacter", sender: newCharacter)
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
        let controller = segue.destination as! CharacterDetailController
        
        if segue.identifier == "CharacterDetailSegue" {
            controller.updateData(data: sender as! CharacterItem)
        }else if segue.identifier == "AddNewCharacter" {
            controller.updateData(data: sender as! CharacterItem)
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
        self.performSegue(withIdentifier: "CharacterDetailSegue", sender: self.content.characters[indexPath.row])
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

class CharacterDetailController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var charName: UITextField!
    @IBOutlet weak var charRole: UITextField!
    @IBOutlet weak var charWeapon: UITextField!
    @IBOutlet weak var charBaseHP: UITextField!
    @IBOutlet weak var charBaseATK: UITextField!
    @IBOutlet weak var charBaseDEF: UITextField!
    @IBOutlet weak var charRating: CosmosView!
    @IBOutlet weak var charRatingNum: UILabel!
    @IBOutlet weak var charAvatar: UIImageView!
    @IBOutlet weak var charRarity: UISegmentedControl!
    @IBOutlet weak var levelPicker: UIPickerView!
    @IBOutlet weak var comments: UITextView!
    var pickerData: [String] = []
    
    var data : CharacterItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.levelPicker.delegate = self
        self.levelPicker.dataSource = self
        
        charName.text = data.name
        
        charRole.text = data.role
        
        charWeapon.text = data.data[data.data.startIndex].weapon
        comments.text = data.data[data.data.startIndex].comment
        
        charRating.settings.fillMode = .half
        charRating.settings.disablePanGestures = true
        charRating.rating = data.rating
        charRatingNum.text = String(charRating.rating)
        charRating.didTouchCosmos = {
            rating in
            self.charRatingNum.text = String(rating)
        }
        
        charRarity.isEnabled = true
        switch data.rarity {
            case .Four:
                charRarity.selectedSegmentIndex = 0
            case .Five:
                charRarity.selectedSegmentIndex = 1
            case .Special:
                charRarity.selectedSegmentIndex = 2
        }
        
        charAvatar.image = UIImage(named: data.name)
        
        data.data.forEach{
            char in
            let subStrList = String(char.level).split(separator: ".")
            var levelShow = String(subStrList[0])
            if subStrList[1] == "5" {
                levelShow += "+"
            }
            self.pickerData.append(levelShow)
        }
        charBaseHP.text = String(data.data[data.data.startIndex].baseHP)
        charBaseATK.text = String(data.data[data.data.startIndex].baseATK)
        charBaseDEF.text = String(data.data[data.data.startIndex].baseDEF)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterDetailSegue" {
            let controller = segue.destination as! CharacterDetailController
        }else if segue.identifier == "AddNewCharacter" {
            let from = sender as! CharacterViewController
        }
        if segue.identifier == "leveldetial" {
            let controller = segue.destination as! CharacterLevelController
        }
    }
    
    func updateData(data:CharacterItem){
        self.data = data
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        charBaseHP.text = String(data.data[row].baseHP)
        charBaseATK.text = String(data.data[row].baseATK)
        charBaseDEF.text = String(data.data[row].baseDEF)
    }
}

class CharacterLevelController : UIViewController {
    let level = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        level.anchorView = view
        level.dataSource = ["1", "2", "3", "4"]
        // Action triggered on selection
        level.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
        }
        level.direction = .bottom
//        level.show()
        
    }
}
