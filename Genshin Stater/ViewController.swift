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
        if let controller = segue.destination as? CharacterDetailController {
            if segue.identifier == "CharacterDetailSegue" {
                controller.updateData(data: sender as! CharacterItem)
            }else if segue.identifier == "AddNewCharacter" {
                controller.updateData(data: sender as! CharacterItem)
            }else{
                alert(title: "Error", msg: "Cannot open the currect page!")
            }
        }else{
            alert(title: "Error", msg: "Cannot open the detail page!")
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alertWithConfrim(title: "Delete Confitm", msg: "Do you want to delete?", callback:{ action in
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

class CharacterDetailController : UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var scrollView: UIScrollView!
    var saveOffsetForKeyBoard: CGPoint?
    
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
    var dataCopy: CharacterItem! //The copy of data

    var keyboardMarginY:CGFloat = 0
    var keyboardAnimitionDuration: TimeInterval = 0
    var viewDistanceFromTopScreen: CGFloat = 0
    var offsetDistance: CGFloat = 0



    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.levelPicker.delegate = self
        self.levelPicker.dataSource = self
        
        scrollView.keyboardDismissMode = .none

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        charName.text = data.name
        charRole.text = data.role
        charWeapon.text = data.data[data.data.startIndex].weapon
        charAvatar.image = UIImage(named: data.name)
        comments.text = data.data[data.data.startIndex].comment

        charRating.settings.fillMode = .half
        charRating.settings.disablePanGestures = true
        charRating.rating = data.rating
        charRating.didTouchCosmos = {
            rating in
            self.charRatingNum.text = String(rating)
        }
        
        charRatingNum.text = String(charRating.rating)
        charRarity.isEnabled = true
        switch data.rarity {
            case .Four:
                charRarity.selectedSegmentIndex = 0
            case .Five:
                charRarity.selectedSegmentIndex = 1
            case .Special:
                charRarity.selectedSegmentIndex = 2
        }

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

    func updateData(data:CharacterItem){
        self.data = data
    }
    
    

/// Start PickerView Functions.
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
/// End PickerView

    

/// Start keyboard event.
    @objc func touch(){
        self.view.endEditing(true)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func findViewThatIsFirstResponder(view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }

        for subView in view.subviews {
            if let hit = findViewThatIsFirstResponder(view: subView) {
                return hit
            }
        }

        return nil
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let scrollView = self.scrollView{

                var safeArea = self.view.frame
                safeArea.size.height -= scrollView.contentOffset.y
                safeArea.size.height -= keyboardSize.height
                safeArea.size.height -= view.safeAreaInsets.bottom

                let activeField: UIView? = findViewThatIsFirstResponder(view: view)

                if let activeField = activeField{
                    let activeFrameInView = view.convert(activeField.bounds, from: activeField)
                    let distance = activeFrameInView.maxY - safeArea.size.height
                    if distance > 0 {
                        if saveOffsetForKeyBoard == nil{
                            saveOffsetForKeyBoard = scrollView.contentOffset
                        }
                        scrollView.setContentOffset(CGPoint(x: 0, y: distance+20), animated: true)
                    }
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let restoreOffset = saveOffsetForKeyBoard else {
            return
        }
        if let scrollView = self.scrollView {
            scrollView.setContentOffset(restoreOffset, animated: true)
            self.saveOffsetForKeyBoard = nil
        }
    }
    /// End keyboard events and actions functions


}

//extension CharacterDetailController:UITextViewDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        scrollView.endEditing(true)
//        return true
//    }
//}
