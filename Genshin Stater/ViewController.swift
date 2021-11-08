//
//  ViewController.swift
//  Genshin Stater
//
//  Created by KAMIKU on 10/26/21.
//

import UIKit
import DropDown
import Cosmos

extension UIImage {
    func isEmpty() -> Bool {
        return cgImage == nil && ciImage == nil
    }
}

class CharacterViewController: UITableViewController {
    var content = CharacterContainer()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func reloadAction(_ sender: UIBarButtonItem) {
        alertWithConfrim(title: "Warning", msg: "Do you want to load the template data? (All the data will be erased!)", callback: {res in
            importDataToCoreData("Genshin_Impact_All_Character_Stats")
            self.content.reload()
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem=self.editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(afterSaveAction), name: NSNotification.Name(rawValue: SAVE_DONE_NOTIFICATION_NAME), object: nil)
    }
    
    @objc func afterSaveAction(){
        content.reload()
        tableView.reloadData()
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
        cell.charavterRating.text = String(format: "%01.1f", item.rating)
        let avatar = UIImage(data: item.avatar)
        if let a = avatar, !a.isEmpty() {
            cell.characterImage.image = avatar
        }else{
            cell.characterImage.image = UIImage(data: Genshin_Stater.loadImage(imgName: item.name)!)
        }

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

class CharacterDetailController : UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    var saveOffsetForKeyBoard: CGPoint?
    var levelChangeList: [Int: LevelModifyRecord] = [:]

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
    var current : Int?
    var keyboardMarginY:CGFloat = 0
    var keyboardAnimitionDuration: TimeInterval = 0
    var viewDistanceFromTopScreen: CGFloat = 0
    var offsetDistance: CGFloat = 0
    
    @IBAction func loadImageFromLocal(_ sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(picker, animated: true, completion: {() -> Void in})
        }else{
            alert(title: "Error", msg: "Cannot open the photo library")
        }
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        //get the changed value to
        if data.name != charName.text {
            data.name = charName.text!
        }
        data.rarity = CharacterRarity.get({
            switch charRarity.selectedSegmentIndex{
                case 0:
                    return 4
                case 1:
                    return 5
                case 2:
                    return 6
                default:
                    return 4
            }
        }())
        data.role = charRole.text!
        data.rating = charRating.rating
        
        levelChangeList.forEach{ k, v in
            data.data[k].baseATK = v.BaseATK
            data.data[k].baseDEF = v.BaseDEF
            data.data[k].baseHP = v.BaseHP
        }
        
        //save the value to database
        let result = data.save()
        if !result.success {
            alert(title: "Error", msg: result.msg ?? "Unknown error")
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SAVE_DONE_NOTIFICATION_NAME), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func levelChangedAction(_ sender: UITextField) {
        if let curr = current{
            levelChangeList[curr] = LevelModifyRecord(hp: Int(charBaseHP.text!) ?? data.data[curr].baseHP, atk: Int(charBaseATK.text!) ?? data.data[curr].baseATK, def: Int(charBaseDEF.text!) ?? data.data[curr].baseDEF)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.levelPicker.delegate = self
        self.levelPicker.dataSource = self
        
        scrollView.keyboardDismissMode = .none

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 2
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        charName.text = data.name
        charRole.text = data.role
        charWeapon.text = data.data[data.data.startIndex].weapon
        comments.text = data.data[data.data.startIndex].comment

        let avatar = UIImage(data: data.avatar)
        if let a = avatar, !a.isEmpty() {
            charAvatar.image = avatar
        }else{
            charAvatar.image = UIImage(data: Genshin_Stater.loadImage(imgName: data.name)!)
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        Genshin_Stater.saveImage(img: pickedImage, name: self.data.name)
        picker.dismiss(animated: true, completion: {
            self.charAvatar.image = UIImage(data: Genshin_Stater.loadImage(imgName: self.data.name)!)
        })
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
        current = row
        if levelChangeList.keys.contains(row){
            charBaseHP.text = String(levelChangeList[row]?.BaseHP ?? data.data[row].baseHP)
            charBaseATK.text = String(levelChangeList[row]?.BaseATK ?? data.data[row].baseATK)
            charBaseDEF.text = String(levelChangeList[row]?.BaseDEF ?? data.data[row].baseDEF)
        }else{
            charBaseHP.text = String(data.data[row].baseHP)
            charBaseATK.text = String(data.data[row].baseATK)
            charBaseDEF.text = String(data.data[row].baseDEF)
        }
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
