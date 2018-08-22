//
//  NoteStorageManager.swift
//  Mes Listes
//
//  Created by 1 on 22/08/2018.
//  Copyright © 2018 Ana Viktoriv. All rights reserved.
//

import Foundation
import UIKit

class NoteStorageManager: NSObject {
    
    static let shared = NoteStorageManager()
    
    private let imagesDirectoryName: String = "NotesImages"
    
    private override init() {
        super.init()
    }
    
    // MARK: - Manager public  interface
    
    /*
    func saveRequestLog(urlString: String) {
        
        let file = "\(Date.stringDateForUploading(date: Date())).txt"
        let text = "\n" + urlString
        
        if let dir = getDirectoryForSavingRequestsLogs() {
            let fileURL = dir.appendingPathComponent(file)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    let fileHandle = try FileHandle(forWritingTo: fileURL)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(text.data(using: .utf8)!)
                    fileHandle.closeFile()
                }
                catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }*/

    func getImageForNoteItemName(noteName: String, imagesNames: [String]) -> [UIImage] {
        
        let fileManager = FileManager.default
       
        var images: [UIImage] = []
      
        for name in imagesNames {
            let imagePath = self.getDirectoryForSavingImages(directoryName: noteName)?.appendingPathComponent("\(name).jpg").path ?? ""
            if fileManager.fileExists(atPath: imagePath){
                images.append(UIImage(contentsOfFile: imagePath)!)
            } else {
                print("No Image")
            }
        }
        
        return images
    }
    
    /// save the image to the documents directory
    func saveImage(the imageToSave: UIImage, called imageName: String, noteName: String) {

        // get the documents directory url
        let documentsDirectory = self.getDirectoryForSavingImages(directoryName: noteName)
        
        // choose a name for your image
        let fileName = "\(imageName).jpg"
        
        // create the destination file url to save your image
        if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = UIImageJPEGRepresentation(imageToSave, 1.0),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("file saved")
                } catch {
                    print("error saving file:", error)
                }
            }
        }
    }
    
    // MARK: - Manager private  interface
    private func getDirectoryForSavingImages(directoryName: String) -> URL? {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if var pathComponent = url.appendingPathComponent(imagesDirectoryName){
            pathComponent.appendPathComponent(directoryName)
            
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath) {
                return pathComponent
            } else {
                let requestsLogsDirectoryPath = prepareAndGetImagesDirectory(directoryName: directoryName)
                return requestsLogsDirectoryPath
            }
        } else {
            let requestsLogsDirectoryPath = prepareAndGetImagesDirectory(directoryName: directoryName)
            return requestsLogsDirectoryPath
        }
    }
    
    private func prepareAndGetImagesDirectory(directoryName: String) -> URL? {
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let directoryURL = docsURL.appendingPathComponent(imagesDirectoryName).appendingPathComponent(directoryName)
        let newDir = directoryURL.path
        
        do {
            try filemgr.createDirectory(atPath: newDir,
                                        withIntermediateDirectories: true, attributes: nil)
            return directoryURL
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
}
