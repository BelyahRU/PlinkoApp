
import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController!
    var mainViewController: MainViewController!
    var gameViewController: GameScreenViewController!
    var infoViewController: InfoViewController!
    var addTargetViewController: AddTargetViewController!
    var settingsViewController: NotificationSettingsViewController!
    
    func start() {
        showMain()
    }
    
    func showMain() {
        mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showGame(blockId: Int) {
        gameViewController = GameScreenViewController()
        gameViewController.coordinator = self
        gameViewController.currentBlock = blockId
        navigationController.pushViewController(gameViewController, animated: true)
    }
    
    func showInfo() {
        infoViewController = InfoViewController()
        infoViewController.coordinator = self
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
    func backPressed() {
        navigationController.popViewController(animated: true)
    }
    
    func showAddTarget() {
        addTargetViewController = AddTargetViewController()
        addTargetViewController.coordinator = self
        navigationController.pushViewController(addTargetViewController, animated: true)
    }
    
    func showSettings() {
        settingsViewController = NotificationSettingsViewController()
        settingsViewController.coordinator = self
        navigationController.pushViewController(settingsViewController, animated: true)
    }
}
