//
//  StoryTVCell.swift
//  Current News
//
//  Created by Christian O'Brien on 4/12/16.
//  Copyright © 2016 ChristianOBrien. All rights reserved.
//

import UIKit

class StoryTVCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAbstract: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
