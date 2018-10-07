//
//  HashtagGroupDetailVC.swift
//  nora
//
//  Created by Martin Lasek on 06.10.18.
//  Copyright © 2018 Martin Lasek. All rights reserved.
//

import UIKit

class HashtagGroupDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties

    var hashtags = [Hashtag]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hashtags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "hashtagGroupDetailCell"
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HashtagGroupDetailTableViewCell
        else {
                fatalError("No cell with identifier 'HashtagGroup' found")
        }

        let hashtag = hashtags[indexPath.row]
        cell.hashtagLabel.text = "#" + hashtag.name
        cell.hashtagUsageLabel.text = String(hashtag.usages)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HashtagSearchVC {
            vc.hashtagsOfselectedGroup = hashtags
        }
    }

    func loadSample() {
        hashtags = [
            Hashtag(name: "buildtheweb", usages: 78246),
            Hashtag(name: "dev", usages: 2301147),
            Hashtag(name: "swiftlang", usages: 5925810)
        ]
    }
}
