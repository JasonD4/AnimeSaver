//
//  AnimeModel.swift
//  AnimeSaver
//
//  Created by Jason on 2/21/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation

struct AnimeFound: Codable {
    let data: [AnimeAttributes]
}

struct AnimeAttributes: Codable {
    let attributes: AnimeData
}

struct AnimeData: Codable {
    let synopsis: String?
    let canonicalTitle: String
    let abbreviatedTitles: [String?]?
    let startDate: String?
    let endDate: String?
    let nextRelease: String?
    let ageRating: String?
    let ageRatingGuide: String?
    let status: String
    let tba: String?
    let posterImage: ImageURL
    let episodeCount: Int?
    let episodeLength: Int?
    let totalLength: Int?
    let nsfw: Bool
    let ja_jp: String?
    let youtubeVideoId: String?
    let episodes: Episodes?
}

struct ImageURL: Codable {
    let original: URL?
}

struct Episodes: Codable {
    let related: String?
}
