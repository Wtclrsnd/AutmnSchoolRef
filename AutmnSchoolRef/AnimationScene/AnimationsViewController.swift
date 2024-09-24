import UIKit
import Lottie

final class AnimationsViewController: UIViewController {

    private struct Constants {
        static let animationNames = ["animation1", "animation2", "animation3"]
        static let initialAnimationIndex = 0
        static let buttonDimension: CGFloat = 60
        static let buttonInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        static let playPausePointSize: CGFloat = 40
        static let controlButtonPointSize: CGFloat = 30
        static let sliderMinValue: Float = 0.5
        static let sliderMaxValue: Float = 2.0
        static let sliderInitialValue: Float = 1.0
        static let horizontalStackSpacing: CGFloat = 8
        static let verticalStackSpacing: CGFloat = 65
        static let controlButtonStackSpacing: CGFloat = 5
        static let controlsContainerStackSpacing: CGFloat = 10
        static let animationInfoStackSpacing: CGFloat = 8
        static let timecodeInitial = "0:00"
        static let minutesDivider = 60
        static let timerInterval: TimeInterval = 0.1
    }

    private var currentAnimationIndex = Constants.initialAnimationIndex
    private var animationTimer: Timer?

    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var createConfiguredButton: (String, CGFloat) -> UIButton = { systemName, pointSize in
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        config.contentInsets = Constants.buttonInsets
        
        let button = UIButton(configuration: config)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonDimension),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonDimension)
        ])
        
        return button
    }

    private lazy var playPauseButton: UIButton = {
        let button = createConfiguredButton("play.fill", Constants.playPausePointSize)
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = createConfiguredButton("backward.fill", Constants.controlButtonPointSize)
        button.addTarget(self, action: #selector(showPreviousAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = createConfiguredButton("forward.fill", Constants.controlButtonPointSize)
        button.addTarget(self, action: #selector(showNextAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var speedSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Constants.sliderMinValue
        slider.maximumValue = Constants.sliderMaxValue
        slider.value = Constants.sliderInitialValue
        slider.addTarget(self, action: #selector(speedSliderChanged), for: .valueChanged)
        return slider
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [animationView, controlsContainer])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var animationInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timecodeLabel, animationNameLabel])
        stack.axis = .vertical
        stack.spacing = Constants.animationInfoStackSpacing
        return stack
    }()

    private lazy var controlsButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        stack.axis = .horizontal
        stack.spacing = Constants.controlButtonStackSpacing
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var controlsContainerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [controlsButtonStack])
        stack.axis = .vertical
        stack.spacing = Constants.controlsContainerStackSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var speedControlStack: UIStackView = {
        let slowIcon = UIImageView(image: UIImage(named: "slow"))
        slowIcon.tintColor = .gray
        slowIcon.contentMode = .scaleAspectFit
        
        let fastIcon = UIImageView(image: UIImage(named: "fast"))
        fastIcon.tintColor = .gray
        fastIcon.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [slowIcon, speedSlider, fastIcon])
        stack.axis = .horizontal
        stack.spacing = Constants.horizontalStackSpacing
        
        return stack
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [animationInfoStack, controlsContainerStack, speedControlStack])
        stack.axis = .vertical
        stack.spacing = Constants.verticalStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var controlsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.topAnchor.constraint(equalTo: view.topAnchor),
            controlsButtonStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            speedSlider.widthAnchor.constraint(equalTo: speedControlStack.widthAnchor, multiplier: 0.8)
        ])
        
        return view
    }()

    private let timecodeLabel: UILabel = {
        let label = UILabel()
        label.font = .styleruBold
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let animationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .styleruSemibold
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViews()
        loadAnimation(at: currentAnimationIndex, autoPlay: false)
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            controlsContainer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4)
        ])
    }

    private func loadAnimation(at index: Int, autoPlay: Bool) {
        let animationName = Constants.animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        animationNameLabel.text = animationName
        timecodeLabel.text = Constants.timecodeInitial

        animationTimer?.invalidate()
        
        if autoPlay {
            startTimer()
            animationView.play()
        } else {
            animationView.stop()
        }

        let imageName = autoPlay ? "pause" : "play"
        playPauseButton.configuration?.image = UIImage(named: imageName)
    }

    private func startTimer() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: Constants.timerInterval, repeats: true) { [weak self] _ in
            guard let self = self, let animation = self.animationView.animation else { return }
            let duration = animation.duration
            let currentTime = Double(self.animationView.currentProgress) * duration
            self.timecodeLabel.text = self.formatTime(currentTime)
        }
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / Constants.minutesDivider
        let seconds = Int(time) % Constants.minutesDivider
        return String(format: "%d:%02d", minutes, seconds)
    }

    @objc private func togglePlayPause() {
        if animationView.isAnimationPlaying {
            animationView.pause()
            animationTimer?.invalidate()
            playPauseButton.configuration?.image = UIImage(named: "play")
        } else {
            animationView.play()
            startTimer()
            playPauseButton.configuration?.image = UIImage(named: "pause")
        }
    }

    @objc private func showPreviousAnimation() {
        currentAnimationIndex = (currentAnimationIndex - 1 + Constants.animationNames.count) % Constants.animationNames.count
        loadAnimation(at: currentAnimationIndex, autoPlay: animationView.isAnimationPlaying)
    }

    @objc private func showNextAnimation() {
        currentAnimationIndex = (currentAnimationIndex + 1) % Constants.animationNames.count
        loadAnimation(at: currentAnimationIndex, autoPlay: animationView.isAnimationPlaying)
    }

    @objc private func speedSliderChanged() {
        animationView.animationSpeed = CGFloat(speedSlider.value)
    }
}
