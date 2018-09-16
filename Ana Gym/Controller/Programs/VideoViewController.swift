//
//  VideoViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 16/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UIViewController, WKNavigationDelegate {

    var url: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(frame: self.view.frame)
        var request: URLRequest!
        request = URLRequest(url: URL(string: url)!)
        
        view.addSubview(webView)
        webView.navigationDelegate = self
            
        webView.load(request)
        self.view = webView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
