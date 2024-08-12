import UIKit
import Lottie

class AnimationsViewController: UIViewController {

    private let animationNames = ["animation1", "animation2", "animation3"]
    private var currentAnimationIndex = 0
    private var animationView: LottieAnimationView!
    private let stackView = UIStackView()
    private var playPauseButton: UIButton!
    private var previousButton: UIButton!
    private var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupStackView()
        setupAnimationContainer()
        setupButtons()
        loadAnimation(at: currentAnimationIndex)
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupAnimationContainer() {
        let animationContainer = UIView()
        animationContainer.backgroundColor = .lightGray
        animationContainer.translatesAutoresizingMaskIntoConstraints = false
        
        animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false

        animationContainer.addSubview(animationView)
        stackView.addArrangedSubview(animationContainer)

        NSLayoutConstraint.activate([
            animationContainer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            animationView.centerXAnchor.constraint(equalTo: animationContainer.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: animationContainer.centerYAnchor),
            animationView.heightAnchor.constraint(lessThanOrEqualTo: animationContainer.heightAnchor, multiplier: 0.9),
            animationView.widthAnchor.constraint(lessThanOrEqualTo: animationContainer.widthAnchor, multiplier: 0.9)
        ])
    }

    private func setupButtons() {
        playPauseButton = createConfiguredButton(systemName: "play.fill", pointSize: 40, action: #selector(togglePlayPause))
        previousButton = createConfiguredButton(systemName: "backward.fill", pointSize: 30, action: #selector(showPreviousAnimation))
        nextButton = createConfiguredButton(systemName: "forward.fill", pointSize: 30, action: #selector(showNextAnimation))

        let controlsStack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        controlsStack.axis = .horizontal
        controlsStack.spacing = 5
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        controlsStack.distribution = .equalCentering

        let controlsContainer = UIView()
        controlsContainer.translatesAutoresizingMaskIntoConstraints = false
        controlsContainer.addSubview(controlsStack)
        stackView.addArrangedSubview(controlsContainer)

        NSLayoutConstraint.activate([
            controlsStack.centerXAnchor.constraint(equalTo: controlsContainer.centerXAnchor),
            controlsStack.centerYAnchor.constraint(equalTo: controlsContainer.centerYAnchor),
            controlsStack.heightAnchor.constraint(equalToConstant: 50),
            
            controlsContainer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func createConfiguredButton(systemName: String, pointSize: CGFloat, action: Selector) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.perform(action)
        })

        button.tintColor = .gray
        return button
    }

    private func loadAnimation(at index: Int) {
        let animationName = animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        animationView.play()
        updatePlayPauseButtonIcon()
    }
    
    @objc private func togglePlayPause() {
        if animationView.isAnimationPlaying {
            animationView.pause()
        } else {
            animationView.play()
        }
        updatePlayPauseButtonIcon()
    }
    
    private func updatePlayPauseButtonIcon() {
        let systemName = animationView.isAnimationPlaying ? "pause.fill" : "play.fill"
        playPauseButton.configuration?.image = UIImage(systemName: systemName)
    }
    
    @objc private func showPreviousAnimation() {
        currentAnimationIndex = (currentAnimationIndex - 1 + animationNames.count) % animationNames.count
        loadAnimation(at: currentAnimationIndex)
    }
    
    @objc private func showNextAnimation() {
        currentAnimationIndex = (currentAnimationIndex + 1) % animationNames.count
        loadAnimation(at: currentAnimationIndex)
    }
}
