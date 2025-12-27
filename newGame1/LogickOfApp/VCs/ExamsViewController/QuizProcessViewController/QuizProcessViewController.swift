import UIKit
import SnapKit

struct QuizQuestion {
    let questionText: String
    let options: [String]
    let correctAnswerIndex: Int
}

class QuizProcessViewController: UIViewController {
    
    var categoryData: GeoCategory?
    private var questions: [QuizQuestion] = []
    private var currentQuestionIndex = 0
    private var selectedAnswerIndex: Int? = nil
    private var isAnswered = false
    private var score = 0
    
    // MARK: - UI Components
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.75)
        return view
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .white.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .black)
        label.textColor = .systemOrange
        label.textAlignment = .center
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    private let optionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("CHECK", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    private var optionButtons: [UIButton] = []
    
    private let viewModel = QuizProcessViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        resetScoreInDB() // СБРОС СТАРОГО РЕЗУЛЬТАТА ПРИ ВХОДЕ
        setupUI()
        displayQuestion()
    }
    
    // Сбрасываем баллы до 0 при каждом новом запуске теста
    private func resetScoreInDB() {
        guard let catTitle = categoryData?.title else { return }
        let key = "Score_\(catTitle)"
        UserDefaults.standard.set(0, forKey: key)
        self.score = 0
    }
    
    private func setupQuestions() {
        guard let title = categoryData?.title else { return }
        
        // Получаем данные напрямую из вью-модели
        self.questions = viewModel.getQuestions(for: title).shuffled()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: categoryData?.imageName ?? "")
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        backButton.addTarget(self, action: #selector(closeQuiz), for: .touchUpInside)
        
        view.addSubview(categoryLabel)
        categoryLabel.text = categoryData?.title.uppercased()
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        view.addSubview(optionsStackView)
        optionsStackView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        for i in 0..<4 {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.layer.cornerRadius = 12
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            btn.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(btn)
            optionButtons.append(btn)
            btn.snp.makeConstraints { $0.height.equalTo(55) }
        }
    }
    
    private func displayQuestion() {
        isAnswered = false
        selectedAnswerIndex = nil
        actionButton.setTitle("CHECK", for: .normal)
        actionButton.alpha = 0.5
        actionButton.isEnabled = false
        
        let q = questions[currentQuestionIndex]
        questionLabel.text = q.questionText
        progressLabel.text = "Question \(currentQuestionIndex + 1) of \(questions.count)"
        
        for (index, btn) in optionButtons.enumerated() {
            btn.setTitle(q.options[index], for: .normal)
            btn.backgroundColor = .clear
            btn.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            btn.isEnabled = true
        }
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        if isAnswered { return }
        selectedAnswerIndex = sender.tag
        
        optionButtons.forEach {
            $0.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            $0.backgroundColor = .clear
        }
        
        sender.layer.borderColor = UIColor.systemOrange.cgColor
        sender.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        
        actionButton.alpha = 1.0
        actionButton.isEnabled = true
    }
    
    @objc private func actionButtonTapped() {
        if !isAnswered {
            checkAnswer()
        } else {
            nextQuestion()
        }
    }
    
    private func checkAnswer() {
        guard let selected = selectedAnswerIndex else { return }
        isAnswered = true
        let correct = questions[currentQuestionIndex].correctAnswerIndex
        
        if selected == correct {
            optionButtons[selected].backgroundColor = .systemGreen.withAlphaComponent(0.4)
            optionButtons[selected].layer.borderColor = UIColor.systemGreen.cgColor
            score += 4
            // СОХРАНЯЕМ ТЕКУЩИЙ ПРОГРЕСС СРАЗУ
            saveCurrentProgressToDB()
        } else {
            optionButtons[selected].backgroundColor = .systemRed.withAlphaComponent(0.4)
            optionButtons[selected].layer.borderColor = UIColor.systemRed.cgColor
            optionButtons[correct].layer.borderColor = UIColor.systemGreen.cgColor
            optionButtons[correct].backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        }
        
        actionButton.setTitle("NEXT", for: .normal)
    }
    
    private func saveCurrentProgressToDB() {
        guard let catTitle = categoryData?.title else { return }
        let key = "Score_\(catTitle)"
        // Просто перезаписываем текущее значение score в UserDefaults
        UserDefaults.standard.set(score, forKey: key)
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            displayQuestion()
        } else {
            finishQuiz()
        }
    }
    
    private func finishQuiz() {
        let alert = UIAlertController(title: "Exam Finished", message: "Your final score: \(score)/100", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    @objc private func closeQuiz() {
        dismiss(animated: true)
    }
}
