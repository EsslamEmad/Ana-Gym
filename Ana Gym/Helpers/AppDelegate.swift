//
//  AppDelegate.swift
//  Ana Gym
//
//  Created by Esslam Emad on 13/8/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import AVFoundation
import RZTransitions
import SwiftSVG

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Auth.auth.getProducts()
        Auth.auth.getPrograms()
        Auth.auth.getPages()
        if Auth.auth.isSignedIn == true, Auth.auth.user != nil {
            Auth.auth.getSubscribedPrograms()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.window?.rootViewController = vc
        } else {
            Auth.auth.user = nil
            Auth.auth.subscribedPrograms = [Program]()
        }
        // Getting the shared instance of the audio session and setting audio to continue playback when the screen is locked.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomAlphaAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "indielabs-Frutigerlight", size: 19)!
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "indielabs-Frutigerlight", size: 19)!
        ]
        UINavigationBar.appearance().tintColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "indielabsFrutigerBold", size: 19)!, NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white, NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.white,  NSAttributedString.Key(rawValue: NSAttributedString.Key.strikethroughColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineColor.rawValue): UIColor.white], for: .normal)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        Auth.auth.fcmToken = token
        Auth.auth.updateToken()
        
        print(token)
    }
    
    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.transitioningDelegate = RZTransitionsManager.shared()
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }


}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
func getSvgImgFnc(svgImjFileNameVar: String, ClrVar: UIColor) -> UIImage
{
    let svgURL = Bundle.main.url(forResource: svgImjFileNameVar, withExtension: "svg")
    let svgVyuVar = UIView(SVGURL: svgURL!)
    
    /* The width, height and viewPort are set to 100
     
     <svg xmlns="http://www.w3.org/2000/svg"
     width="100%" height="100%"
     viewBox="0 0 100 100">
     
     So we need to set UIView Rect also same
     */
    
    svgVyuVar.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    /*for svgVyuLyrIdx in svgVyuVar.layer.sublayers!
    {
        for subSvgVyuLyrIdx in svgVyuLyrIdx.sublayers!
        {
            if(subSvgVyuLyrIdx.isKind(of: CAShapeLayer.self))
            {
                let SvgShpLyrIdx = subSvgVyuLyrIdx as? CAShapeLayer
                SvgShpLyrIdx!.fillColor = ClrVar.cgColor
            }
        }
    }*/
    return svgVyuVar.getImgFromVyuFnc()
}

extension UIView
{
    func getImgFromVyuFnc() -> UIImage
    {
        UIGraphicsBeginImageContext(self.frame.size)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image!
    }
}
