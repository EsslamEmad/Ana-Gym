//
//  LoginTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 15/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD

class LoginTableViewController: UITableViewController {

    var rememberMe = false
    var programID: Int?
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var backToProgramsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg.png"))
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        view.endEditing(true)
    }

    @IBAction func didPressForgotPassword(_ sender: Any) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني..", comment: ""), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("البريد الإلكتروني", comment: "")
        }
        let resetPasswordAction = UIAlertAction(title: NSLocalizedString("إستعادة كلمة المرور", comment: ""), style: .default, handler: { (UIAlertAction) in
            if let textField = alert.textFields?.first{
                guard let email = textField.text, email != "", email.isEmail() else {
                    self.showAlert(error: true, withMessage: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني!", comment: ""), completion: nil)
                    return
                }
                SVProgressHUD.show()
                self.enablingButtons(check: false)
                firstly{
                    return API.CallApi(APIRequests.forgotPassword(email: email))
                    } .done{
                        let resp = try! JSONDecoder().decode(ResponseMessage.self, from: $0)
                        alert.dismiss(animated: true, completion: nil)
                        self.showAlert(error: false, withMessage: resp.message, completion: nil)
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                        self.enablingButtons(check: true)
                }
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        alert.addAction(resetPasswordAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressRememberMe(_ sender: Any) {
        if rememberMe{
            rememberMeButton.setImage(UIImage(named:"square-4.png"), for: .normal)
            rememberMe = false
        } else {
            rememberMeButton.setImage(UIImage(named:"verified-2.png"), for: .normal)
            rememberMe = true
        }
    }
    
    @IBAction func didPressLogin(_ sender: Any) {
        guard let email = usernameTextField.text, email != "", email.isEmail(), let password = passwordTextField.text, password != "" else{
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل بياناتك بشكل صحيح", comment: ""))
            return
        }
        enablingButtons(check: false)
        
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.login(email: email, password: password))
            }.done { 
                let user = try!JSONDecoder().decode(User.self, from: $0)
                Auth.auth.user = user
                if self.rememberMe{
                    Auth.auth.isSignedIn = true
                }
                self.performMainSegue()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.enablingButtons(check: true)
        }
    }
    
    @IBAction func didPressNewAccount(_ sender: Any) {
        guard let pid = programID else{
            performProgramsSegue()
            return
        }
        performSegue(withIdentifier: "register", sender: pid)
    }
    
    @IBAction func backToPrograms(_ sender: Any){
        performProgramsSegue()
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
        Auth.auth.getSubscribedPrograms()
    }
    func performProgramsSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        
        let storyboard = UIStoryboard(name: "Programs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Programs")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    
    func enablingButtons(check: Bool){
        rememberMeButton.isEnabled = check
        loginButton.isEnabled = check
        newAccountButton.isEnabled = check
        forgotPasswordButton.isEnabled = check
        backToProgramsButton.isEnabled = check
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register"{
            let destination = segue.destination as! RegisterTableViewController
            destination.programID = sender as! Int
        }
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    
}
