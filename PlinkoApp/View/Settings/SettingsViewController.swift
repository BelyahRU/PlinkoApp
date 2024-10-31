
import Foundation
import UIKit


class NotificationSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var coordinator: MainCoordinator?
    
    let options = ["Never", "Every hour", "Every 4 hours", "Once a day", "Once a week"]
    var selectedOptionIndex: Int?
    
    private let back = UIImageView(image:
            UIImage(named: Resources.Backgrounds.mainBackround))
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(NotificationOptionCell.self, forCellReuseIdentifier: NotificationOptionCell.reuseId)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.backButton), for: .normal)
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()
    
    private let settingsView: UIImageView = {
       let im = UIImageView()
        im.image = UIImage(named: "settingsView")
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    private let settingsBackView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "settingsBackView")
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "saveSettingsButton"), for: .normal)
        button.addTarget(self, action: #selector(saveSelection), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSelectedOption()
    }
    
    private func setupUI() {
        view.addSubview(back)
        view.addSubview(backButton)
        view.addSubview(settingsView)
        view.addSubview(settingsBackView)
        view.addSubview(tableView)
        view.addSubview(saveButton)
        
        back.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(188)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
        }
        settingsView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(backButton.snp.bottom).offset(24)
            make.width.equalTo(348)
            make.centerX.equalToSuperview()
        }
        
        settingsBackView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(352)
            make.top.equalTo(settingsView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.top.equalTo(settingsBackView.snp.top).offset(56)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(60)
            make.bottom.equalTo(settingsBackView.snp.bottom).offset(-16)
            make.centerX.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationOptionCell.reuseId, for: indexPath) as? NotificationOptionCell else {
            return UITableViewCell()
        }
        cell.optionLabel.text = options[indexPath.row]
        cell.radioButton.isSelected = indexPath.row == selectedOptionIndex
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOptionIndex = indexPath.row
        tableView.reloadData()
    }
    
    private func loadSelectedOption() {
        if let savedIndex = SettingsManager.shared.loadSelectedOption() {
            selectedOptionIndex = savedIndex
            tableView.reloadData()
        }
    }
    
    @objc private func saveSelection() {
        guard let index = selectedOptionIndex else { return }
        SettingsManager.shared.saveSelectedOption(index)
    }
    
    @objc
    func backPressed() {
        coordinator?.backPressed()
    }
}


// MARK: - Custom Cell

class NotificationOptionCell: UITableViewCell {
    
    static let reuseId = "NotificationOptionCell"
    
    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonNotSelected"), for: .normal)
        button.setImage(UIImage(named: "buttonSelected"), for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(optionLabel)
        contentView.addSubview(radioButton)
        
        radioButton.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        optionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        radioButton.isSelected = false
    }
}
