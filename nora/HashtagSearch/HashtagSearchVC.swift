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

        // Dismisses Keyboard if tapped anywhere in the view
        let selector = #selector(UIView.endEditing(_:))
        let gestureRecognizer = UITapGestureRecognizer(target: self.view, action: selector)

        // Set to `false` because otherwise table cell touches
        // are eaten by the gestureRecognizer
        gestureRecognizer.cancelsTouchesInView = false

        self.view.addGestureRecognizer(gestureRecognizer)
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
            self.tableView.reloadData()
        } else {
            instagramClient.searchInstagram(for: searchText, completion: { searchResult in
                self.hashtagsOfSearchResult = searchResult
                self.tableView.reloadData()
            })
        }
    }

    // Dismisses Keyboard when hitting "done".
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hashtag = hashtagsOfSearchResult[indexPath.row]

        if nil != hashtagsOfselectedGroup.first { $0.name == hashtag.name } {
            hashtagsOfselectedGroup.removeAll(where: { $0.name == hashtag.name })
        } else {
            hashtagsOfselectedGroup.append(hashtag)
        }

        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "hashtagSearchCell"
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier,
                for: indexPath
            ) as? HashtagSearchTableViewCell
        else {
            fatalError("No cell with identifier 'HashtagGroup' found")
        }

        // Early return since "index out of range" once occured here.
        if hashtagsOfSearchResult.count <= indexPath.row {
            return cell
        }

        let hashtag = hashtagsOfSearchResult[indexPath.row]

        // resetting the state because if it was `added` before
        // and is not in the list `hashtagsOfselectedGroup` it won't
        // gain the `none` state otherwise
        hashtag.state = Hashtag.State.none

        if nil != hashtagsOfselectedGroup.first { $0.name == hashtag.name } {
            hashtag.state = Hashtag.State.added
        }

        cell.hashtagSearchLabel.text = "#" + hashtag.name
        cell.hashtagSearchUsageLabel.text = String(hashtag.usages)
        cell.hashtagSearchStateLabel.text = hashtag.state.rawValue

        return cell
    }
}
