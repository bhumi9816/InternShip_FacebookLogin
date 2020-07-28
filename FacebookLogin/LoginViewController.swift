//
//  LoginViewController.swift
//  FacebookLogin
//
//  Created by Bhumi Patel on 6/23/20.
//  Copyright © 2020 Bhumi Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    

    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpHideLabel()
    }
    
    func setUpHideLabel() {
        ErrorLabel.alpha = 0
        
        //Style the elements
    }

    
    
    func Password_valid(_ passWord: String) -> Bool {
        
        //check against regular expression and returns a type boolean
        
        //Note: tools to generate regular expression to make sure all the conditions are met
        
        let passTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passTest.evaluate(with: passWord)
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
        
        //Step:1 Validate the Text fields
        
        
        //check if none of the fields are empty
        if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.ErrorLabel.text = "Please enter valid information in the fields"
            self.ErrorLabel.alpha = 1
        }
        
        let pass_written = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Password_valid(pass_written) == false {
            
            self.ErrorLabel.text = "Enter valid password"
            self.ErrorLabel.alpha = 1
            
        }
        
        else {
            
            let E_mail = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let Pass_word = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Step:2 Signing the user
            Auth.auth().signIn(withEmail: E_mail, password: Pass_word) { (result1, err1) in
                if err1 != nil {
                    //couldn't sign in
                    self.ErrorLabel.text = err1?.localizedDescription
                    self.ErrorLabel.alpha = 1
                }
                else {
                    
                    //direct them to the homePage
                    
                    
                    //cast as HomeView controller and make it the rootviewController so that it is displyed.
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: ConstantHelper.Storyboard.HomePageViewController) as? HomePageViewController
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                    
                }
            }
            
        }
        
    }
    
}
