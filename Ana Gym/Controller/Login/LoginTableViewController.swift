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
import WebKit
import RZTransitions

class LoginTableViewController: UITableViewController, WKNavigationDelegate {

    var rememberMe = false
    var programID: Int?
    var webView: WKWebView!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var backToProgramsButton: UIButton!
    var buttonConnect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = RZTransitionsManager.shared()
        //tableView.backgroundColor = UIColor.clear
        //tableView.backgroundView = UIImageView(image: UIImage(named: "bg.png"))
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
        let alert = UIAlertController(title: "", message: NSLocalizedString("من فضلك أدخل رقم الجوال..", comment: ""), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("رقم الجوال", comment: "")
        }
        let resetPasswordAction = UIAlertAction(title: NSLocalizedString("إستعادة كلمة المرور", comment: ""), style: .default, handler: { (UIAlertAction) in
            if let textField = alert.textFields?.first{
                guard let phone = textField.text, phone != "" else {
                    self.showAlert(error: true, withMessage: NSLocalizedString("من فضلك أدخل رقم الجوال..", comment: ""), completion: nil)
                    return
                }
                SVProgressHUD.show()
                self.enablingButtons(check: false)
                firstly{
                    return API.CallApi(APIRequests.forgotPassword(phone: phone))
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
                if let status = user.status, status == 1{
                self.webView = WKWebView(frame: self.view.frame)
                var request: URLRequest!
                request = URLRequest(url: URL(string: "https://anagym.com/ar/mobile/getHyperPayPage/\((user.id)!)/\((user.programID)!)")!)
                
                request.httpMethod = "GET"
                request.addValue("a63e6de4fd0ae87da84395d1b0303bc0efeaee9f", forHTTPHeaderField: "CLIENT")
                request.addValue("1114f4f8a99108ef7ef709b1e40074e482da230f", forHTTPHeaderField: "SECRET")
                
                self.view.addSubview(self.webView)
                self.webView.navigationDelegate = self
                self.buttonConnect = UIButton(frame: CGRect(x: self.view.frame.width - 52, y:20, width:32, height:32))
                self.buttonConnect.setImage(UIImage(named: "error.png"), for: .normal)
                self.buttonConnect.addTarget(self, action: #selector(self.btnConnectTouched(sender:)), for:.touchUpInside)
                    self.buttonConnect.backgroundColor = .white
                    self.buttonConnect.clipsToBounds = true
                    self.buttonConnect.layer.cornerRadius = 16
                    self.buttonConnect.addTarget(self, action: #selector(self.btnConnectTouched(sender:)), for:.touchUpInside)
                    self.webView.addSubview(self.buttonConnect)
                    self.webView.contentMode = .scaleToFill
                    self.webView.load(request)
                    SVProgressHUD.show()
                }
                else{
                if self.rememberMe{
                    Auth.auth.isSignedIn = true
                }
                    self.dismiss(animated: true, completion: nil)
                    self.performMainSegue()}
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.enablingButtons(check: true)
        }
    }
    
    @IBAction func didPressNewAccount(_ sender: Any) {
        guard let pid = programID else{
            let alert = UIAlertController(title: NSLocalizedString("اختر برنامجك", comment: ""), message: NSLocalizedString("قم باختيار برنامجك المفضل أولاً", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("حسنًا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
                self.performProgramsSegue()
            })
            alert.addAction(okAction)
            alert.transitioningDelegate = RZTransitionsManager.shared()
            
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        performSegue(withIdentifier: "register", sender: pid)
    }
    
    @IBAction func backToPrograms(_ sender: Any){
        performProgramsSegue()
    }
    
    @IBAction func btnConnectTouched(sender:UIButton!)
    {
        //self.view.sendSubview(toBack: webView)
        webView.alpha = 0
        sender.alpha = 0
        Auth.auth.user = nil
        Auth.auth.isSignedIn = false
    }
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        //self.dismiss(animated: true, completion: nil)
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
        //self.dismiss(animated: true, completion: nil)
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
            destination.programID = (sender as! Int)
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
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        if webView.url?.absoluteString == "https://anagym.com/ar/vedios/success"{
            
            if rememberMe{
                Auth.auth.isSignedIn = true}
            
                Auth.auth.subscribedPrograms = [Program]()
                Auth.auth.getSubscribedPrograms()
                self.dismiss(animated: true, completion: nil)
                performMainSegue()
            
        } else if webView.url?.absoluteString == "https://anagym.com/ar/vedios/failed"{
            view.sendSubviewToBack(webView)
            webView.stopLoading()
            self.showAlert(withMessage: NSLocalizedString("فشلت عملية الإشتراك، برجاء المحاولة لاحقا.", comment: ""))
        }
    }

}

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    func isPassword() -> Bool {
        let passwordRegex = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).*$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
}
