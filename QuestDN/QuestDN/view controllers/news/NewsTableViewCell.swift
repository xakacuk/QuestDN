//
//  NewsTableViewCell.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import UIKit
import AlamofireImage

final class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.af_cancelImageRequest()
    }
    
    public func configureCell(news: News) {
        let phImage = UIImage(named: "placeholder")
        titleLabel.text = news.title
        dateLabel.text = news.publishedAt
        descriptionLabel.text = news.description
        newsImage.af_setImage(withURL: URL(string: news.urlToImage)!, placeholderImage: phImage)
    }
    
}
