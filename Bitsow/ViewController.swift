//
//  ViewController.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/22/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    
    // MARK: Properties
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var artAuthor: UILabel!
    @IBOutlet weak var datePub: UILabel!
    @IBOutlet weak var artSummary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API Call
        //getArticle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: API Calls
    var originalURL = "http://www.pewinternet.org/2015/10/29/technology-device-ownership-2015/"
    // will be share of action at some point
    
    
    
    let endPoint: String = "https://api.aylien.com/api/v1"
    var mainText = ""
    
    // Fix illegal URLs
    func fixURL(url: String) ->String {
        let URL = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        return URL!
    }
    
    // Get stored appID and apiKey
    private func getKey() ->String{
        var key: String!
        
        let path = NSBundle.mainBundle().pathForResource("Key", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        key = dict!.objectForKey("aylienApiKey") as! String
        return key
    }
    
    private func getID() ->String{
        var appID: String!
        let path = NSBundle.mainBundle().pathForResource("Key", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        appID = dict!.objectForKey("aylienAppID") as! String
        return appID
    }
    
    
    // Get article details
    func getArticle(){
        let apiKey = getKey()
        let appID = getID()
        
        let URL = fixURL(originalURL)
        let specificEnd: String = "\(endPoint)/extract?url=\(URL)"
        
        print(specificEnd)
        guard let url = NSURL(string: specificEnd) else {
            print("Error: cannot create URL")
            return
        }
        
        // Configure request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("\(apiKey)", forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-Key")
        request.addValue("\(appID)", forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-ID")
        request.addValue("false", forHTTPHeaderField: "best_image")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        // Send request
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            
            // Catch errors
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET with Alchemy API")
                return
            }
            
            // Read JSON
            let page: NSDictionary
            do {
                page = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
            // Get and update title
            if let title = page["title"] as? String {
                self.performSelectorOnMainThread("updateArticleTitle:", withObject: title, waitUntilDone: false)
            }
            
            // Get and update author
            if let author = page["author"] as? String {
                self.performSelectorOnMainThread("updateAuthor:", withObject: author, waitUntilDone: false)
            }
            
            // Get and update date published
            if let dPub = page["publishDate"] as? String {
                self.performSelectorOnMainThread("updateDatePub:", withObject: dPub, waitUntilDone: false)
                
            }
            
            // Get full article text
            if let article = page["article"] as? String {
                self.performSelectorOnMainThread("updateMainText:", withObject: article, waitUntilDone: false)
            }
            
            // Call get summary
            self.getSummary()
            
        })
        task.resume()
    }
    
    
    // Get article summary
    func getSummary(){
        let apiKey = getKey()
        let appID = getID()
        
        let URL = fixURL(originalURL)
        let specificEnd: String = "\(endPoint)/summarize?url=\(URL)"
        
        print(specificEnd)
        guard let url = NSURL(string: specificEnd) else {
            print("Error: cannot create URL")
            return
        }
        
        // Configure request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("\(apiKey)", forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-Key")
        request.addValue("\(appID)", forHTTPHeaderField: "X-AYLIEN-TextAPI-Application-ID")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("5", forHTTPHeaderField: "sentences_number")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        // Send request
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            
            
            // Catch errors
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET with Alchemy API")
                return
            }
            print(responseData)
            
            // Read JSON
            let page: NSDictionary
            do {
                page = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
            // Get title from JSON
            if let summary: NSArray = page["sentences"] as? NSArray {
                // Update title
                //self.performSelectorOnMainThread("updateSummary:", withObject: summary, waitUntilDone: false)
                print(summary)
            }
            
        })
        task.resume()
    }
    
    
    // MARK: Update UI (Methods)
    func updateArticleTitle(text: String) {
        self.articleTitle.text = text
    }
    
    func updateAuthor(text: String) {
        self.artAuthor.text = "By \(text)"
    }
    
    func updateDatePub(text: String) {
        //date only
        let date = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(0), end: text.endIndex.advancedBy(-15)))
        //time only
        let time = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(11), end: text.endIndex.advancedBy(-6)))
        
        self.datePub.text = "\(date) | \(time)"
    }
    
    func updateSummary(text: String) {
        self.artSummary.text = text
    }
    
    func updateMainText(text: String) {
        self.mainText = text
    }
    
    
    
    
    
    
    
    
    //
    //
    //
    //    let endPointAl: String = "http://gateway-a.watsonplatform.net/"
    //
    //    // Get stored api key
    //    private func getKeyA() ->String{
    //        var key: String!
    //        let path = NSBundle.mainBundle().pathForResource("Key", ofType: "plist")
    //        let dict = NSDictionary(contentsOfFile: path!)
    //        key = dict!.objectForKey("alchemyApiKey") as! String
    //        return key
    //    }
    //
    //        // Get article title
    //        func getTitle(){
    //            let apiKey = getKeyA()
    //            let URL = fixURL(originalURL)
    //
    //            let specificEnd: String = "\(endPointAl)/calls/url/URLGetTitle?apikey=\(apiKey)&url=\(URL)&outputMode=json"
    //
    //            guard let url = NSURL(string: specificEnd) else {
    //                let errorURL = "Error: cannot create URL"
    //                print(errorURL)
    //                return
    //            }
    //
    //            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    //            let session = NSURLSession(configuration: config)
    //
    //            let task = session.dataTaskWithRequest(NSURLRequest(URL: url), completionHandler: {
    //                (data, response, error) -> Void in
    //
    //                // Catch errors
    //                guard let responseData = data else {
    //                    print("Error: did not receive data")
    //                    return
    //                }
    //                guard error == nil else {
    //                    print("error calling GET with Alchemy API")
    //                    return
    //                }
    //
    //                print(responseData)
    //
    //                // Read JSON
    //                let page: NSDictionary
    //                do {
    //                    page = try NSJSONSerialization.JSONObjectWithData(responseData,
    //                        options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
    //                } catch  {
    //                    print("error trying to convert data to JSON")
    //                    return
    //                }
    //
    //                // Get title from JSON
    //                if let title = page["title"] as? String {
    //                    // Update title
    //                    print(title)
    //                    self.performSelectorOnMainThread("updateArticleTitle:", withObject: title, waitUntilDone: false)
    //                }
    //            })
    //            task.resume()
    //        }
    //
    
    //   // Get author
    //    func getAuthor(){
    //        let apiKey = getKeyA()
    //        let URL = fixURL(originalURL)
    //        print(URL)
    //
    //        let specificEnd: String = "http://gateway-a.watsonplatform.net/calls/url/URLGetAuthor?apikey=\(apiKey)&url=\(URL)&outputMode=json"
    //
    //        guard let url = NSURL(string: specificEnd) else {
    //            let errorURL = "Error: cannot create URL"
    //            print(errorURL)
    //            return
    //        }
    //
    //        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    //        let session = NSURLSession(configuration: config)
    //
    //        let task = session.dataTaskWithRequest(NSURLRequest(URL: url), completionHandler: {
    //            (data, response, error) -> Void in
    //
    //            // Catch errors
    //            guard let responseData = data else {
    //                print("Error: did not receive data")
    //                return
    //            }
    //            guard error == nil else {
    //                print("error calling GET with Alchemy API")
    //                return
    //            }
    //
    //
    //            // Read JSON
    //            let page: NSDictionary
    //            do {
    //                page = try NSJSONSerialization.JSONObjectWithData(responseData,
    //                    options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
    //            } catch  {
    //                print("error trying to convert data to JSON")
    //                return
    //            }
    //
    //            // Get author from JSON
    //            if let author = page["author"] as? String {
    //                // Update author
    //                self.performSelectorOnMainThread("updateAuthor:", withObject: author, waitUntilDone: false)
    //            }
    //        })
    //        task.resume()
    //    }
    
    
    
    
    
    
    // MARK: Actions
    
}

