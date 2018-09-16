//
//  TrainingViewController.swift
//  Ana Gym
//
//  Created by Esslam Emad on 1/9/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import AVFoundation
import AVKit

class TrainingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var TID: Int!
    var PID: Int!
    var training: Training?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        fetchTraining()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func fetchTraining(){
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getTrainingDay(programID: PID, userID: Auth.auth.user!.id, dayID: TID))
            }.done {
                self.training = try! JSONDecoder().decode(Training.self, from: $0)
                self.filterVideos()
                self.nameLabel.text = self.training?.name
                self.detailsLabel.text = self.training?.details
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    var videos = [Video]()
    
    func filterVideos(){
        for video in training!.videos{
            if video.url != nil, video.url != ""{
                videos.append(video)
            }
        }
        tableView.reloadData()
    }
    
    /*@IBAction func didPressPlay(_ sender: Any){
        guard let videoUrl = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4") else {
            print("X")
            return
        }
        
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        self.player.playerView.playerBackgroundColor = .black

        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMove(toParentViewController: self)
        self.player.url = videoUrl
        self.player.playbackLoops = true
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        self.player.playFromBeginning()
        print("A")
    }*/
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrainingTableViewCell
        cell.label.text = videos[indexPath.row].name
        if let thumb = videos[indexPath.row].thumb, let imgurl = URL(string: thumb), thumb != ""{
           cell.thumb.kf.indicatorType = .activity
            cell.thumb.kf.setImage(with: imgurl)
            cell.playSign.alpha = 1
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    /*var i: Int?
    var cell: TrainingTableViewCell?*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*guard i ?? -1 != indexPath.row else { return }
        
        cell?.thumb.isUserInteractionEnabled = false
        cell = tableView.cellForRow(at: indexPath) as! TrainingTableViewCell
        
        
        i = indexPath.row*/
        /*self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = cell!.bounds
        
        
        self.addChildViewController(self.player)
        cell!.thumb.addSubview(self.player.view)
        self.player.didMove(toParentViewController: self)
        self.player.url = videoUrl
        self.player.playbackLoops = true
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        self.player.playFromBeginning()
        cell!.thumb.isUserInteractionEnabled = true
        print("A")*/
        
        /*guard let videoUrl = URL(string: "https://vimeo.com/282413745.mp4") else {
            print("X")
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: videoUrl)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }*/
        
        if let url = URL(string: videos[indexPath.row].url){
             UIApplication.shared.openURL(url)
        }
    }
}




