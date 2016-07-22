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

class RegistrationViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var letsRollButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private func setControlsStatus(status: Bool) {
        activityIndicator.hidden = !activityIndicator.hidden
        letsRollButton.enabled = status
        nicknameTextField.enabled = status
        emailTextField.enabled = status
        passwordTextField.enabled = status
    }

    private func registrationCallback(result: Bool, error: NSError?) -> Void {
        dispatch_async(dispatch_get_main_queue(), {
            if result {
                self.activityIndicator.hidden = true
                self.performSegueWithIdentifier("registrationResultSegue",
                    sender: self)
            }
            else {
                self.setControlsStatus(true)
                self.errorLabel.hidden = false
                self.activityIndicator.hidden = true
            }
        })
    }

    @IBAction func letsRollButtonPressed(sender: UIButton) {
        setControlsStatus(false)
        self.errorLabel.hidden = true

        let emoServ = EmotlyService.sharedService
        emoServ.signupWith(nicknameTextField.text ?? "",
                           email: emailTextField.text ?? "",
                           password: passwordTextField.text ?? "",
                           doneCallback: registrationCallback)
    }
}
