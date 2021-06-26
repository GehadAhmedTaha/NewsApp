//
//  NewsHeadlineTableViewCell.swift
//  NewsApp
//
//  Created by Gehad Taha on 26/06/2021.
//

import UIKit

class NewsHeadlineTableViewCell: UITableViewCell {
  static let identifier = "NewsHeadlineTableViewCell"
  static let borderWidth = 1
  static let cornerRadius = 5
  @IBOutlet weak var articleImageView: UIImageView!
  @IBOutlet weak var articleTitleLabel: UILabel!
  @IBOutlet weak var articleSourceLabel: UILabel!
  private var article: Article?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if let borderWidth = Bundle.main.object(forInfoDictionaryKey: "cellBorderWidth") as? CGFloat  {
      self.layer.borderWidth = borderWidth
      self.articleImageView.layer.borderWidth = borderWidth
    }
    
    if let cornerRadius = Bundle.main.object(forInfoDictionaryKey: "cellCornerRadius") as? CGFloat  {
      self.layer.cornerRadius = cornerRadius
      self.articleImageView.layer.cornerRadius = cornerRadius
      self.layer.borderColor = UIColor.lightGray.cgColor
      self.articleImageView.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  override func prepareForReuse() {
    self.articleImageView.image = nil
    self.articleTitleLabel.text = nil
    self.articleSourceLabel.text = nil
  }
  
  func configure(article: Article) {
    self.articleImageView.downloadImage(url: article.urlToImage ?? "")
    self.articleTitleLabel.text = article.title
    self.articleTitleLabel.isHidden = article.title != nil ? false : true
    
    self.articleSourceLabel.text = "Source: \(article.source.name ?? "")"
    self.articleSourceLabel.isHidden = article.source.name != nil ? false : true
  }
}


extension UIImageView {
  func downloadImage(url: String) {
    guard let url = URL(string: url) else {return}
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data, error == nil else {return}
      DispatchQueue.main.async {
        self.image = UIImage(data: data)
      }
    }
    task.resume()
  }
}
