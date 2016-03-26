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
        
        // success case with no author
        let artSuc = Article(title: "14 People Die As Bus Carrying University Exchange Students Crashes In Spain", author: nil, summary: "The bus was returning the students to Barcelona after a trip to the Fallas fireworks festival in Valencia when the accident occurred, Spanish newspaper El País reported. El País reported their were 57 on board the bus and most were students from the Erasmus exchange student programme. Jordi Jané, the Catalan interior minister, said the victims were between the ages of 22 to 29 and “the majority are Erasmus students of various nationalities. Jané confirmed 14 of the 57 passengers were dead and said the survivors did not appear to be seriously injured. At around 6 a.m. the coach driver lost control near Amposta, Tarragona, and the bus collided with an oncoming car, Jané said.", url: "https://")
        XCTAssertNotNil(artSuc)
        
        // success case with no title
        let artSuc2 = Article(title: "", author: "Alicia Melville-Smith", summary: "SOME SUMMARY", url: "https://")
        XCTAssertNotNil(artSuc2)
        
        // success case with only summary
        let artSuc3 = Article(title: "", author: nil, summary: "SOME SUMMARY", url: "https://")
        XCTAssertNotNil(artSuc3)
        
        // fail case
        let artFail = Article(title: "14 People Die As Bus Carrying University Exchange Students Crashes In Spain", author: "Alicia Melville-Smith", summary: "", url: "https://")
        XCTAssertNil(artFail)
        
        // fail case with empty Article
        let artFail2 = Article(title: "", author: "", summary: "", url: "https://")
        XCTAssertNil(artFail2)
    }
}
