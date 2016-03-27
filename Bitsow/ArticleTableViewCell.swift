//
//  ArticleTableViewCell.swift
//  Bitsow
//
//  Created by Cynthia Tu on 3/25/16.
//  Copyright © 2016 Cynthia Tu. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var artAuthor: UILabel!
    @IBOutlet weak var datePub: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
