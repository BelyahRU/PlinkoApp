import UIKit
import SpriteKit
import SnapKit

class GameScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    weak var coordinator: MainCoordinator?
    
    var currentBlock = 0
    private var dropPositionX: CGFloat = UIScreen.main.bounds.width / 2
    private var showingBetSheet: Bool = false
    private var selectedBet: Double = 10
    private var isBallDropped: Bool = false
    private var hasBallLanded: Bool = false
    private var gameScene: SKScene!
    var skView: SKView!
    
    var targetScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = false
        return sv
    }()
    
    let backgroundImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "longBack"))
        return im
    }()
    
    let financialAnalysisImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "financialAnalysis"))
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    public let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.backButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let goalsTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let goalsBackView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tableViewBack")
        return view
    }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
//        updateContentSize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(targetScrollView)
        targetScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        targetScrollView.addSubview(backgroundImageView)
        setupGameContentView()
        setupBackgroundImage()
        setupDropOrRestartButton()
        setupBackButton()
        setupFinancialAnalysisImageView()
        setupTableViewBackView()
        setupGoalsTableView()
    }// обновляем contentSize после установки всех элементов}
        
    private func updateContentSize() {
        let skViewHeight: CGFloat = 519 // высота skView
        let tableViewHeight: CGFloat = 440 // высота таблицы из 10 строк по 44
        let padding: CGFloat = 20 * 2 // отступы сверху и снизу
        let totalContentHeight = skView.frame.origin.y + skViewHeight + padding + tableViewHeight + 1000

        targetScrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)
    }
    
    private func setupTableViewBackView() {
        targetScrollView.addSubview(goalsBackView)
        goalsBackView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(516)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundImageView.snp.bottom).offset(-20)
        }
    }
    
    private func setupBackgroundImage() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1250)  // Высота длинного фона
        }
        
        // Устанавливаем contentSize для targetScrollView, чтобы охватить весь фон
        targetScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1250)
    }
    
    private func setupGameContentView() {
        gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = .clear
        skView = SKView()
        skView = SKView(frame: CGRect(x: 20, y: 170, width: 342, height: 519))
        skView.presentScene(gameScene)
        skView.backgroundColor = .clear
        targetScrollView.addSubview(skView)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        skView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupDropOrRestartButton() {
        let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.launchTheBall), for: .normal)
        targetScrollView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(skView.snp.bottom).offset(-16)
            make.width.equalTo(310)
            make.height.equalTo(60)
        }
        button.addTarget(self, action: #selector(dropOrRestartBall), for: .touchUpInside)
    }
    
    private func setupFinancialAnalysisImageView() {
        targetScrollView.addSubview(financialAnalysisImageView)
        financialAnalysisImageView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.centerX.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(24)
        }
    }
    
    private func setupBackButton() {
        targetScrollView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(188)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.backgroundImageView.safeAreaLayoutGuide.snp.top).offset(5)
        }
    }
    
    // MARK: - Actions and Observers
    
    @objc private func dropOrRestartBall() {
        dropBall()
    }
    
    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        if !isBallDropped {
            let location = gesture.location(in: view)
            NotificationCenter.default.post(name: NSNotification.Name("moveBallToPosition"), object: location.x)
        }
    }
    
    private func dropBall() {
        isBallDropped = true
        NotificationCenter.default.post(name: NSNotification.Name("dropBallAtPosition"), object: dropPositionX)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ballLanded), name: NSNotification.Name("ballLanded"), object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func ballLanded() {
        hasBallLanded = true
        isBallDropped = false
    }
    
    private func setupGoalsTableView() {
        goalsTableView.dataSource = self
        goalsTableView.delegate = self
        goalsTableView.register(GoalCell.self, forCellReuseIdentifier: GoalCell.reuseId)
        goalsBackView.addSubview(goalsTableView)
        
        goalsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalCell.reuseId, for: indexPath) as? GoalCell else {
            return UITableViewCell()
        }
        cell.numberLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
