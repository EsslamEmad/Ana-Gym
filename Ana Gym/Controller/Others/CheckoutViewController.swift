//
//  CheckoutViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 5/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import Alamofire
import WebKit
import RZTransitions

class CheckoutViewController: UIViewController, UIImagePickerControllerDelegate, WKNavigationDelegate, UINavigationControllerDelegate {

    
    var program: Program!
    var paypal = false
    var user: User!
    var register = false
    var webView: WKWebView!
    var buttonConnect: UIButton!
    
    @IBOutlet weak var paypalButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var visaStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        if register{
            backButton.isHidden = false
        }
        if let c = Auth.auth.production{
            if c {
                visaStackView.isHidden = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // SVProgressHUD.dismiss()
    }

    @IBAction func didPressPaypal(_ sender: Any){
        paypal = true
        paypalButton.setImage(UIImage(named: "filled-square"), for: .normal)
        transferButton.setImage(UIImage(named: "blank-square"), for: .normal)
        stackView.alpha = 0
        confirmButton.isEnabled = true
    }
    @IBAction func didPressTransfer(_ sender: Any){
        paypal = false
        transferButton.setImage(UIImage(named: "filled-square"), for: .normal)
        paypalButton.setImage(UIImage(named: "blank-square"), for: .normal)
        stackView.alpha = 1
        confirmButton.isEnabled = true
    }
    
    
    @IBAction func didPressConfirm(_ sender: Any){
        if !paypal{
            if ImagePicked, let image = uploadImage.image{
                SVProgressHUD.show()
                confirmButton.isEnabled = false
                paypalButton.isEnabled = false
                transferButton.isEnabled = false
                backButton.isEnabled = false
                navigationItem.backBarButtonItem?.isEnabled = false
                if !register {
                        firstly{
                            return API.CallApi(APIRequests.subscribeProgram(programID: self.program.id, userID: Auth.auth.user!.id, method: 1, photo: image))
                            }.done {
                                let resp = try! JSONDecoder().decode(ResponseMessage.self, from: $0)
                                self.showAlert(error: false, withMessage: resp.message, completion: nil)
                                self.performMainSegue()
                                Auth.auth.getSubscribedPrograms()
                            }.catch{
                                self.showAlert(withMessage: $0.localizedDescription)
                            }.finally {
                                SVProgressHUD.dismiss()
                                self.confirmButton.isEnabled = true
                                self.paypalButton.isEnabled = true
                                self.transferButton.isEnabled = true
                                self.backButton.isEnabled = true
                                self.navigationItem.backBarButtonItem?.isEnabled = true
                        }
                } else {
                    
                    firstly {
                        return API.CallApi(APIRequests.upload(image: image))
                        }.done {
                            let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                            self.user.uploadPhoto = resp.image
                            self.user.method = 1
                            firstly{
                                return API.CallApi(APIRequests.register(user: self.user))
                                }.done { resp in
                                    self.showAlert(error: false, withMessage: NSLocalizedString("تم رفع تحويلك بنجاح، من فضلك انتظر حتى يتم تفعيل عضويتك ثم حاول تسجيل الدخول مجدداً.", comment: ""), completion: { (UIAlertAction) -> Void in
                                        self.performLoginSegue()
                                    })
                                }.catch {
                                    self.showAlert(withMessage: $0.localizedDescription)
                                }
                        }.catch{
                            self.showAlert(withMessage: $0.localizedDescription)
                        }.finally {
                            SVProgressHUD.dismiss()
                            self.confirmButton.isEnabled = true
                            self.paypalButton.isEnabled = true
                            self.transferButton.isEnabled = true
                            self.backButton.isEnabled = true
                            self.navigationItem.backBarButtonItem?.isEnabled = true
                    }
                }
                
            } else {
                self.showAlert(withMessage: NSLocalizedString("من فضشلك قم برفع صورة الإيصال!", comment: ""))
            }
        } else {
            
            if register{
                SVProgressHUD.show()
                confirmButton.isEnabled = false
                paypalButton.isEnabled = false
                transferButton.isEnabled = false
                backButton.isEnabled = false
                navigationItem.backBarButtonItem?.isEnabled = false
                firstly{ () -> Promise<Data> in
                    user.method = 3
                    return API.CallApi(APIRequests.register(user: user))
                    }.done {
                        self.user = try! JSONDecoder().decode(User.self, from: $0)
                        let alert = UIAlertController(title: NSLocalizedString("تم", comment: ""), message: NSLocalizedString("لقد قمت بالتسجيل بنجاح، قم بدفع الإشتراك لتتمكن من الدخول إلى البرنامج.", comment: ""), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: NSLocalizedString("حسنًا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
                            self.webView = WKWebView(frame: self.view.frame)
                            var request: URLRequest!
                            request = URLRequest(url: URL(string: "https://anagym.com/ar/mobile/getHyperPayPage/\((self.user.id)!)/\((self.user.programID)!)")!)
                            
                            request.httpMethod = "GET"
                            request.addValue("a63e6de4fd0ae87da84395d1b0303bc0efeaee9f", forHTTPHeaderField: "CLIENT")
                            request.addValue("1114f4f8a99108ef7ef709b1e40074e482da230f", forHTTPHeaderField: "SECRET")
                            
                            self.view.addSubview(self.webView)
                            self.webView.navigationDelegate = self
                            self.buttonConnect = UIButton(frame: CGRect(x: self.view.frame.width - 52, y:20, width:32, height:32))
                            self.buttonConnect.setImage(UIImage(named: "error.png"), for: .normal)
                            self.buttonConnect.backgroundColor = .white
                            self.buttonConnect.clipsToBounds = true
                            self.buttonConnect.layer.cornerRadius = 16
                            self.buttonConnect.addTarget(self, action: #selector(self.btnConnectTouched(sender:)), for:.touchUpInside)
                            self.webView.addSubview(self.buttonConnect)
                            self.webView.contentScaleFactor = 2.0
                            self.webView.load(request)
                        })
                        alert.addAction(okAction)
                        alert.transitioningDelegate = RZTransitionsManager.shared()
                        
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                        self.confirmButton.isEnabled = true
                        self.paypalButton.isEnabled = true
                        self.transferButton.isEnabled = true
                        self.backButton.isEnabled = false
                        self.navigationItem.backBarButtonItem?.isEnabled = true
                }
            }
            else {
            webView = WKWebView(frame: self.view.frame)
            var request: URLRequest!
            request = URLRequest(url: URL(string: "https://anagym.com/ar/mobile/getHyperPayPage/\((Auth.auth.user!.id)!)/\((program.id)!)")!)
            
            request.httpMethod = "GET"
            request.addValue("a63e6de4fd0ae87da84395d1b0303bc0efeaee9f", forHTTPHeaderField: "CLIENT")
            request.addValue("1114f4f8a99108ef7ef709b1e40074e482da230f", forHTTPHeaderField: "SECRET")
            
            view.addSubview(webView)
            webView.navigationDelegate = self
              
            webView.load(request)
            }
            
            /*SVProgressHUD.show()
           /* firstly{
                return API.CallApi(APIRequests.showPaypalPage(programID: PID, userID: Auth.auth.user!.id))
                }.done { resp in
                    print("ok")
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                }.finally {
                    SVProgressHUD.dismiss()
            }*/
            Alamofire.request("https://anagym.com/ar/mobile/showPaypalPage/\(PID)/\(Auth.auth.user!.id)")
                .responseString { response in
                    let webView = UIWebView()
                    webView.loadHTMLString(response.result.value!, baseURL: nil)
            }*/
            
            
        }
    }
    
    @IBAction func btnConnectTouched(sender:UIButton!)
    {
        performLoginSegue()
        Auth.auth.user = nil
        Auth.auth.isSignedIn = false
    }
    
    @IBAction func didPressBack(_ sender: Any){
        performLoginSegue()
        Auth.auth.user = nil
        Auth.auth.isSignedIn = false
    }
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.dismiss(animated: false, completion: nil)
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    func performLoginSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "subscribed"{
            let destination = segue.destination as! SubscribedProgramTableViewController
            destination.program = program
        }else if segue.identifier == "BankAccounts"{
            let destination = segue.destination as! MoreViewController
            destination.id = 3
            destination.register = register
        }
    }
    
    //Mark: picking transfer image
    
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("اختر طريقة رفع الصورة.", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("الكاميرا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى الكاميرا الخاصة بك", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("مكتبة الصور", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        /*SVProgressHUD.show()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
        }
        else{
            SVProgressHUD.dismiss()
            self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
        }*/
    }
    
    var ImagePicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            uploadImage.image = selectedImage
            uploadImage.contentMode = .scaleAspectFit
            uploadImage.clipsToBounds = true
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //WEBVIEW
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("finish to load")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView.url?.absoluteString == "https://anagym.com/ar/vedios/success"{
            if !register{
                
            performSegue(withIdentifier: "subscribed", sender: nil)
                
            self.showAlert(error: false, withMessage: NSLocalizedString("تم الإشتراك بنجاح.", comment: ""), completion: nil)
                Auth.auth.subscribedPrograms.append(program)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                Auth.auth.user = user
                Auth.auth.isSignedIn = true
                Auth.auth.subscribedPrograms = [Program]()
                Auth.auth.getSubscribedPrograms()
                
                performMainSegue()
            }
        } else if webView.url?.absoluteString == "https://anagym.com/ar/vedios/failed"{
            view.sendSubviewToBack(webView)
            webView.stopLoading()
            self.showAlert(withMessage: NSLocalizedString("فشلت عملية الإشتراك، برجاء المحاولة لاحقا.", comment: ""))
        }
        SVProgressHUD.dismiss()
        print("Did commit")
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("did recieve redirect")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error2")
        print(error.localizedDescription)
    }
    /*func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("challenge")
    }*/
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("finished")
    }
    
    
    @IBAction func unwindToCheckout(_ sender: UIStoryboardSegue) {
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
