//
//  ArticleTableViewController.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/25/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {

    // MARK: Properties
    var articles = [Article]()
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        if let savedArticles = loadArticles() {
            articles += savedArticles
        } else {
            // Load the sample data.
            loadSampleData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Sample data
    func loadSampleData(){
        let article1 = Article(url: "http://www.wsj.com/articles/pope-francis-celebrates-easter-sunday-mass-amid-tight-security-1459073447", title: "Title1", date: "Some date for article 1", author: "A1Author", summary: "Article 1 Summary", text: "Article 1 Full Text")!
        let article2 = Article(url: "http://www.cnn.com/2016/03/27/asia/pakistan-lahore-deadly-blast/index.html", title: "Title2", date: "Some date for article 2", author: "A2Author", summary: "Article 2 Summary", text: "Article 2 Full Text")!
        let article3 = Article(url: "http://www.nbcnews.com/health/health-news/de-niro-s-tribeca-festival-yanks-anti-vaccination-film-n546161", title: "Title3", date: "Some date for article 3", author: "A3Author", summary: "Article 3 Summary", text: "Article 3 Full Text")!
        articles += [article1, article2, article3]
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ArticleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell

        //Call appropriate article
        let article = articles[indexPath.row]
        
        cell.artAuthor.text = article.author
        cell.articleTitle.text = article.title
        cell.datePub.text = article.date
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Remove article first
            articles.removeAtIndex(indexPath.row)
            
            // Update archives
            saveArticles()

            // Follow through and delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSaved" {
            let nav = segue.destinationViewController as! UINavigationController
            let articleDetailViewController = nav.topViewController as! SavedArticleViewController
            
            // Get article that generated segue.
            if let selectedArticleCell = sender as? ArticleTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedArticleCell)!
                let selectedArticle = articles[indexPath.row]
                articleDetailViewController.article = selectedArticle

            }
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as?
            ArticleViewController, article = sourceViewController.article{
            
            // add newly summarized article
            let newIndexPath = NSIndexPath(forRow: articles.count, inSection: 0)
            articles.append(article)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        
        // Save the articles.
        saveArticles()
    }
    
    // MARK: NSCoding
    func saveArticles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(articles, toFile: Article.ArchiveURL.path!)
        if !isSuccessfulSave {
        print("Oh no! Call the Aurors. Something went wrong! Failed to save article. ")
        }
    }
 
    func loadArticles() -> [Article]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(Article.ArchiveURL.path!) as? [Article]
    }
    
}
