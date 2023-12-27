//
//  ArticleViewModel.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import Foundation

struct ArticleViewModel {
    private let article: Article
    
    var imageURL: String? {
        return article.urlToImage
    }
    
    var title: String? {
        return article.title
    }
    
    var description: String? {
        return article.description
    }
    
    init(article: Article) {
        self.article = article
    }
}
