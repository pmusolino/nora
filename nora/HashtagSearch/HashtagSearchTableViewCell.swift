//
//  HashtagSearchTableViewCell.swift
//  nora
//
//  Created by Martin Lasek on 07.10.18.
//  Copyright © 2018 Martin Lasek. All rights reserved.
//

import UIKit

class HashtagSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var hashtagSearchLabel: UILabel!
    @IBOutlet weak var hashtagSearchUsageLabel: UILabel!
    @IBOutlet weak var hashtagSearchStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
