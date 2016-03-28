//
//  ViewController.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/22/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import Foundation
import UIKit

class ArticleViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    // MARK: Properties
    
    @IBOutlet weak var enterURL: UITextField!
    
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var artAuthor: UILabel!
    @IBOutlet weak var datePub: UILabel!
    @IBOutlet weak var altsum: UILabel!
    @IBOutlet weak var saveArticle: UIBarButtonItem!
    var mainText = ""
    
    var articleurl: String!
    let extensionName = "group.com.bitsow"
    let key = "url"
    
    var article: Article?
    var originalURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle user input with delegate callbacks
        enterURL.delegate = self
        
        // API Call once url is inputted
        if originalURL != nil {
            getArticle()
        }
        
        // Save button disabled until url is imputted
        checkUrl()
        
        
        //        if let saved = NSUserDefaults(suiteName: extensionName){
        //            print(saved)
        //            if let urlData = saved.objectForKey(key) as? NSString {
        //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //                    self.articleURL = urlData as String
        //                    self.artSummary.text = self.articleURL
        //                })
        //            }
        //        }
        //        print(articleURL)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func checkAlreadySaved(){
    //        // If article is not yet saved, the button is enabled
    //        let title = self.articleTitle.text ?? ""
    //        saveArticle.enabled = !title.isEmpty
    //    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        originalURL = enterURL.text
        getArticle()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveArticle.enabled = false
    }
    
    func checkUrl() {
        // Disable the Save button if the text field is empty.
        let text = originalURL ?? ""
        saveArticle.enabled = !text.isEmpty
    }
    
    // MARK: API Calls
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
    
    
    // Get article details
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
    
    func updateSummary(text: [String]) {
        var summary = ""
        for line in text{
        summary.appendContentsOf("\u{2022} \(line)\n")
        }
        self.altsum.text = summary
        saveArticle.enabled = true
    }
    
    func updateMainText(text: String) {
        self.mainText = text
    }
    
    
    
    // MARK: Navigation
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveArticle === sender {
        
        let url = originalURL
        let title = articleTitle.text
        let author = artAuthor.text ?? ""
        let date = datePub.text
        let summary = altsum.text
        let text = mainText
        
        // Set the meal to be passed to MealTableViewController after the unwind
        article = Article(url: url, title: title!, date: date!, author: author, summary: summary!, text:text)
        
        }
        
        
        
        
        func cancel(sender: UIBarButtonItem) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
}

