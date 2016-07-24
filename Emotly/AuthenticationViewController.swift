/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 Emotly Contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import UIKit

class AuthenticationViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func setLoginBtnStatus() {
        loginButton.enabled = !pwdField.text!.isEmpty && !userField.text!.isEmpty
    }
    
    @IBAction func loginBtnPressed() {
        errorLabel.hidden = true
        setControlsStatus(false)

        let emoServ = EmotlyService.sharedService
        emoServ.login(userField.text!, password: pwdField.text!,
                      doneCallback: loginCallback)
    }

    private func setControlsStatus(status: Bool) {
        loginButton.enabled = status
        userField.enabled = status
        pwdField.enabled = status
        activityIndicator.hidden = !activityIndicator.hidden
    }

    private func loginCallback(result: Bool, error: NSError?) {
        guard result else {
            errorLabel.hidden = false
            setControlsStatus(true)
            return
        }

        if let welcomeViCo = self.presentingViewController as? WelcomeViewController {
            welcomeViCo.prepareInterfaceForUser()
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
}
