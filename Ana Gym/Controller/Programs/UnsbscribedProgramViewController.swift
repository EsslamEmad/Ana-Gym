//
//  UnsbscribedProgramViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 19/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import AVKit
import PromiseKit
import SVProgressHUD
import RZTransitions
import WebKit

class UnsbscribedProgramViewController: UIViewController, WKNavigationDelegate {

    var program: Program!
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    //@IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var playSign: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var coachLabel: UILabel!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var instagramPhoto: UIImageView!
    @IBOutlet weak var bigView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProgram()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func fetchProgram(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getProgram(id: program.id))
            }.done {
                self.program = try! JSONDecoder().decode(Program.self, from: $0)
            }.catch { error in
                
            }.finally {
                SVProgressHUD.dismiss()
                self.showInfo()
        }
    }
    
    func showInfo(){
        var imgurl: URL!
        if let img = program.mainVideoThumb, img != ""{
            imgurl = URL(string: img)
            thumbnail.kf.indicatorType = .activity
            thumbnail.kf.setImage(with: imgurl)
            //playSign.alpha = 1
        } else {
            imgurl = URL(string: program.photo)
            thumbnail.kf.indicatorType = .activity
            thumbnail.kf.setImage(with: imgurl)
            playSign.alpha = 1
        }
        
        nameLabel.text = program.name
        let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.red]
        let color1 = UIColor(red: 79.0 / 255.0, green: 189.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
        let attrs2 = [NSAttributedString.Key.foregroundColor : color1]
        
        let attributedString1 = NSMutableAttributedString(string:program.subtitleRed + " ", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:program.subtitle, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        subtitleLabel.attributedText = attributedString1
        //detailsLabel.attributedText = program.details.html2AttributedString
        if let c = Auth.auth.production{
            if c {
                priceLabel.text = String(program.price) + NSLocalizedString(" ر.س.", comment: "")
                subscribeButton.setTitle("إشترك الآن", for: .normal)
            }
            else {
                priceLabel.isHidden = true
                priceLabel.alpha = 0
                subscribeButton.setTitle("إبدأ الآن مجاناً", for: .normal)
            }
        }
        coachLabel.text = program.coach
        instagramButton.setTitle(program.instagram, for: .normal)
        instagramPhoto.alpha = 1
        self.title = program.name
        didPressPlay(nil)
    }
    
    @IBAction func didPressSubscribe(_ sender: Any) {
        guard Auth.auth.user != nil else {
           /* let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("سجل عضوية جديدة أولاً لتتمكن من الدخول إلى البرنامج", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("حسنًا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
               
            })
            alert.addAction(okAction)
            alert.transitioningDelegate = RZTransitionsManager.shared()
            self.transitioningDelegate = RZTransitionsManager.shared()
            
            present(alert, animated: true, completion: nil)*/
            //performLoginSegue()
             self.performSegue(withIdentifier: "Login", sender: nil)
            return
        }
        if let c = Auth.auth.production{
            if c {
                performSegue(withIdentifier: "Checkout", sender: nil)
            }
            else {
                SVProgressHUD.show()
                firstly{
                    return API.CallApi(APIRequests.fsubscribe(programID: self.program.id, userID: Auth.auth.user!.id))
                    }.done {
                        let resp = try! JSONDecoder().decode(ResponseMessage.self, from: $0)
                        self.showAlert(error: false, withMessage: resp.message, completion: {(UIAlertAction) in
                            self.performSegue(withIdentifier: "show subscribed", sender: self.program)
                        })
                        Auth.auth.getSubscribedPrograms()
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
            }
        }
        
        
    }
    
    @IBAction func didPressInstagram(_ sender: Any){
        if let url1 = program.instagramURL{
        if let url = URL(string: url1 ){
            UIApplication.shared.openURL(url)
            }}
    }
    
    @IBAction func didPressPlay(_ sender: Any?) {
       /* guard let url = URL(string: "https://www.youtube.com/watch?v=7D4GBJUK65A.mp4") else {
            return
        }
        print(url)
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }*/
        /*if let url = URL(string: program.mainVideo){
            UIApplication.shared.openURL(url)
        }*/
        if let url = URL(string: program.mainVideo ?? ""){
            //performSegue(withIdentifier: "Video", sender: url)
            let webView = WKWebView(frame: self.bigView.frame)
            var request: URLRequest!
            request = URLRequest(url: url)
            /*programImage.addSubview(webView)
             webView.center = programImage.center*/
            thumbnail.alpha = 0
            webView.alpha = 1
            bigView.addSubview(webView)
            webView.center = bigView.center
            webView.navigationDelegate = self
            webView.load(request)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Checkout"{
            let destination = segue.destination as! CheckoutViewController
            destination.program = program
        } else if segue.identifier == "Login"{
            let destination = segue.destination as! RegisterTableViewController
            destination.programID = program.id
        }else if segue.identifier == "Video" {
            let destination = segue.destination as! VideoViewController
            destination.url = (sender as! URL)
        } else if segue.identifier == "show subscribed" {
            let destination = segue.destination as! SubscribedProgramTableViewController
            destination.program = (sender as! Program)
        }
    }
    
    func performLoginSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
       
        
    }
    
    @IBAction func unwindToUnsbscribedProgram(_ sender: UIStoryboardSegue) {
    }

}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
