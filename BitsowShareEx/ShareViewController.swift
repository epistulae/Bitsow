//
//  ShareViewController.swift
//  BitsowShareEx
//
//  Created by Cynthia Tu on 3/26/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices


class ShareViewController: SLComposeServiceViewController {

    // MARK: Properties
    var artTitle = ""
    var artDate = ""
    var author = ""
    var summary = ""
    var text = ""
    

    let extensionName = "group.com.bitsow"
    let key = "url"
    
    var originalURL: String!
    
    override func isContentValid() -> Bool {
        // Always true given the plist specifications for web only
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        
        // check if extension is valid
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            let contentType = kUTTypeURL as String
            
            // check provider is valid
            if let contents = content.attachments as? [NSItemProvider]{
                // look for url
                for attachment in contents {
                    if attachment.hasItemConformingToTypeIdentifier(contentType){
                        attachment.loadItemForTypeIdentifier(contentType, options: nil) { data, error in
                            let URL = data as! NSURL
                            self.originalURL = URL.absoluteString
                            
                            // Call api
                            self.getArticle()
                            //let article = Article(url: originalURL, title: artTitle, date: artDate, author: author, summary: summary, text: text)


                        }
                    }
                }
            }
        } 
        
        // Unblock UI
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    // Saves an image to user defaults.
//    func saveURL(key: String, url: NSString) {
//        if let saved = NSUserDefaults(suiteName: extensionName) {
//            saved.setObject(url, forKey: key)
//            saved.synchronize()
//
//        }
//    }
    
    
    // MARK: API functions and etc.
    
    let endPoint: String = "https://api.aylien.com/api/v1"
    
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
    
    func getArticle(){
        let apiKey = getKey()
        let appID = getID()
        
        let URL = fixURL(originalURL)
        let specificEnd: String = "\(endPoint)/extract?url=\(URL)"
        
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
        request.addValue("9", forHTTPHeaderField: "sentences_number")
        
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
            
            // Get summary from JSON
            if let summary: NSArray = page["sentences"] as? NSArray {
                // Update summary
                self.performSelectorOnMainThread("updateSummary:", withObject: summary, waitUntilDone: false)
            }
            
        })
        task.resume()
    }
    
    
    // MARK: Update UI (Methods)
    func updateArticleTitle(text: String) {
        self.artTitle = text
    }
    
    func updateAuthor(text: String) {
        self.author = "By \(text)"
    }
    
    func updateDatePub(text: String) {
        //date only
        let date = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(0), end: text.endIndex.advancedBy(-15)))
        //time only
        let time = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(11), end: text.endIndex.advancedBy(-6)))
        
        self.artDate = "\(date) | \(time)"
    }
    
    func updateSummary(text: [String]) {
        var summary = ""
        for line in text{
            summary.appendContentsOf("\u{2022} \(line)\n")
        }
        self.summary = summary
    }
    
    func updateMainText(text: String) {
        self.text = text
    }


}
