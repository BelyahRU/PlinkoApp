import UIKit
import SnapKit

final class AddTargetViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    var targetTexts: [String] = Array(repeating: "", count: 10) // Массив для хранения текстов
    var viewModel = AddTargetViewModel()

    let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    
    let backgroundImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "longBack")
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    let targetsBackImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "addTargetBack")
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    let saveTargetButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "saveTargetButton"), for: .normal)
        return button
    }()
    
    let targetBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.52)
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your target"
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.backgroundColor = .clear
        return tf
    }()
    
    public let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setupUI()
        setupTableView()
        setupButtons()
    }

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(targetsBackImageView)
        view.addSubview(saveTargetButton)
        view.addSubview(backButton)
        view.addSubview(targetBackView)
        view.addSubview(textField)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(188)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        targetsBackImageView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.centerX.equalToSuperview()
            if UIScreen.main.bounds.height < 800 {
                make.height.equalTo(580)
            }
            make.height.equalTo(654)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        targetBackView.snp.makeConstraints { make in
            if UIScreen.main.bounds.height < 800 {
                make.top.equalTo(targetsBackImageView.snp.top)
            } else {
                make.top.equalTo(targetsBackImageView.snp.top).offset(16)
            }
            make.leading.equalTo(targetsBackImageView.snp.leading).offset(16)
            make.trailing.equalTo(targetsBackImageView.snp.trailing).offset(-16)
            make.height.equalTo(52)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(targetBackView.snp.top).offset(5)
            make.leading.equalTo(targetBackView.snp.leading).offset(10)
            make.trailing.equalTo(targetBackView.snp.trailing).offset(-5)
            make.bottom.equalTo(targetBackView.snp.bottom).offset(-5)
        }
        
        saveTargetButton.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(targetsBackImageView.snp.bottom).offset(-16)
        }
        
    }

}
