//
//  NoteViewController.swift
//  Mes Listes
//
//  Created by Anastasiia Tanczak on 04/07/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentItem: Item?
    let realm = try! Realm()
    let imagePicker = UIImagePickerController()
    var addedImage: UIImage?
    
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        saveUserInput()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true , completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func fontButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        openPhotoLibrary()
    }
    
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        openCamera()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
        textView.text = currentItem?.noteInput ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.updateTextView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        self.view.endEditing(true)
        textView.resignFirstResponder()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        // what happens when the user touches the textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // what happens when the user finishes editing the textView
    }
    
    // makes text in a textview not to hide behind the keyboard
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
    
    //MARK: - Open the camera
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
    
    //MARK: - Choose image from camera roll
    func openPhotoLibrary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // retrieves image from the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            addedImage = originalImage
            //write what to do whith the image
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
    }
    
    // saves the image to the documents directory, converts  and saves it to realm
    func saveImage (the imageToSave: UIImage, called imageName: String) {
        //creates an instance of the FileManager
        let fileManager = FileManager.default
        
    }
}


