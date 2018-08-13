//
//  NoteViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 04/07/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - GLOBAL VARIABLES
    var currentItem: Item?
    let realm = try! Realm()
    let imagePicker = UIImagePickerController()
    var addedImage: UIImage?
    var imageName = ""
    var arrayOfIamgesFromRealm = [UIImage]()

    //MARK: - OUTLETS
    @IBOutlet weak var doneButtonPressed: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK: - IBACTIONS
    @IBAction func doneButtonPressed(_ sender: Any) {
        if doneButtonPressed.titleLabel?.text == "Save"{
        saveUserInput()
        dismiss(animated: true, completion: nil)
        }else{
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        attachImagesToText()
    }
    
    @IBAction func fontButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        openPhotoLibrary()
    }
    
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        openCamera()
    }
    
    //MARK: - VEIW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
        textView.text = currentItem?.noteInput ?? ""
        
        getImagesAndPutThemInArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    //MARK: - REALM FUNCTIONS
    func saveUserInput () {
        if let selectedItem = currentItem {
            do {
                try realm.write {
                    selectedItem.noteInput = textView.text
                }
            }catch{
                print("error updating realm\(error)")
            }
        }
    }
    
    
    //save images to realm
    
    func saveImagesToRealm (_ nameofImage: String) {
        if let selectedItem = currentItem {
            do {
                try realm.write {
                    selectedItem.imagenames.append(nameofImage)
                }
            }catch{
                print("error updating realm\(error)")
            }
        }
    }
    
    //MARK: - WORKING WITH CAMERA AND IMAGES
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Choose image from camera roll
    func openPhotoLibrary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // retrieve image from the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            addedImage = originalImage
            
            imageName = randomAlphaNumericString(length: 10)
            
            if let selectedItem = currentItem {
                if selectedItem.imagenames.isEmpty == false {
                    if selectedItem.imagenames.contains(imageName){
                        imageName.append("12")
                    }
                }
            }
            saveImage(the: addedImage!, called: imageName)
            
            saveImagesToRealm(imageName)

            
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
    }
    
    // save the image to the documents directory
    func saveImage (the imageToSave: UIImage, called imageName: String) {
        
        //creates an instance of the FileManager
        let fileManager = FileManager.default
        
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = addedImage
        
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image!)
        
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)

    }
    
    func getImagesAndPutThemInArray () {
        let fileManager = FileManager.default
        if let selectedItem = currentItem {
            for nameOfImage in selectedItem.imagenames {
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(nameOfImage)
                if fileManager.fileExists(atPath: imagePath){
                    let newImage = UIImage(contentsOfFile: imagePath)
                    arrayOfIamgesFromRealm.append(newImage!)
                }else{
                    print("Panic! No Image!")
                    
                }
                print(nameOfImage)
            }
        }
    }
 
    // attaching an image to the text
    
    func attachImagesToText () {
        let fullString = NSMutableAttributedString(string: textView.text!)
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = arrayOfIamgesFromRealm[0]
        image1Attachment.setImageHeight(height: 230)
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        textView.attributedText = fullString

    }
    
    //MARK: - DIFFERENT METHODS
    // random name creator
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
}

//MARK: - TEXT METHODS
extension NoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // what happens when the user touches the textView
        print("save")
        doneButtonPressed.setTitle("Done", for: .normal)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // what happens when the user finishes editing the textView
        doneButtonPressed.setTitle("Save", for: .normal)
        getCursor()
    }
    
    // makes the text in a textview not to hide behind the keyboard
    @objc func updateTextView (notification: Notification){
        let userInfo = notification.userInfo!
        
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textView.contentInset = UIEdgeInsets.zero
        }else{
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    func getCursor () {
        let startPosition: UITextPosition = textView.beginningOfDocument
        let endPosition: UITextPosition = textView.endOfDocument
        let selectedRange: UITextRange? = textView.selectedTextRange
        
        if let selectedRange = textView.selectedTextRange {
            let cursorPosition = textView.offset(from: startPosition, to: selectedRange.start)
            
            print("-->CursorPosition is\(cursorPosition)")
        }
    }
    
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        //let width =
        
//        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
              //  bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: , height: height)
        //(bounds.origin.x, bounds.origin.y, ratio * height, height)
    }
}




