//
//  MovieCell.swift
//  Movarium
//
//  Created by Anton Solovev on 29.10.2024.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    private let dataController = DataController.shared
    
    private let imageView = UIImageView()
    private let vignetteView = UIView()
    private let progressBar = UIProgressView()
    private let titleLabel = UILabel()
    private let genreButtonsStackView = UIStackView()
    private let watchButton = CustomButton(style: .gradient)
    private let watchButtonContainer = UIView()
    var action: () -> Void = {}
    var currentUserId: String = SC.empty
    
    var onTap: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(frame: CGRect, action: @escaping () -> Void, currentUserId: String) {
        self.action = action
        self.currentUserId = currentUserId
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        configureImageView()
        configureVignetteView()
        configureWatchButton()
        configureTitleLabel()
        configureButtonsStackView()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        vignetteView.isUserInteractionEnabled = true
        vignetteView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configuration
    func configure(with movie: StoriesMovieData) {
        let posterURL = movie.posterURL
        imageView.kf.setImage(with: URL(string: posterURL))
        titleLabel.text = movie.name
        
        configureGenres(for: movie)
    }
    
    private func configureGenres(for movie: StoriesMovieData) {
        genreButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let filteredGenres = movie.genres.filter { $0.lowercased() != "мультфильм" }
        let genresToDisplay = Array(filteredGenres.prefix(3)).sorted { $0.count < $1.count }
        
        let firstTwoGenresStackView = createGenresStackView(with: genresToDisplay.prefix(2))
        let thirdGenreStackView = createGenresStackView(with: genresToDisplay.dropFirst(2))
        
        genreButtonsStackView.addArrangedSubview(firstTwoGenresStackView)
        genreButtonsStackView.addArrangedSubview(thirdGenreStackView)
    }
    
    private func createGenresStackView(with genres: ArraySlice<String>) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        
        let favoriteGenres = dataController.getFavoriteGenres(for: currentUserId).map { $0.name }
        
        for genre in genres {
            let button = CustomButton(style: .plain)
            var genreConfig = UIButton.Configuration.plain()
            genreConfig.title = genre
            genreConfig.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
            genreConfig.baseForegroundColor = .textDefault
            genreConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(name: "Manrope-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
                return outgoing
            }
            button.configuration = genreConfig
            button.snp.makeConstraints { make in
                make.height.equalTo(28)
            }
            
            button.toggleStyle(favoriteGenres.contains(genre) ? .gradient : .plain)
            
            button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureVignetteView() {
        vignetteView.backgroundColor = .black.withAlphaComponent(0.4)
        vignetteView.clipsToBounds = true
        vignetteView.layer.cornerRadius = Constants.imageCornerRadius
        vignetteView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vignetteView.layer.masksToBounds = true
        
        contentView.addSubview(vignetteView)
        
        vignetteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.textColor = .textDefault
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 36)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-92)
        }
    }
    
    private func configureButtonsStackView() {
        genreButtonsStackView.axis = .vertical
        genreButtonsStackView.spacing = 4
        
        contentView.addSubview(genreButtonsStackView)
        
        genreButtonsStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(watchButtonContainer.snp.leading).offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    private func configureWatchButton() {
        watchButton.setTitle(LocalizedString.Movies.watchButtonTitle, for: .normal)
        watchButton.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)

        watchButtonContainer.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        watchButtonContainer.addSubview(watchButton)
        contentView.addSubview(watchButtonContainer)

        watchButton.snp.makeConstraints { make in
            make.edges.equalTo(watchButtonContainer.layoutMarginsGuide)
        }
        watchButtonContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Gesture Handling
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: imageView)
        let midX = imageView.bounds.midX
        
        if location.x > midX {
            onTap?(true)
        } else {
            onTap?(false)
        }
    }
    
    // MARK: - Button Actions
    @objc private func genreButtonTapped(_ sender: CustomButton) {
        let genreTitle = sender.configuration?.title ?? sender.title(for: .normal)
        guard let genre = genreTitle else { return }
        let favoriteGenres = dataController.getFavoriteGenres(for: currentUserId).map { $0.name }
        
        if favoriteGenres.contains(genre) {
            dataController.removeFavoriteGenre(for: currentUserId, genreName: genre)
            sender.toggleStyle(.plain)
        } else {
            dataController.addFavoriteGenre(for: currentUserId, genreName: genre)
            sender.toggleStyle(.gradient)
        }
    }
    
    @objc private func watchButtonTapped() {
        action()
    }
}

// MARK: - Constants
extension MovieCell {
    enum Constants {
        static var imageCornerRadius: CGFloat = 32
    }
}
