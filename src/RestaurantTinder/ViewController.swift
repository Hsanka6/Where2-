//
//  ViewController.swift
//  RestaurantTinder
//
//  Created by ganga sanka on 12/28/16.
//  Copyright © 2016 haasith. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController
{

    var loginButton = FBSDKLoginButton()
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    @IBAction func fbButton(_ sender: Any) {
        
        
        indicator.isHidden = false
        indicator.startAnimating()
        
        let facebook = FBSDKLoginManager()
        
        
        facebook.logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: self) { (result,error) in
            if error != nil{
                print("fail")
            }
            else if result?.isCancelled == true{
                print("cancelled")
            }
            else
            {
                
                print("logged in")
                self.performSegue(withIdentifier: "ToSearch", sender: self)
                
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                self.indicator.stopAnimating()
            }
            
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ugh")
        indicator.isHidden = true
        
        
    }
    
    
    
    
    func firebaseAuth(_ credential: FIRAuthCredential)
    {
        FIRAuth.auth()?.signIn(with: credential, completion:{ (user, error) in
            if error != nil
            {
                print("fail")
                print(error.debugDescription)
            }
            else
            {
                
                print("success")
                
                var email = user?.email as String!
                var name = user?.displayName as String!
                var url = user?.photoURL?.absoluteString
                
                guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
                
                
                let values = ["email": email!, "name": name!, "profileImageUrl": url!] as [String : Any]
                
                var userReference = FIRDatabase.database().reference().child("users").child(uid)
                
                
                userReference.setValue(values)

            }
         })
    }
    
    
    
    

    
}

extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


