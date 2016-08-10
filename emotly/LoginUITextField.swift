//
//  LoginUITextField.swift
//  Emotly
//
//  Created by Tiziana Sellitto on 10/08/16.
//  Copyright © 2016 Michelangelo De Simone. All rights reserved.
//

import UIKit

 @IBDesignable class LoginUITextField: UITextField {
    /**
      The color of the background.

     This property applies a color to the background of the control.
     */
    @IBInspectable var textFieldBackgroundColor: UIColor? {
        didSet {
            self.backgroundColor = textFieldBackgroundColor;
        }
    }

    /**
     The radius to use when drawing rounded corners.

     This property applies a value to corner of the control.
     */
    @IBInspectable var textFieldCornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius =  textFieldCornerRadius;
        }
    }

    /**
     The border width of the controler

     This property applies a value to the border width of the control.
     */
    @IBInspectable var textFieldBorderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = textFieldBorderWidth;
        }
    }
}
