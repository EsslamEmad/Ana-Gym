//
//  RegisterTableViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 15/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD

class RegisterTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    var user = User()
    var programID: Int!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordConfirmationTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var weightTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var heightTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var sexTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var hearUsTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.backgroundView = UIImageView(image: UIImage(named: "fitness7195591920.png"))
        initializeToolbar()
        usernameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        weightTextField.delegate = self
        heightTextField.delegate = self
        hearUsTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        view.endEditing(true)
    }

    @IBAction func didPressRegister(_ sender: Any) {
        view.endEditing(true)
        guard Authentication() else {
            return
        }
        /*enablingButtons(check: false)
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.register(user: user))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                Auth.auth.isSignedIn = true
                self.performMainSegue()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.enablingButtons(check: true)
        }*/
        
        performSegue(withIdentifier: "payment", sender: user)
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        
    }
    
    func Authentication() -> Bool{
        guard passwordTextField.text == passwordConfirmationTextField.text else {
            self.showAlert(withMessage: NSLocalizedString("الرقم السري غير متطابق", comment: ""))
            return false
        }
        guard let username = usernameTextField.text, username != "", let name = nameTextField.text, name != "", let email = emailTextField.text, email != "", email.isEmail(), let phone = phoneTextField.text, phone != "", let password = passwordTextField.text, password != "", let weight = Int(weightTextField.text ?? ""), let height = Int(heightTextField.text ?? ""), let hearUs = hearUsTextField.text, hearUs != "" else {
            self.showAlert(error: true, withMessage: NSLocalizedString("من فضلك أدخل بياناتك بشكل صحيح", comment: ""), completion: nil)
            return false
        }
        user.username = username
        user.name = name
        user.email = email
        user.phone = phone
        user.password = password
        user.weight = weight
        user.height = height
        user.gender = sexTextField.text == NSLocalizedString("ذكر", comment: "") ? 1 : 2
        user.hearUs = hearUs
        user.programID = programID
        
        return true
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
        Auth.auth.subscribedPrograms = [Program]()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == " payment"{
            let destination = segue.destination as! CheckoutViewController
            destination.user = user
            destination.register = true
        }
    }
    
    func enablingButtons(check: Bool){
        backButton.isEnabled = check
        registerButton.isEnabled = check
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    //Mark: Sex Picker
    
    private let sexPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    
    private func initializeSexPicker() {
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexTextField.inputView = sexPicker
        sexTextField.inputAccessoryView = inputAccessoryBar
        sexTextField.text = NSLocalizedString("ذكر", comment: "")
    }
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("تم", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
        initializeSexPicker()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return NSLocalizedString("ذكر", comment: "")
        default:
            return NSLocalizedString("أنثى", comment: "")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row {
        case 0:
            sexTextField.text = NSLocalizedString("ذكر", comment: "")
        default:
            sexTextField.text = NSLocalizedString("أنثى", comment: "")
        }
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }

    

}
