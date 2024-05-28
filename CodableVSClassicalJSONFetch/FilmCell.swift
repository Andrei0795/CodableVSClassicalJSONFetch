//
//  FilmCell.swift
//  CodableVSClassicalJSONFetch
//
//  Created by Andrei Ionescu on 28.05.2024.
//

import UIKit

class FilmCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var yearLabel: UILabel! {
        didSet {
            yearLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var countriesLabel :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
