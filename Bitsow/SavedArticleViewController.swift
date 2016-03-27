//
//  SavedArticleViewController.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/27/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit

class SavedArticleViewController: UIViewController, UINavigationControllerDelegate {

    
    // MARK: Properties
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var artAuthor: UILabel!
    @IBOutlet weak var datePub: UILabel!
    @IBOutlet weak var altsum: UILabel!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(article)
        
        // Set up view if contains saved Article
        if let article = article {
            articleTitle.text  = article.title
            artAuthor.text = article.author
            datePub.text = article.date
            altsum.text = article.summary
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    @IBAction func returnButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
