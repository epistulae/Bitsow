//
//  Article.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/22/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit

class Article: NSObject, NSCoding{
    
    // MARK: Properties
    var url: String
    var title: String
    var date: String
    var author: String
    var summary: String!
    var text: String!
    
    
    // MARK: Archiving Paths to Data
    static let ArticlesArchives =
    NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains:
        .UserDomainMask).first!
    
    static let ArchiveURL = ArticlesArchives.URLByAppendingPathComponent("articles")
    
    
    // MARK: Types
    struct PropertyKey {
        static let urlKey = "url"
        static let titleKey = "title"
        static let dateKey = "date"
        static let authorKey = "author"
        static let summaryKey = "summary"
        static let textKey = "text"
    }
    
    
    // MARK: Initializers
    init?(url: String, title: String, date: String, author: String?, summary: String, text: String) {
        // Initialize stored properties.
        self.url = url
        self.title = title
        self.date = date
        self.author = author ?? ""
        self.summary = summary
        self.text = text
        
        super.init()
        
        //Initialization fails if summary is empty
        if summary.isEmpty || text.isEmpty{
            // note: even if api does not process, summary and text will still contain error message.
            // should never be empty
            return nil
        }
    }
    
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(url, forKey: PropertyKey.urlKey)
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(author, forKey: PropertyKey.authorKey)
        aCoder.encodeObject(summary, forKey: PropertyKey.summaryKey)
        aCoder.encodeObject(text, forKey: PropertyKey.textKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let url = aDecoder.decodeObjectForKey(PropertyKey.urlKey) as! String
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! String
        let summary = aDecoder.decodeObjectForKey(PropertyKey.summaryKey) as! String
        let text = aDecoder.decodeObjectForKey(PropertyKey.textKey) as! String
        
        // author is optional
        let author = aDecoder.decodeObjectForKey(PropertyKey.authorKey) as? String
        
        self.init(url: url, title: title, date: date, author: author, summary: summary, text: text)
    }
}


