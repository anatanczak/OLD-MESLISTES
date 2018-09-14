import UIKit
import RealmSwift

class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - GLOBAL VARIABLES
    var currentItem: Item?
    let realm = try! Realm()
    let imagePicker = UIImagePickerController()
    //var addedImage: UIImage?
    var arrayOfImagesFromRealm = [UIImage]()
    
    //MARK: - OUTLETS
    @IBOutlet weak var doneButtonPressed    : UIButton!
    @IBOutlet weak var nameLabel            : UILabel!
    @IBOutlet weak var textView             : UITextView!
    
    
    //MARK: - IBACTIONS
    @IBAction func doneButtonPressed(_ sender: Any) {
        if doneButtonPressed.titleLabel?.text == "Save"{
        saveUserInput()
        dismiss(animated: true, completion: nil)
        } else {
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    func getNewNameForImage() -> String {
        //!!! check for the same names
        let randomInt = arc4random_uniform(30000000)
        
        let random = String(randomInt)
    
        return random
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {

    }
    
    //MARK: - VEIW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
        textView.text = currentItem?.noteInput ?? ""
        
        //Array of names
        var names: [String] = []
        //Array of positions
        var positions: [Int] = []
        //iterate over array/list of imageObjects(if there are any) and fill in arrays names and positions
        for imageObject in (currentItem?.imageObjects)! {
            names.append(imageObject.name)
            positions.append(imageObject.position)
        }
        
        
        let images = NoteStorageManager.shared.getImageForNoteItemName(noteName: (currentItem?.title)!, imagesNames: names)
        
       self.insertImagesToTextAndGetPosition(images: images, positions: positions)
        print("\(images)")
        
        
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
 
    ///saves images to realm
    
    func saveImagesToRealm (_ imageObject: NoteImageObject) {
        if let selectedItem = currentItem {
            do {
                try realm.write {
                    selectedItem.imageObjects.append(imageObject)
                }
            } catch {
                print("error updating realm\(error)")
            }
        }
    }
    
    //MARK: - WORKING WITH CAMERA AND IMAGES
    
//    func openCamera(){
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = false
//            imagePicker.delegate = self
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        else{
//            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
    //Choose image from camera roll
    func openPhotoLibrary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // retrieve image from the picker
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            /* Append image to text view. */
            let position = self.attachImagesToTextAndGetPosition(image: originalImage)
           
            
            /* Will be going in background... */
            let name = getNewNameForImage()
            NoteStorageManager.shared.saveImage(the: originalImage,
                                                called: name,
                                                noteName: currentItem?.title ?? "NewNote")
            
            let noteImageObject = NoteImageObject()
            noteImageObject.name = name
            noteImageObject.position = position
            saveImagesToRealm(noteImageObject)
            /* ..... */
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker Cancelled")
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    /// save the image to the documents directory
//    func saveImage(the imageToSave: UIImage, called imageName: String) {
//
//        //creates an instance of the FileManager
//        let fileManager = FileManager.default
//
//        //get the image path
//        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
//
//        //get the image we took with camera
//        let image = addedImage
//        let orientedImage = image!.upOrientationImage()
//
//        //get the PNG data for this image
//        let data = UIImagePNGRepresentation(orientedImage!)
//
//        //store it in the document directory
//        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
//    }
    
//    func getImagesAndPutThemInArray () {
//        /*
//        let fileManager = FileManager.default
//        if let selectedItem = currentItem {
//            for nameOfImage in selectedItem.imagenames {
//                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(nameOfImage)
//                if fileManager.fileExists(atPath: imagePath){
//                    let newImage = UIImage(contentsOfFile: imagePath)
//                    arrayOfImagesFromRealm.append(newImage!)
//                    //arrayOfImageNamesFromRealm.append(nameOfImage)
//
//                    print("-->gettingImagesFromRealm\(arrayOfImageNamesFromRealm)\(arrayOfImagesFromRealm)")
//                }else{
//                    print("Panic! No Image!")
//
//                }
//                print(nameOfImage)
//            }
//        }*/
//    }
 
    func attachImagesToTextAndGetPosition(image: UIImage) -> Int{
        
        let fullStringFromTextView = textView.text!
        
        let fullString = NSMutableAttributedString(string: fullStringFromTextView)
        
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = image
        
        let newWidth = self.view.bounds.size.width - 10
        let newHeight = ((image1Attachment.image?.size.height)! * newWidth)/(image1Attachment.image?.size.width)!
        
        image1Attachment.bounds = CGRect(x: 0, y: image1Attachment.bounds.origin.y, width: newWidth, height: newHeight)
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        textView.attributedText = fullString
        
        return fullStringFromTextView.count
    }
    
    func insertImagesToTextAndGetPosition(images: [UIImage], positions: [Int]) -> Int{
        
        let fullStringFromTextView = textView.text!
        
        let fullString = NSMutableAttributedString(string: fullStringFromTextView)
        
        for image in images {
            let index = images.index(of: image)!
            
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = image
            
            let newWidth = self.view.bounds.size.width - 10
            let newHeight = ((image1Attachment.image?.size.height)! * newWidth)/(image1Attachment.image?.size.width)!
            
            image1Attachment.bounds = CGRect(x: 0, y: image1Attachment.bounds.origin.y, width: newWidth, height: newHeight)
            
            let image1String = NSAttributedString(attachment: image1Attachment)
            fullString.insert(image1String, at: positions[index])
        }

        textView.attributedText = fullString
        
        return fullStringFromTextView.count
    }
    
    // attaching an image to the text
//    func attachImagesToText () {
//
//        let fullStringFromTextView = textView.text!
//
//        let fullString = NSMutableAttributedString(string: textView.text!)
//
//        let image1Attachment = NSTextAttachment()
//        image1Attachment.image = arrayOfImagesFromRealm[0]
//        print()
//
//        let newWidth = self.view.bounds.size.width - 10
//        let newHeight = ((image1Attachment.image?.size.height)! * newWidth)/(image1Attachment.image?.size.width)!
//
//        image1Attachment.bounds = CGRect(x: 0, y: image1Attachment.bounds.origin.y, width: newWidth, height: newHeight)
//
//        let image1String = NSAttributedString(attachment: image1Attachment)
//        fullString.append(image1String)
//        textView.attributedText = fullString
//    }
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
        //getCursor()
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
    
//    func getCursor () {
//        let startPosition: UITextPosition = textView.beginningOfDocument
//        let endPosition: UITextPosition = textView.endOfDocument
//        let selectedRange: UITextRange? = textView.selectedTextRange
//
//        if let selectedRange = textView.selectedTextRange {
//            let cursorPosition = textView.offset(from: startPosition, to: selectedRange.start)
//
//            print("-->CursorPosition is\(cursorPosition)")
//        }
//    }
}
extension UIImage {
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
