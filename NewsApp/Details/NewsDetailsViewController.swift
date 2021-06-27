//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Gehad Taha on 27/06/2021.
//

import UIKit

class NewsDetailsViewController: UIViewController {
  var article: Article?
  
  @IBOutlet weak var newsImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var SourceLabel: UILabel!
  @IBOutlet weak var publishDateLabel: UILabel!
  
  @IBOutlet weak var upperContentView: UIView!
  @IBOutlet weak var lowerContentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let borderWidth = Bundle.main.object(forInfoDictionaryKey: "borderWidth") as? CGFloat  {
      self.upperContentView.layer.borderWidth = borderWidth
      self.lowerContentView.layer.borderWidth = borderWidth
      self.upperContentView.layer.borderColor = UIColor.systemGray.cgColor
      self.lowerContentView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    if let cornerRadius = Bundle.main.object(forInfoDictionaryKey: "cornerRadius") as? CGFloat  {
      self.upperContentView.layer.cornerRadius = cornerRadius
      self.lowerContentView.layer.cornerRadius = cornerRadius
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.updateUI()
  }
  
  func updateUI() {
    guard let article = self.article else {return}
    newsImage.downloadImage(url: article.urlToImage ?? "")
    titleLabel.text = article.title
    
    if let description = article.description {
      descriptionLabel.text = description
    } else {
      descriptionLabel.isHidden = true
    }
    
    if let authorName = article.author {
      authorLabel.text = "Author: \(authorName)"
    }
    authorLabel.isHidden = article.author == nil
    
    if let sourceName = article.source.name {
      SourceLabel.text = "Source: \(sourceName)"
    }
    SourceLabel.isHidden = article.source.name == nil
    
    if let dateStr = article.publishedAt {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
      let date = dateFormatter.date(from: dateStr)

      dateFormatter.dateFormat = "dd-MM-yyyy"
      if let originalDate = date {
        let formattedDate = dateFormatter.string(from: originalDate)
        publishDateLabel.text = "Publish date: \(formattedDate)"
      }

    }
    publishDateLabel.isHidden = article.publishedAt == nil
  }
  
  @IBAction func browseBtnPressed(_ sender: Any) {
    if let urlStr = article?.url,
       let url = URL(string: urlStr) {
      UIApplication.shared.open(url)
    }
  }
}
