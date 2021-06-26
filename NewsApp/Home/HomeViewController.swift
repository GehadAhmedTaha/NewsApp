//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Gehad Taha on 26/06/2021.
//

import UIKit

class HomeViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var presenter: HomePresenter?
  let searchController = UISearchController()
  var activityIndicator = UIActivityIndicatorView(style: .large)
  var debouncer: Debouncer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    activityIndicator.startAnimating()
    self.presenter = HomePresenter()
    if let delay = Bundle.main.object(forInfoDictionaryKey: "debouncerDelay") as? TimeInterval {
      debouncer = Debouncer(delay: delay)
    }
    NotificationCenter.default.addObserver(forName:Notification.Name(rawValue: "ReloadDataNotification"), object: nil, queue: nil) { _ in
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        if self.tableView.tableFooterView != nil {
          self.tableView.tableFooterView = nil
        }
      }
    }
  }
  
  private func setupUI() {
    setupActivityIndicator()
    searchController.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    self.tableView.register(UINib(nibName: NewsHeadlineTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsHeadlineTableViewCell.identifier)
    self.tableView.estimatedRowHeight = 100
    self.tableView.rowHeight = UITableView.automaticDimension
  }
  
  private func setupActivityIndicator() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  func createSpinnerFooter() -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    let spinnerView = UIActivityIndicatorView()
    spinnerView.center = footerView.center
    footerView.addSubview(spinnerView)
    spinnerView.startAnimating()
    return footerView
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else {return}
    debouncer?.cancel()
    debouncer?.run {
      self.presenter?.search(for: text, completion: { _ in
        self.tableView.reloadData()
      })
    }
  }
  
  func willDismissSearchController(_ searchController: UISearchController) {
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "SearchStoppedNotification")))
  }
  
  func willPresentSearchController(_ searchController: UISearchController) {
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "SearchStartedNotification")))
  }
}


extension HomeViewController:  UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter?.data.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let article = presenter?.data[indexPath.section],
          let cell = tableView.dequeueReusableCell(withIdentifier: NewsHeadlineTableViewCell.identifier, for: indexPath) as? NewsHeadlineTableViewCell else {return UITableViewCell()}
    cell.configure(article: article)
    return cell
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 20.0
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView()
    footerView.backgroundColor = UIColor.clear
    return footerView
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailsVC =  NewsDetailsViewController()
  }
  
  
}

extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let presenter = self.presenter else { return }
    if self.tableView.contentOffset.y > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
      self.tableView.tableFooterView = createSpinnerFooter()
      presenter.isSearchModeActive ? presenter.fetchMoreSearchResult(query: searchController.searchBar.text) : presenter.loadData()
    }
  }
}
