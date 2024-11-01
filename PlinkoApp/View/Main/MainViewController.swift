
import UIKit

final class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let loadView = LoadingView()
    let viewModel = MainViewModel()
    let mainView = MainView()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.targetsCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadView)
        loadView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadView.setupLoading()
        DispatchQueue.main.asyncAfter(deadline: .now()+3.2) {
            self.loadView.isHidden = true
            self.configure()
        }
    }

    private func configure() {
        setupUI()
        setupButtons()
        setupCollectionView()
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
