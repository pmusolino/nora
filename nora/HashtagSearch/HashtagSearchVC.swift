//
//  HashtagSearchVC.swift
//  nora
//
//  Created by Martin Lasek on 07.10.18.
//  Copyright © 2018 Martin Lasek. All rights reserved.
//

import UIKit

class HashtagSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    var hashtagsOfSearchResult = [Hashtag]()
    var hashtagsOfselectedGroup = [Hashtag]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // Mock search results
        //loadSampleSearchResult()
        fetchJSON()
    }

    /* TEMP INSTAGRAM FETCH */
    func fetchJSON() {
        //let singleHashtagRequest = URL(string: "https://api.instagram.com/v1/tags/web?access_token=10470869.877f3d1.50a1b3efdc6b40f08ded0757e169bbd5")
        let searchHashtagRequest = URL(string: "https://api.instagram.com/v1/tags/search?q=web&access_token=\(InstagramSecret.accessToken)")

        let task = URLSession.shared.dataTask(with: searchHashtagRequest!) {(data, response, error) in

            guard error == nil else {
                print("error")
                return
            }

            guard let content = data else {
                print("no data")
                return
            }

            var hashtagResponse: SearchHashtagResponse?
            do {
                hashtagResponse = try JSONDecoder().decode(SearchHashtagResponse.self, from: content)
            } catch {
                print("cannot decode given data to HashtagResponse")
                return
            }

            if let resp = hashtagResponse {
                let hshtgs = resp.data.map { Hashtag(name: $0.name, usages: $0.mediaCount) }
                self.hashtagsOfSearchResult = hshtgs
            }

            // TEMP RESPONSE STRUCT //
            struct SearchHashtagResponse: Decodable {
                let data: [HashtagData]
                let meta: HashtagMeta

                struct HashtagData: Decodable {
                    let name: String
                    let mediaCount: Int

                    enum CodingKeys: String, CodingKey {
                        case name
                        case mediaCount = "media_count"
                    }
                }

                struct HashtagMeta: Decodable {
                    let code: Double
                }
            }
            // TEMP RESPONSE STRUCT //

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        task.resume()
    }
    /* TEMP INSTAGRAM FETCH */

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

        let hashtag = hashtagsOfSearchResult[indexPath.row]

        if nil != hashtagsOfselectedGroup.first { $0.name == hashtag.name } {
            hashtag.state = Hashtag.State.added
        }

        cell.hashtagSearchLabel.text = "#" + hashtag.name
        cell.hashtagSearchUsageLabel.text = String(hashtag.usages)
        cell.hashtagSearchStateLabel.text = hashtag.state.rawValue

        return cell
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func loadSampleSearchResult() {
        hashtagsOfSearchResult = [
            Hashtag(name: "web", usages: 72834),
            Hashtag(name: "programming", usages: 92180),
            Hashtag(name: "coding", usages: 1374656),
            Hashtag(name: "webdevelopment", usages: 122823),
            Hashtag(name: "coder", usages: 23474),
        ]
    }
}
