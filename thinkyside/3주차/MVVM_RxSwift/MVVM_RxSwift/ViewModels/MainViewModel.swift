//
//  MainViewModel.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import Foundation
import RxSwift

final class MainViewModel {
    let title = "thinkySide"
    
    /// 의존성 주입을 위한 프로토콜 타입 지정
    /// MVVM의 핵심, 추후 재사용 및 유지보수를 위한 것.
    /// 여러가지 테스트를 위해서도 용이함.
    /// ex) 프로토콜에서 채택하는 메서드를 다르게 구현해 테스트 해본다던지,,!
    private let articleService: ArticleServiceProtocol
    
    /// 의존성 주입
    init(articleService: ArticleServiceProtocol) {
        self.articleService = articleService
    }
    
    /// articleService 프로토콜을 채택했다면,
    /// 얼마든지 외부에서 객체만 바꿔 테스트해볼 수 있는 것!
    func fetchArticles() -> Observable<[ArticleViewModel]> {
        return articleService.fetchNews()
            .map { $0.map { ArticleViewModel(article: $0) } }
    }
}
