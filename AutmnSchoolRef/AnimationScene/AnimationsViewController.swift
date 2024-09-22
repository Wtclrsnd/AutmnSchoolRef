import UIKit
import Lottie

final class AnimationsViewController: UIViewController {

    private let animationNames = ["animation1", "animation2", "animation3"] // в Constants

    private var currentAnimationIndex = 0 // в Constants
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
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4) // в Constants весь NSDirectionalEdgeInsets
        
        let button = UIButton(configuration: config)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60), // в Constants
            button.heightAnchor.constraint(equalToConstant: 60) // в Constants
        ])
        
        return button
    }

    private lazy var playPauseButton: UIButton = {
        let button = createConfiguredButton("play.fill", 40) // в Constants string
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = createConfiguredButton("backward.fill", 30) // в Constants string
        button.addTarget(self, action: #selector(showPreviousAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = createConfiguredButton("forward.fill", 30) // в Constants string
        button.addTarget(self, action: #selector(showNextAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var speedSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5 // в Constants
        slider.maximumValue = 2.0 // в Constants
        slider.value = 1.0 // в Constants
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
        stack.spacing = 8 // в Constants
        return stack
    }()

    private lazy var controlsButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        stack.axis = .horizontal
        stack.spacing = 5 // в Constants
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var controlsContainerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [controlsButtonStack])
        stack.axis = .vertical
        stack.spacing = 10 // в Constants
        stack.alignment = .center
        return stack
    }()
    
    private lazy var speedControlStack: UIStackView = {
        let slowIcon = UIImageView(image: UIImage(systemName: "tortoise.fill")) // UIImage вынести в экстеншен класса UIImage статическими переменными аналогично с Colors и Fonts
        slowIcon.tintColor = .gray
        slowIcon.contentMode = .scaleAspectFit
        
        let fastIcon = UIImageView(image: UIImage(systemName: "hare.fill")) // UIImage вынести в экстеншен класса UIImage статическими переменными аналогично с Colors и Fonts
        fastIcon.tintColor = .gray
        fastIcon.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [slowIcon, speedSlider, fastIcon])
        stack.axis = .horizontal
        stack.spacing = 8 // в Constants
        
        return stack
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [animationInfoStack, controlsContainerStack, speedControlStack])
        stack.axis = .vertical
        stack.spacing = 65 // в Constants
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
            controlsButtonStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5), // в Constants
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
            controlsContainer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4) // в Constants
        ])
    }

    private func loadAnimation(at index: Int, autoPlay: Bool) {
        let animationName = animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        animationNameLabel.text = animationName
        timecodeLabel.text = "0:00" // в Constants
        
        animationTimer?.invalidate()
        
        if autoPlay { // упростить эту хуйню прогони через гпт
            startTimer()
            animationView.play()
            playPauseButton.configuration?.image = UIImage(systemName: "pause.fill") // в экст UIImage
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
        let minutes = Int(time) / 60 // в Constants
        let seconds = Int(time) % 60 // в Constants
        return String(format: "%d:%02d", minutes, seconds)
    }

    @objc private func togglePlayPause() {
        if animationView.isAnimationPlaying {
            animationView.pause()
            animationTimer?.invalidate()
            playPauseButton.configuration?.image = UIImage(systemName: "play.fill") // в экст UIImage
        } else {
            animationView.play()
            startTimer()
            playPauseButton.configuration?.image = UIImage(systemName: "pause.fill") // в экст UIImage
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
    
    struct Constants {
        static let example: CGFloat = 15 // пример выноса
    }
}
