//
//  HashtagSearchVC.swift
//  nora
//
//  Created by Martin Lasek on 07.10.18.
//  Copyright © 2018 Martin Lasek. All rights reserved.
//

import UIKit

class HashtagSearchVC: UIViewController {

    // MARK: Properties

    var hashtagsOfSearchResult = [Hashtag]()
    var hashtagsOfselectedGroup = [Hashtag]()
    let instagramClient = InstagramClient()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        // Dismiss Keybaord if tapped anywhere in the view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Searchbar

extension HashtagSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            hashtagsOfSearchResult = []
        } else {
            instagramClient.searchInstagram(for: searchText, completion: { (hashtagsSearchResult) in
                self.hashtagsOfSearchResult = hashtagsSearchResult
                self.tableView.reloadData()
            })
        }
    }

    // Dismisses Keyboard when hitting "done"
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: Tableview

extension HashtagSearchVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hashtagsOfSearchResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "hashtagSearchCell"
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HashtagSearchTableViewCell
        else {
                fatalError("No cell with identifier 'HashtagGroup' found")
        }

        // Early return since "index out of range" occured once.
        if hashtagsOfSearchResult.count <= indexPath.row {
            return cell
        }

        let hashtag = hashtagsOfSearchResult[indexPath.row]

        if nil != hashtagsOfselectedGroup.first { $0.name == hashtag.name } {
            hashtag.state = Hashtag.State.added
        }

        cell.hashtagSearchLabel.text = "#" + hashtag.name
        cell.hashtagSearchUsageLabel.text = String(hashtag.usages)
        cell.hashtagSearchStateLabel.text = hashtag.state.rawValue

        return cell
    }
}
