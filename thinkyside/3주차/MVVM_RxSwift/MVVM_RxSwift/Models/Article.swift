//
//  Article.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String?
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}
