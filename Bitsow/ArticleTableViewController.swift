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

        loadSampleData()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSampleData(){
        let article1 = Article(url: "URL1", title: "Title1", date: "2015-10-29", author: "A1Author", summary: ["sum1A1", "sum2A1"], text: "Blahblah Article 1")!
        let article2 = Article(url: "URL2", title: "Title2", date: "2015-10-29", author: "A2Author", summary: ["sum1A2", "sum2A2"], text: "Blahblah Article 2")!
        let article3 = Article(url: "URL3", title: "Title3", date: "2015-10-29", author: "A3Author", summary: ["sum1A3", "sum2A3"], text: "Blahblah Article 3")!
        
        articles += [article1, article2, article3]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
