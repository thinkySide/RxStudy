//
//  ArticleService.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import Foundation
import Alamofire
import RxSwift

protocol ArticleServiceProtocol {
    func fetchNews() -> Observable<[Article]>
}

class ArticleService: ArticleServiceProtocol {
    
    private let urlString = "https://newsapi.org/v2/everything?q=apple&from=2023-12-25&to=2023-12-25&sortBy=popularity&apiKey=b6901a3ccb0a4fa6b9562e3f7ccb799c"
    
    /// 아티클 데이터 요청 타입
    typealias ArticleResult = ([Article]?, Error?) -> Void
    
    /// 뉴스 데이터를 패치합니다.
    /// completion을 통해 반환값 호출
    /// 여러번 네트워킹 메서드를 호출해야 한다면 무한 콜백 지옥에 빠질 수 있음.
    func fetchNews(completion: @escaping ArticleResult) {
        
        // 1. URL 생성
        guard let url = URL(string: self.urlString) else {
            return completion(nil ,NSError(domain: "thinkySide", code: 404, userInfo: nil))
        }
        
        // 2. Requeset 생성
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseDecodable(of: ArticleResponse.self) { response in
                
                // 2-1. 에러 반환
                if let error = response.error {
                    return completion(nil, error)
                }
                
                // 2-2. Articles 반환
                if let articles = response.value?.articles {
                    return completion(articles, nil)
                }
            }
    }
    
    /// RxSwift를 이용해 비동기 네트워킹을 진행합니다.
    /// Observable(비동기 이벤트 순차적 관찰이 가능한 것!)  반환
    /// 제네릭으로 [Article] 데이터 반환
    func fetchNews() -> Observable<[Article]> {
        return Observable<[Article]>.create { observer -> Disposable in
            
            // 기존 콜백메서드를 통해 Observable에 담아주기
            self.fetchNews { articles, error in
                
                // 에러 처리
                if let error = error {
                    observer.onError(error)
                }
                
                // 아티클 처리
                if let articles = articles {
                    observer.onNext(articles)
                }
                
                // create 오퍼레이터는 클로저 종료 전
                // onCompleted 혹은 orError 한번 반환해줘야함.
                observer.onCompleted()
            }
            
            // Disposable 생성
            return Disposables.create()
        }
    }
}
