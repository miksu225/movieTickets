//
//  LogInViewController.swift
//  movieTickets
//
//  Created by Koulutus on 30.1.2018.
//  Copyright © 2018 MikkoS. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LogInViewController: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var buttonLogIn: UIButton!
    @IBOutlet weak var buttonGoogleSIgnIn: GIDSignInButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBAction func LogInPressed(_ sender: UIButton) {
        let email = textEmail.text
        let password = textPassword.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error != nil {
                NSLog((error?.localizedDescription)!)
                
                let alert = UIAlertController(title: "Invalid credentials!", message: "Incorrect Username or Password.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                return
            }
            else {
                print("Log in successfull")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nc = storyboard.instantiateViewController(withIdentifier: "idMoviesListNavController") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = nc
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGoogleSignInButton()
    }
    
    func configureGoogleSignInButton() {
        
        GIDSignIn.sharedInstance().uiDelegate = self
  
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
