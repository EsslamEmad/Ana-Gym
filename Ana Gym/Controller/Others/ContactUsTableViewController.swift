//
//  ContactUsTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 4/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import PromiseKit

class ContactUsTableViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.textColor = UIColor.lightGray
        messageTextView.text = NSLocalizedString("الرسالة..", comment: "")
        messageTextView.delegate = self
        messageTextView.layer.borderWidth = 1.5
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.clipsToBounds = true
        messageTextView.layer.cornerRadius = 10.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    @IBAction func didPressSend(_ sender: Any){
        guard let name = nameTextField.text, name != "", let email = emailTextField.text, email != "", email.isEmail(), let phone = phoneTextField.text, phone != "", let msg = messageTextView.text, msg != "", messageTextView.textColor == UIColor.darkGray else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل بياناتك كاملة!", comment: ""))
            return
        }
        SVProgressHUD.show()
        sendButton.isEnabled = false
        firstly{
            return API.CallApi(APIRequests.contactUs(name: name, email: email, message: msg, phone: phone))
            }.done {
                let resp = try! JSONDecoder().decode(ResponseMessage.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: nil)
                self.performMainSegue()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.sendButton.isEnabled = true
        }
    }
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.textColor == UIColor.lightGray {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text.isEmpty {
            messageTextView.text = NSLocalizedString("الرسالة..", comment: "")
            messageTextView.textColor = UIColor.lightGray
        }
    }
}
