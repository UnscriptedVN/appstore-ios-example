//
//  NetworkLayer.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import Foundation
import Alamofire

final class AppDBNetwork {

    static let shared = AppDBNetwork()

    private init() {}

    func getProjects() async throws -> [AppDBProject] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try await AF.request("https://appdb.unscriptedvn.dev/api/v1/projects")
            .validate()
            .serializingDecodable([AppDBProject].self, decoder: decoder)
            .value
    }

    func getImageData(from convertible: URLConvertible) async throws -> Data {
        return try await AF.request(convertible)
            .validate()
            .serializingData()
            .value
    }

}
