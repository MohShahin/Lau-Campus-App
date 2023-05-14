//
//  DetailViewController.swift
//  Lau_Campus_App
//
//  Created by Guest User on 4/28/23.
//

import UIKit

class DetailViewController: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var rssItem: RSSItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }

    func configure(with rssItem: RSSItem) {
        self.rssItem = rssItem
        titleLabel.text = rssItem.title
        dateLabel.text = rssItem.pubDate.description
        descriptionLabel.text = rssItem.description
    }
}
