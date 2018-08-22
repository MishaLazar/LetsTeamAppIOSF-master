//
//  LoginViewController.swift
//  LetsTeamApp
//
//  Created by admin on 7/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var btnLoginRegister: UIButton!
    @IBOutlet weak var LogoUiImageView: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var splashView: UIView!
    
    @IBOutlet weak var segLoginRegister: UISegmentedControl!
    
    var logoImg:UIImage = #imageLiteral(resourceName: "mainLogo")
    var refUsers: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.delegate = self
        txtName.delegate  = self
        txtPassword.delegate = self
        LogoUiImageView.image = logoImg
        refUsers = Database.database().reference().child("users");

        AppUser.currentUser.isLoggedIn { (isLogged) in
            if isLogged {
                self.refUsers.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snaps) in
                    AppUser.currentUser.setUserFromFB(snapshot: snaps)
                    self.switchToMainScreen()
                })
            }else {
                self.splashView.isHidden = true
                self.containerView.isHidden = false
                self.changeLoginRegisterInterfaceBySelectedSegment(self.segLoginRegister.selectedSegmentIndex)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Email":
            var email = self.txtEmail.text as? String ?? ""
            if !email.isValidEmail() {
                txtEmail.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            } else {
                txtEmail.backgroundColor = UIColor.white
            }
        case "Name":
            var name = self.txtName.text as? String ?? ""
            if name.count < 1 {
                txtName.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            } else {
                txtName.backgroundColor = UIColor.white
            }
        case "Password":
            var password = self.txtPassword.text as? String ?? ""
            if password.count < 5 {
                txtPassword.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            } else {
                txtPassword.backgroundColor = UIColor.white
            }
        default: break
            
        }
    }
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.placeholder {
        case "Email":
            var email = self.txtEmail.text as? String ?? ""
            if !email.isValidEmail() {
                txtEmail.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            } else {
                txtEmail.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            }
        case "Name":
            var name = self.txtName.text as? String ?? ""
            if name.count < 1 {
                txtName.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            } else {
                txtName.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            }
        case "Password":
            var password = self.txtPassword.text as? String ?? ""
            if password.count < 5 {
                txtPassword.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            } else {
                txtPassword.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            }
        default: break
            
        }
        
        return true
    }
    @IBAction func segLoginRegisterTuched(_ sender: Any) {
    changeLoginRegisterInterfaceBySelectedSegment(segLoginRegister.selectedSegmentIndex)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        
        self.view.endEditing(true)
    }
    func changeLoginRegisterInterfaceBySelectedSegment(_ index:Int){
        /*need to remove targets*/
        btnLoginRegister.removeTarget(nil, action: nil, for: .allEvents)
        
        switch index {
        case 0:
            txtName.isHidden = false
            btnLoginRegister.setTitle("Register", for: UIControlState())
            btnLoginRegister.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        case 1:
            txtName.isHidden = true
            btnLoginRegister.setTitle("Login", for: UIControlState())
            btnLoginRegister.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        default:
            break;
        }    }
    
    @objc func handleLogin(){
        var email = self.txtEmail.text as? String ?? ""
        if email.isValidEmail() {
            
       
            if (self.txtPassword.text?.count)! > 0 {
                
                
                Auth.auth().signIn(withEmail: self.txtEmail.text! as String, password: self.txtPassword.text! as String) { (user, error) in
                    // ...
                    let usersRef = Database.database().reference().child("users")
                    let uid = user?.user.uid
                    
                    if usersRef != nil && uid != nil {
                        usersRef.child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                         
                            if snapshot.childrenCount > 0 {
                                AppUser.currentUser.setUserFromFB(snapshot: snapshot)
                                self.switchToMainScreen()
                            }
                           
                        })
                    } else {
                        self.showAlert(massage: "Something went wrong! try Again pleas")
                    }
                   
                }
            } else {
                self.showAlert(massage: "Invalid email or password")
                
            }
        }else {
            txtEmail.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
        
    }
    
    @objc func handleRegister(){
        
        var email = txtEmail.text! as String
        var pass = txtPassword.text! as String
        var name = txtName.text! as String
        if(name.count > 0){
            if email.isValidEmail() {
                if (pass.count > 5){
                    
                    var userDict = ["name": name,
                                    "email": email,
                                    "password":pass]
                    
                    Auth.auth().createUser(withEmail: userDict["email"]!, password: userDict["password"]!) { (authResult, error) in
                        // ...
                        guard let user = authResult?.user else { return }
                        
                        userDict["id"] = user.uid
                        self.refUsers.child(user.uid).setValue(userDict)
                        AppUser.currentUser.email = userDict["email"]!
                        AppUser.currentUser.name = userDict["name"]!
                        AppUser.currentUser.pass = userDict["password"]!
                        AppUser.currentUser.uid = user.uid
                        
                        // move to next page
                        self.switchToMainScreen()
                        
                    }
                    //        let key = refUsers.childByAutoId().key
                    
                }
                else{
                    txtPassword.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                    self.showAlert(massage: "Password is too short. Must be at least 6 characters long.")
                    
                }
            }
            else{
                txtEmail.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                self.showAlert(massage: "Invalid email address.")
                
            }
            
        }
        else{
            self.showAlert(massage: "Invalid user name. User name must not be empty.")
        }
        

    }
    
    func switchToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNav = storyboard.instantiateViewController(withIdentifier: "MainNav")

        UIApplication.shared.keyWindow?.rootViewController = mainNav
//        let new = UINavigationController(rootViewController: mainViewController)
//        animateFadeTransition(to: mainViewController)

    }
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        self.willMove(toParentViewController: nil)
        addChildViewController(new)
        
        transition(from: self, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.removeFromParentViewController()
            new.didMove(toParentViewController: self)
           
            completion?()  //1
        }
    }
    
    func showAlert(massage : String){
        // create the alert
        let alert = UIAlertController(title: "Oh, No!", message: massage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}




