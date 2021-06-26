//
//  ViewController.swift
//  Socal_2106
//
//  Created by Long Bui on 6/22/21.
//

import UIKit
import CryptoKit
import Foundation
import CommonCrypto

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btn_SignIn: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var _username : String = ""
    var _password : String = ""
    var _password_server : String = ""
//    var _loginStatus : Int16 = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.username.delegate = self
        self.password.delegate = self
        
        //Dua chu Sign in ve Center
        btn_SignIn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        
        
    }
    
    @IBAction func onSubmitTapped(_ sender: Any) {
        Login_Action()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case self.username:
                self.password.becomeFirstResponder()
            case self.password:
                Login_Action()
            
            default:
                self.username.resignFirstResponder()
            }
        return true
            //textField.resignFirstResponder()
            //Login_Action()
            //return true
        }
    func Login_Action()
    {
        let _username = username.text!
        let _passwordfield = password.text!
        let _password = sha512Base64(string: password.text!)
        //        let _password = sha512Base64(string: "1234456")
        
        if (_username.isEmpty || _passwordfield.isEmpty) {
            // Create a new alert
            let dialogMessage = UIAlertController(title: "Attention", message: "Please fill in username and password", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
        else{
        
        
        guard let url = URL(string: "http://172.24.98.71:27394/api/loginauthen/\(_username)") else { return }
                
                let session = URLSession.shared
        session.dataTask(with: url) { [self] (data, response, error) in
//                    if let response = response {
//                        print(response)
//                    }
                    
                    if let data = data {
                        //print(data)
                        do {
//                            let json = try JSONSerialization.jsonObject(with: data, options: [])
//                            print(json)
                            
                            let decoder = JSONDecoder()
                            let downloadedjson = try decoder.decode([user].self, from: data)
                            //print(downloadedjson[0].Rel)
                            let _password_server = downloadedjson[0].Rel
                            
                            if _password == _password_server {
                                
                                //print("Log in successful")
                                
//                                self._loginStatus = 1
                                
                                //Segue Phai de o trong DispatchQueue.main.async {} moi ra
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "HomeSegue", sender: self)
                                                }
                               
                                
                            }
                            else {
                                //print("Log in failed")
                                
//                                self._loginStatus = 2
                                
                                DispatchQueue.main.async {
                                                    
                                    // Create a new alert
                                    let dialogMessage = UIAlertController(title: "Attention", message: "Please fill in username and password", preferredStyle: .alert)
                                    // Create OK button with action handler
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                        //print("Ok button tapped")
                                     })
                                    
                                    //Add OK button to a dialog message
                                    dialogMessage.addAction(ok)
                                    // Present alert to user
                                    self.present(dialogMessage, animated: true, completion: nil)
                                    
                                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                }
        .resume()
        //Message_Login()
        }
    }
    
    func sha512Base64(string: String) -> String? {
            guard let data = string.data(using: String.Encoding.utf8) else {
                return nil
            }

            var digest = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
            _ = digest.withUnsafeMutableBytes { digestBytes -> UInt8 in
                data.withUnsafeBytes { messageBytes -> UInt8 in
                    if let mb = messageBytes.baseAddress, let db = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let length = CC_LONG(data.count)
                        CC_SHA512(mb, length, db)
                    }
                    return 0
                }
            }
            return digest.base64EncodedString()
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HomeSegue") {
            let vc = segue.destination as! HomeController
            vc.user_name_pass = username.text!
        }
    }
    
    
    //Lock khong cho xoay (OrientationLock) Lock0 and Lock1- in AppDelegate.swift
    /*
     
     var orientationLock = UIInterfaceOrientationMask.all
     
     func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
         return self.orientationLock
     }
     */
    
    //Lock khong cho xoay (OrientationLock) Lock2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
        
    }
    //Lock khong cho xoay (OrientationLock) Lock3
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppDelegate.AppUtility.lockOrientation(.all)
    }
    
    
    //Khong xai
    func SetupLayout() {
        btn_SignIn.translatesAutoresizingMaskIntoConstraints = false
        btn_SignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        btn_SignIn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btn_SignIn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 450).isActive = true
        
        btn_SignIn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btn_SignIn.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}


