//
//  Article.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/22/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit

class Article{
    
    // MARK: Properties
    
    var url: String
    var title: String
    var date: String
    var author: String
    var summary: String!
    var text: String!
    
    // MARK: Initializers
    init?(url: String, title: String, date: String, author: String?, summary: String, text: String) {
        // Initialize stored properties.
        self.url = url
        self.title = title
        self.date = date
        self.author = author ?? ""
        self.summary = summary
        self.text = text
        
        
        //super.init() for when I add NSCoding and NSObject
        
        //Initialization fails if summary is empty
        if summary.isEmpty || text.isEmpty{
            // note: even if api does not process, summary and text will still contain error message.
            // should never be empty
            return nil
        }
    }
}


