//
//  AppUser.swift
//  LetsTeamApp
//
//  Created by admin on 8/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase
class AppUser {
    static let currentUser = AppUser()
    
    var name : String?
    var email : String?
    var pass : String?
    var uid: String?
    
    var isLoggedIn = false
    
    func isLoggedIn(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
            completion(true)
        }else{
            isLoggedIn = false
            completion(false)
        }
    }
    
    func setUserFromFB(snapshot : DataSnapshot) {
        if let userDict = snapshot.value as? [String:Any]{
            name = userDict["name"] as? String
            uid = snapshot.key
            email = userDict["email"] as? String
            pass = userDict["password"] as? String
        }
    }
    
    
    
    func onSignOut(){
        name = nil
        email = nil
        pass = nil
        uid = nil
        
        try! Auth.auth().signOut()
    }
}
