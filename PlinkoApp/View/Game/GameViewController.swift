import UIKit
import SpriteKit
import SnapKit

class GameScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GameScreenViewControllerDelegate  {
    
    weak var coordinator: MainCoordinator?
    
    var currentBlock = 0
    private var dropPositionX: CGFloat = UIScreen.main.bounds.width / 2
    private var showingBetSheet: Bool = false
    private var selectedBet: Double = 10
    private var isBallDropped: Bool = false
    private var ballLanded: Bool = false
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
        let im = UIImageView()
        return im
    }()
    let backgroundImageView2: UIImageView = {
        let im = UIImageView(image: UIImage(named: "longBack"))
        return im
    }()
    
    let targetBackView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "nameView"))
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let percents: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.72)
        return label
    }()
    
    private let stats: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    public let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.backButton), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
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
    
    public let reloadButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "reloadButton"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(reloadPressed), for: .touchUpInside)
        return button
    }()
    
    var block: GoalBlock!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ballDidFall(notification:)), name: Notification.Name("ballFalled"), object: nil)
        view.addSubview(backgroundImageView2)
        backgroundImageView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadData()
        loadUI()
        setupUI()
        setupObservers()
        addReloadButton()
        print(block.goals)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    func addReloadButton() {
        targetScrollView.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-20)
            make.top.equalTo(self.backgroundImageView.safeAreaLayoutGuide.snp.top).offset(15)
        }
    }
    
    func ballFalled(at id: Int) {
        let text = block.goals[id].text
        GoalManager.shared.updateGoal(inBlock: currentBlock, goalIndex: id, isDone: true, text: text)
        loadData()
    }
    
    func loadData() {
        block = GoalManager.shared.getBlock(at: currentBlock)
        goalsTableView.reloadData()
    }
    
    func loadUI() {
        nameLabel.text = block.name
        let total = Int(block.getPercent())! / 10
        stats.text = "\(total)/10"
        percents.text = "\(block.getPercent())%"
    }
    
    // MARK: - UI Setup
    
    @objc func ballDidFall(notification: Notification) {
        guard let id = notification.userInfo?["index"] as? Int else { return }
        let text = block.goals[id].text
        GoalManager.shared.updateGoal(inBlock: currentBlock, goalIndex: id, isDone: true, text: text)
        loadData()
        loadUI()
    }
    
    @objc func backPressed() {
        coordinator?.backPressed()
    }
    
    @objc func reloadPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("targetReloaded"), object: nil)
        GoalManager.shared.reloadBlock(at: currentBlock)
        loadData()
        loadUI()
    }
    
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
        GetterSingletone.shared.currentArray = []
        for i in 0..<block.goals.count {
            if block.goals[i].isDone {
                GetterSingletone.shared.currentArray.append(i)
            }
        }
        gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = .clear
        skView = SKView()
        skView = SKView(frame: CGRect(x: (self.view.frame.width-342)/2, y: 170, width: 342, height: 519))
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
            if UIScreen.main.bounds.height < 800 {
                make.bottom.equalTo(skView.snp.bottom).offset(-50)
            } else {
                make.bottom.equalTo(skView.snp.bottom).offset(-16)
            }
            make.width.equalTo(310)
            make.height.equalTo(60)
        }
        button.addTarget(self, action: #selector(dropOrRestartBall), for: .touchUpInside)
    }
    
    private func setupFinancialAnalysisImageView() {
        targetScrollView.addSubview(targetBackView)
        targetBackView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.centerX.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(24)
        }
        
        targetScrollView.addSubview(nameLabel)
        targetScrollView.addSubview(percents)
        targetScrollView.addSubview(stats)
        
        percents.snp.makeConstraints { make in
            make.centerY.equalTo(targetBackView.snp.centerY).offset(-2)
            make.trailing.equalTo(targetBackView.snp.trailing).offset(-16)
        }
        
        stats.snp.makeConstraints { make in
            make.centerY.equalTo(percents.snp.centerY)
            make.trailing.equalTo(percents.snp.leading).offset(-4)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(targetBackView.snp.leading).offset(16)
            make.top.equalTo(targetBackView.snp.top)
            make.bottom.equalTo(targetBackView.snp.bottom)
            make.centerY.equalTo(targetBackView.snp.centerY).offset(-2)
            make.trailing.equalTo(stats).offset(-10)
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
            NotificationCenter.default.post(name: NSNotification.Name("ballMoved"), object: location.x)
        }
    }
    
    private func dropBall() {
        isBallDropped = true
        NotificationCenter.default.post(name: NSNotification.Name("ballDropped"), object: dropPositionX)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ballLandedAction), name: NSNotification.Name("ballLanded"), object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func ballLandedAction() {
        ballLanded = true
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
        goalsTableView.backgroundColor = .clear
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
        cell.titleLabel.text = "\(block.goals[indexPath.row].text)"
        cell.checkBox.isSelected = block.goals[indexPath.row].isDone
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
      
}
