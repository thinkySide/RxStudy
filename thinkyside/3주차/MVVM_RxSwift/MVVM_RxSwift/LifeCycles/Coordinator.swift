//
//  Coordinator.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import UIKit

final class Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    /// 스토리보드가 아닌 코드 베이스 레이아웃을 위한 초기 설정 메서드
    func configureRootVC() {
        let viewModel = MainViewModel(articleService: ArticleService())
        let rootViewController = MainViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
