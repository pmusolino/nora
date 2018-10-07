final class HashtagGroup {
    let name: String
    let hashtags: [Hashtag]

    init(name: String, hashtags: [Hashtag] = [Hashtag]()) {
        self.name = name
        self.hashtags = hashtags
    }
}
