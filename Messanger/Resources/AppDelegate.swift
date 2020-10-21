// Swift
//
// AppDelegate.swift

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "169586301956-hiukv93516elte20mldlq7o81ug3bt04.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let user = user else {
            return
        }
        
        guard let email = user.profile.email, let familyName = user.profile.familyName, let givenName = user.profile.givenName, let profileUrl = user.profile.imageURL(withDimension: 200) else{
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        UserDefaults.standard.set(email, forKey: "email")
        
        DataBaseManager.shared.validateUser(with: email) { (exists) -> (Void) in
            if !(exists){
                
                let chatUser = UserData(userFirstName: givenName, userLastName: familyName, userEmail: email)
                guard let fileName = chatUser.profilePicture else{
                    return
                }
                
                DataBaseManager.shared.insertUser(model: chatUser, completion: { result in
                    if result{
                        
                        URLSession.shared.dataTask(with: profileUrl) { (data, urlResponse, error) in
                            //upload image
                            guard let data = data else{
                                return
                            }
                            StorageManager.instance.uploadProfilePicToFirebase(data: data, fileName: fileName, completion: { result in
                                switch result{
                                case .success(let downloadUrl):
                                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                    print("url")
                                case .failure(let error):
                                    print("Storage maanger error: \(error)")
                                }
                            })
                        }
                        
                    }
                })
            }
        }
        
        Auth.auth().signIn(with: credential) { (result, error) in
            guard result != nil, error == nil else{
                print("Google credentials fail")
                return
            }
            
            print("Login Successfully")
            //Send Notification
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        guard let error = error, let user = user else {
            return
        }
        
        print(error)
        print(user)
    }
    
}


