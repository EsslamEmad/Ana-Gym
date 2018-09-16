//
//  Extensoins.swift
//  Ana Gym
//
//  Created by Esslam Emad on 15/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions

extension UIViewController: UITextFieldDelegate {
    
    func showAlert(error: Bool = true, withMessage message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: NSLocalizedString(error ? "خطأ" : "تم", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("حسنا", comment: ""), style: .default, handler: completion)
        alert.addAction(okAction)
        alert.transitioningDelegate = RZTransitionsManager.shared()
        present(alert, animated: true, completion: nil)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow (_ notification:Notification) {
        view.bounds.origin.y = +getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide (_ notification: Notification){
        view.bounds.origin.y = 0
    }
    
    @objc func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
