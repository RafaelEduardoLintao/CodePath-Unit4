//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Rafael Eduardo Lintao on 2/22/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()

    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }//end onLogout
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetsContent.text = (tweetArray[indexPath.row]["text"] as! String)
        
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }//end tableView func
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
    
    }//end viewDidLoad
    
    
    //Function that uses the API to load tweets
    @objc func loadTweet(){
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success:{ (tweets: [NSDictionary]) in
                                                        
            for tweet in tweets{
                self.tweetArray.append(tweet)
                
            }//end for
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }//end Success
        ,failure: { (Error) in
            print("could not retrieve tweet")
            
        })//end Failure
        
    }//end loadTweet


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }//end numberOfSections

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }//end tableView

    
}//end Class
