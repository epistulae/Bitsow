//
//  BitsowTests.swift
//  BitsowTests
//
//  Created by Cynthia Tu on 3/22/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import XCTest
@testable import Bitsow

class BitsowTests: XCTestCase {
    
    // MARK: Bitsow Tests
    
    // Test initializations of class Article
    func testArticleInitialization() {
        let title = "14 People Die As Bus Carrying University Exchange Students Crashes In Spain"
        var summary = [String]()
        let author = "Alicia Melville-Smith"
        let date = "some date"
       
        summary.append("S1")
        summary.append("S2")
        summary.append("S3")
        summary.append("S4")
        summary.append("S5")
        
        let text = "TEXT"
        let url = "https://"
        
        // success case with no author
        let artSuc = Article(url: url, title: title, date: date, author: nil, summary: summary, text: text)
        XCTAssertNotNil(artSuc)
        
        // success case with no title
        let artSuc2 = Article(url: url, title: "", date: date, author: author, summary: summary, text: text)
        XCTAssertNotNil(artSuc2)
        
        // success case with url, summary and text
        let artSuc3 = Article(url: url, title: "", date: "", author: nil, summary: summary, text: text)
        XCTAssertNotNil(artSuc3)
        
        // fail case
        let artFail = Article(url: url, title: title, date: date, author: author, summary: [], text: "")
        XCTAssertNil(artFail)
        
        // fail case with empty Article
        let artFail2 = Article(url: "", title: "", date: "", author: nil, summary: [], text: "")
        XCTAssertNil(artFail2)
        
    }
}
