//
//  StorageManager.swift
//  Messanger
//
//  Created by Ankit Soni on 16/10/20.
//  Copyright © 2020 imart. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static var instance : StorageManager {
        let shared = StorageManager()
        return shared
    }
    
    let storageReference = Storage.storage().reference()
    
    ///upload profile pic data to firebase, then get url string then return that url string
    
    public func uploadProfilePicToFirebase(data : Data, fileName : String, completion : @escaping ((Result<String,Error>)->(Void))){
        
        self.storageReference.child("/image\(fileName)").putData(data, metadata: nil) { (_, error) in
            guard error == nil else{
                print("Failed to upload data to firestore")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self.storageReference.child("/image\(fileName)").downloadURL { (url, error) in
                guard error == nil, let url = url else{
                    completion(.failure(StorageError.failedToGetUrl))
                    return
                }
                completion(.success(url.absoluteString))
            }
            
        }
        
    }
    
    public enum StorageError : Error {
        case failedToUpload
        case failedToGetUrl
    }
    
}


