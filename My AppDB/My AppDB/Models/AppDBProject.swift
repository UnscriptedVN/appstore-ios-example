//
//  AppDBProject.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import Foundation

struct AppDBProject: Codable {
    let blurb: String?
    let description: String
    let developer: Int
    let icon: String
    let id: String
    let latestVersion: String?
    let license: String
    let name: String
    let permissions: [String]
    let releases: [AppDBRelease]
    let screenshots: [String]
    let type: String
}


struct AppDBRelease: Codable {
    let download: String
    let notes: String
    let releaseDate: String
    let version: String
}
