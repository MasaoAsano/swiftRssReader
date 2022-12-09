//
//  TopicsTableViewCell.swift
//  MyOkashi
//
//  Created by user on 2022/12/08.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {

    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var pubDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
