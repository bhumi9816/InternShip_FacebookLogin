//
//  SignUpViewController.swift
//  FacebookLogin
//
//  Created by Bhumi Patel on 6/23/20.
//  Copyright © 2020 Bhumi Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    
    @IBOutlet weak var lastNameTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpHideLabel()
        
    }
    
    
    //hiding the error label function
    func setUpHideLabel() {
        ErrorLabel.alpha = 0
        
        //style the elements
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //func that validates the fields by checking the textfields, else return an error message in the Error_label
    
    func Password_valid(_ passWord: String) -> Bool {
        
        //check against regular expression and returns a type boolean
        
        //Note: tools to generate regular expression to make sure all the conditions are met
        
        let passTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passTest.evaluate(with: passWord)
    }
    
    
    func validate_input() -> String? {
        
        //if any of the text field are empty return empty
        
        if firstNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please enter information in the text fields."
        }
        
        //Note: add email as well to check against the regulat expression
        
        //check for password validation
        let pass_written = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Password_valid(pass_written) == false {
            
            //invalid password, show the error message
            return "Please enter a valid Password having at least 8 characters in length, contains a special character, and a number"
            
        }
        
        
        return nil
    }
    
    
    
    
    @IBAction func SignUpClicked(_ sender: Any) {
        
        
        //Step:1 validate the fields
        let flag_input = validate_input()
        
        
        //there was an error for one of the checks
        if flag_input != nil {
            
            show_errorMessage(flag_input!)
            
        }
        else {
            
            
            //creating a reference to first_Name and last_Name
            let f_Name = firstNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let l_Name = lastNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let e_mail = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let pass_word = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //no error,  //Step:2 create the user
            Auth.auth().createUser(withEmail: e_mail, password: pass_word) { (result, err) in
                
                //check for errors
                if err != nil{
                    
                    //there's an error
                    self.show_errorMessage("Error! Not able create the user ")
                }
                else {
                    
                    //Note: need the other fiels to work with firebase classes.
                    
                    //no errors, user successfully created, add the first and last name to the database
                    let data_Base = Firestore.firestore()
                    
                    
                    //the uid we get is returned in result from the Auth object
                    data_Base.collection("users").addDocument(data: ["firstName": f_Name, "lastName": l_Name, "User-Id": result!.user.uid]) { (error) in
                        if error != nil {
                            
                            //show error message
                            self.show_errorMessage("User data unable to save")
                        }
                    }
                    

                    //Step:3 direct to the homePage
                    self.reDirectingToHome()
                    
                }
            }
            
        }
        
        
        
    }
    
    func show_errorMessage(_ msg: String) {
        
        ErrorLabel.text = msg
        ErrorLabel.alpha = 1
    }
    
    func reDirectingToHome() {
        
        
        //cast as HomeView controller and make it the rootviewController so that it is displyed.
        let homeViewController = storyboard?.instantiateViewController(identifier: ConstantHelper.Storyboard.HomePageViewController) as? HomePageViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
        
    }
    
    

}
