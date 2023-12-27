//
//  ArticleCollectionViewCell.swift
//  MVVM_RxSwift
//
//  Created by 김민준 on 12/26/23.
//

import UIKit
import RxSwift
import SDWebImage

class ArticleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let id = "ArticleCollectionViewCell"
    
    var viewModel = PublishSubject<ArticleViewModel>()
    var disposeBag = DisposeBag()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .secondarySystemBackground
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        subscribe()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func subscribe() {
        viewModel.subscribe { articleViewModel in
            
            // 이미지 세팅
            if let urlString = articleViewModel.imageURL {
                let url = URL(string: urlString)
                self.imageView.sd_setImage(with: url)
            }
            
            // 타이틀 및 설명 라벨 세팅
            self.titleLabel.text = articleViewModel.title
            self.descriptionLabel.text = articleViewModel.description
            
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Setup
    func setupUI() {
        backgroundColor = .systemBackground
        
        [imageView, titleLabel, descriptionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}
