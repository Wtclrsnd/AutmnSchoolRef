import UIKit
import Lottie

class AnimationsViewController: UIViewController {

    private let animationNames = ["animation1", "animation2", "animation3"]
    private var currentAnimationIndex = 0

    private let animationView = LottieAnimationView()
    private let playPauseButton: UIButton
    private let previousButton: UIButton
    private let nextButton: UIButton
    private let speedSlider = UISlider()
    
    private let stackView = UIStackView()
    private let animationInfoStack = UIStackView()
    private let timecodeLabel = UILabel()
    private let animationNameLabel = UILabel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        playPauseButton = AnimationsViewController.createConfiguredButton(systemName: "play.fill", pointSize: 40, action: #selector(togglePlayPause))
        previousButton = AnimationsViewController.createConfiguredButton(systemName: "backward.fill", pointSize: 30, action: #selector(showPreviousAnimation))
        nextButton = AnimationsViewController.createConfiguredButton(systemName: "forward.fill", pointSize: 30, action: #selector(showNextAnimation))
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        playPauseButton = AnimationsViewController.createConfiguredButton(systemName: "play.fill", pointSize: 40, action: #selector(togglePlayPause))
        previousButton = AnimationsViewController.createConfiguredButton(systemName: "backward.fill", pointSize: 30, action: #selector(showPreviousAnimation))
        nextButton = AnimationsViewController.createConfiguredButton(systemName: "forward.fill", pointSize: 30, action: #selector(showNextAnimation))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupStackView()
        setupAnimationContainer()
        setupControls()
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
    
    private func setupControls() {
        setupAnimationInfo()

        let controlsButtonStack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        controlsButtonStack.axis = .horizontal
        controlsButtonStack.spacing = 5
        controlsButtonStack.distribution = .equalSpacing

        let controlsContainerStack = UIStackView(arrangedSubviews: [controlsButtonStack])
        controlsContainerStack.axis = .vertical
        controlsContainerStack.spacing = 10
        controlsContainerStack.alignment = .center

        let speedControlStack = setupSpeedControl()

        let verticalStack = UIStackView(arrangedSubviews: [animationInfoStack, controlsContainerStack, speedControlStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 65
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        let controlsContainer = UIView()
        controlsContainer.translatesAutoresizingMaskIntoConstraints = false
        controlsContainer.addSubview(verticalStack)
        stackView.addArrangedSubview(controlsContainer)

        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: controlsContainer.centerXAnchor),
            verticalStack.topAnchor.constraint(equalTo: controlsContainer.topAnchor),
            controlsContainer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4),
            controlsButtonStack.widthAnchor.constraint(equalTo: controlsContainer.widthAnchor, multiplier: 0.5)
        ])
    }

    private func setupAnimationInfo() {
        animationInfoStack.axis = .vertical
        animationInfoStack.spacing = 8

        timecodeLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        timecodeLabel.textColor = .black
        timecodeLabel.textAlignment = .center

        animationNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        animationNameLabel.textColor = .gray
        animationNameLabel.textAlignment = .center

        animationInfoStack.addArrangedSubview(timecodeLabel)
        animationInfoStack.addArrangedSubview(animationNameLabel)
    }

    private func setupSpeedControl() -> UIStackView {
        let speedStack = UIStackView()
        speedStack.axis = .horizontal
        speedStack.spacing = 8
        
        let tortoiseIcon = UIImageView(image: UIImage(systemName: "tortoise.fill"))
        tortoiseIcon.tintColor = .gray
        tortoiseIcon.contentMode = .scaleAspectFit
        
        speedSlider.minimumValue = 0.5
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1.0
        speedSlider.addTarget(self, action: #selector(speedSliderChanged), for: .valueChanged)

        let hareIcon = UIImageView(image: UIImage(systemName: "hare.fill"))
        hareIcon.tintColor = .gray
        hareIcon.contentMode = .scaleAspectFit

        speedStack.addArrangedSubview(tortoiseIcon)
        speedStack.addArrangedSubview(speedSlider)
        speedStack.addArrangedSubview(hareIcon)

        NSLayoutConstraint.activate([
            speedSlider.widthAnchor.constraint(equalTo: speedStack.widthAnchor, multiplier: 0.8)
        ])

        return speedStack
    }
    
    private static func createConfiguredButton(systemName: String, pointSize: CGFloat, action: Selector) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let button = UIButton(configuration: config)
        button.addTarget(nil, action: action, for: .touchUpInside)
        button.tintColor = .gray
        
        return button
    }

    private func loadAnimation(at index: Int) {
        let animationName = animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        animationView.play()
        updatePlayPauseButtonIcon()

        animationNameLabel.text = animationName
        timecodeLabel.text = "00:00"
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
    
    @objc private func speedSliderChanged() {
        animationView.animationSpeed = CGFloat(speedSlider.value)
    }
}
