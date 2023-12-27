//
//  MainViewController.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: MainViewModel
    let disposeBag = DisposeBag()
    
    /// RxRelay?
    /// subject와 비슷한 동작을 수행하지만, completed, error 이벤트가 없음.
    /// onNext도 accept 메서드라는 이름으로 사용됨.
    ///
    /// terminate 이벤트를 발생시키지 않기 때문에 Dispose 되기 전까지 동작해
    /// UI에 사용한다고 함
    let articleViewModel = BehaviorRelay<[ArticleViewModel]>(value: [])
    
    /// articleViewModel에 값이 들어올 때마다 관찰하기 위함.
    var articleViewModelObserver: Observable<[ArticleViewModel]> {
        return articleViewModel.asObservable()
    }
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - LifeCycle
    
    /// ViewModel 또한 의존성 주입
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        subscribe()
        fetchArticles()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        self.title = viewModel.title
        
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.id)
    }
    
    // MARK: - Helper
    
    func subscribe() {
        articleViewModelObserver.subscribe { articleViewModel in
            
            print(articleViewModel)
            
            // 해당 시점에 articleViewModel에 값이 들어온 것.
            // UI 업데이트나 데이터 처리를 요기서 해주면 됨.
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }.disposed(by: disposeBag)
    }
    
    /// 아티클 값을 받아오는 메서드
    func fetchArticles() {
        viewModel.fetchArticles().subscribe { articleViewModels in
            
            // BehaviorRelay에 articleViewModel 값 넣기(accept)
            self.articleViewModel.accept(articleViewModels)
        }.disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.id, 
                                                      for: indexPath) as! ArticleCollectionViewCell
        
        let articleViewModel = self.articleViewModel.value[indexPath.row]
        cell.imageView.image = nil
        cell.viewModel.onNext(articleViewModel)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
