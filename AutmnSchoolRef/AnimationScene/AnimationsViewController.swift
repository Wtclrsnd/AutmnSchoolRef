import UIKit
import Lottie

class AnimationsViewController: UIViewController {

    private let animationNames = ["animation1", "animation2", "animation3"]
    private var currentAnimationIndex = 0
    private var animationTimer: Timer?

    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var playPauseButton: UIButton = {
        let button = self.createConfiguredButton(systemName: "play.fill", pointSize: 40)
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = self.createConfiguredButton(systemName: "backward.fill", pointSize: 30)
        button.addTarget(self, action: #selector(showPreviousAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = self.createConfiguredButton(systemName: "forward.fill", pointSize: 30)
        button.addTarget(self, action: #selector(showNextAnimation), for: .touchUpInside)
        return button
    }()
    
    private let speedSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5
        slider.maximumValue = 2.0
        slider.value = 1.0
        slider.addTarget(self, action: #selector(speedSliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let stackView = UIStackView()
    private let timecodeLabel = UILabel()
    private let animationNameLabel = UILabel()
    private let animationInfoStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupStackView()
        setupAnimationView()
        setupControls()
        loadAnimation(at: currentAnimationIndex, autoPlay: false)
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

    private func setupAnimationView() {
        stackView.addArrangedSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6)
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
        
        let slowIcon = UIImageView(image: UIImage(systemName: "tortoise.fill"))
        slowIcon.tintColor = .gray
        slowIcon.contentMode = .scaleAspectFit
        
        let fastIcon = UIImageView(image: UIImage(systemName: "hare.fill"))
        fastIcon.tintColor = .gray
        fastIcon.contentMode = .scaleAspectFit

        speedStack.addArrangedSubview(slowIcon)
        speedStack.addArrangedSubview(speedSlider)
        speedStack.addArrangedSubview(fastIcon)
        
        NSLayoutConstraint.activate([
            speedSlider.widthAnchor.constraint(equalTo: speedStack.widthAnchor, multiplier: 0.8)
        ])
        
        return speedStack
    }

    private func createConfiguredButton(systemName: String, pointSize: CGFloat) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let button = UIButton(configuration: config)
        button.tintColor = .gray
        return button
    }

    private func loadAnimation(at index: Int, autoPlay: Bool) {
        let animationName = animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        animationNameLabel.text = animationName
        timecodeLabel.text = "0:00"
        
        animationTimer?.invalidate()
        
        if autoPlay {
            startTimer()
            animationView.play()
            playPauseButton.configuration?.image = UIImage(systemName: "pause.fill")
        } else {
            animationView.stop()
            playPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        }
    }

    private func startTimer() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let animation = self.animationView.animation else { return }
            let duration = animation.duration
            let currentTime = Double(self.animationView.currentProgress) * duration
            self.timecodeLabel.text = self.formatTime(currentTime)
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    @objc private func togglePlayPause() {
        if animationView.isAnimationPlaying {
            animationView.pause()
            animationTimer?.invalidate()
            playPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        } else {
            animationView.play()
            startTimer()
            playPauseButton.configuration?.image = UIImage(systemName: "pause.fill")
        }
    }

    @objc private func showPreviousAnimation() {
        currentAnimationIndex = (currentAnimationIndex - 1 + animationNames.count) % animationNames.count
        loadAnimation(at: currentAnimationIndex, autoPlay: animationView.isAnimationPlaying)
    }

    @objc private func showNextAnimation() {
        currentAnimationIndex = (currentAnimationIndex + 1) % animationNames.count
        loadAnimation(at: currentAnimationIndex, autoPlay: animationView.isAnimationPlaying)
    }

    @objc private func speedSliderChanged() {
        animationView.animationSpeed = CGFloat(speedSlider.value)
    }
}
