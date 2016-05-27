/*
 MIT License
 Copyright (c) 2016 Emotly Contributors
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var user_idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_idTextField.delegate = self
        passwordTextField.delegate = self
        
        // Enable the Sign In button only if the text field has a valid value.
        checkValidLoginData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(textField: UITextField){
        checkValidLoginData()
    }

    // MARK: Actions
    @IBAction func signInButton(sender: UIButton) {
        let user_id: NSString = user_idTextField.text!
        let password: NSString = passwordTextField.text!

        let login_params : NSDictionary = ["user_id": user_id, "password": password]
        login(login_params)
    }
    
    func checkValidLoginData() {
        // Disable the Save button if the text field is empty.
        let user_id = user_idTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        buttonSignIn.enabled = !user_id.isEmpty && !password.isEmpty
    }

    func login(login_params: NSDictionary, restApiService: EmotlyAPIManagerAbstract = EmotlyAPIManager()) {
        restApiService.postOperation(Constant.RESTAPI.Prefix + "/login", bodyParam: login_params) { json_response in
            let user = User()
            if let _ = json_response["header"] as? String {
                if let _ = json_response["signature"] as? String {
                    if let payload = json_response["payload"] as? NSDictionary {
                        user.jwt = json_response
                        for (key, val) in payload {
                            if (key as! String == "nickname") {
                                user.nickname = val as! NSString
                            }
                        }
                        let prefs = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(user.nickname, forKey: "NICKNAME")
                        prefs.setObject(user.jwt, forKey: "JWT")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                    }
                }
            }
        }
    }
    
}

