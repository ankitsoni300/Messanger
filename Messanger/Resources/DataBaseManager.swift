//
//  DataBaseManager.swift
//  Messanger
//
//  Created by imart on 22/09/20.
//  Copyright © 2020 imart. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager: NSObject {
    
    static let shared : DataBaseManager = {
       let shared = DataBaseManager()
       return shared
    }()
    
    private let dbObj = Database.database().reference()
    
    /// creating new user
    public func insertUser(model : UserData){
        guard let email = model.safeEmail else {
            return
        }
        self.dbObj.child(email).setValue(["firstName":model.userFirstName, "lastName" : model.userLastName])
    }
    
    ///Validate User
    public func validateUser(with email : String, completion : @escaping ((Bool) -> (Void))){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        self.dbObj.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            
            guard snapshot.exists() else {
                completion(false)
                return
            }
            
            completion(true)
           
        }
        
    }
    
}

struct UserData{
    
    let userFirstName : String?
    let userLastName : String?
    var userEmail : String?
   // let profilePicture : String?
    
    var safeEmail : String?{
        var safeEmail = userEmail?.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail?.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
