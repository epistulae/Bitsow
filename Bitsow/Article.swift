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
    
    var title: String
    //var date: String/Int not sure how to get yet...
    var author: String
    var url: String
    var summary: String!
    
    // MARK: Initializers
    init?(title: String, author: String?, summary: String, url: String) {
        // Initialize stored properties.
        self.title = title
        self.author = author ?? ""
        self.summary = summary
        self.url = url
        
        
        //super.init() for when I add NSCoding and NSObject
        
        //Initialization fails if summary is empty
        if summary.isEmpty {
            return nil
        }
    }
}


