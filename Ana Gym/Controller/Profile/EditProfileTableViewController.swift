//
//  EditProfileTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 3/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import PromiseKit

class EditProfileTableViewController: UITableViewController {

    var user = Auth.auth.user!
    var dictionary = Dictionary<String,Any>()
    
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordConfirmationTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var weightTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var heightTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        weightTextField.delegate = self
        heightTextField.delegate = self
        usernameTextField.text = user.username
        nameTextField.text = user.name
        emailTextField.text = user.email
        phoneTextField.text = user.phone
        weightTextField.text = String(user.weight)
        heightTextField.text = String(user.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    @IBAction func didPressEdit(_ sender: Any){
        guard Authentication() else{
            return
        }
        dictionary["id"] = user.id
        
        if user.username != usernameTextField.text!{
            dictionary["username"] = usernameTextField.text
        }
        if user.name != nameTextField.text!{
            dictionary["name"] = nameTextField.text
        }
        if user.email != emailTextField.text! {
            dictionary["email"] = emailTextField.text
        }
        if user.phone != phoneTextField.text! {
            dictionary["phone"] = phoneTextField.text
        }
        if user.password != passwordTextField.text, passwordTextField.text != "" {
            dictionary["password"] = passwordTextField.text
        }
        if user.height != Int(heightTextField.text!)!{
            dictionary["height"] = Int(heightTextField.text!)!
        }
        if user.weight != Int(weightTextField.text!)! {
            dictionary["weight"] = Int(weightTextField.text!)!
        }
        guard dictionary.count > 1 else{
            self.showAlert(withMessage: NSLocalizedString("لا يوجد تغيير في البيانات", comment: ""))
            return
        }
        editButton.isEnabled = false
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.editUser(variables: dictionary))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                self.performSegue(withIdentifier: "Back to Profile", sender: nil)
                self.showAlert(error: false, withMessage: NSLocalizedString("تم تعديل الملف الشخصي بنجاح.", comment: ""), completion: nil)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.editButton.isEnabled = true
        }
    }
    
    func Authentication() -> Bool{
        guard passwordTextField.text == passwordConfirmationTextField.text else {
            self.showAlert(withMessage: NSLocalizedString("الرقم السري غير متطابق", comment: ""))
            return false
        }
        guard let username = usernameTextField.text, username != "", let name = nameTextField.text, name != "", let email = emailTextField.text, email != "", email.isEmail(), let phone = phoneTextField.text, phone != "", let _ = Int(weightTextField.text ?? ""), let _ = Int(heightTextField.text ?? "") else {
            self.showAlert(error: true, withMessage: NSLocalizedString("من فضلك أدخل بياناتك بشكل صحيح", comment: ""), completion: nil)
            return false
        }
        
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }

}
