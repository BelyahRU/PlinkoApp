
import Foundation
import UIKit

extension MainViewController {
    
    public func setupButtons() {
        mainView.achievmentsButton.addTarget(self, action: #selector(achievmentsPressed), for: .touchUpInside)
        mainView.addTargetButton.addTarget(self, action: #selector(addNewTargetPressed), for: .touchUpInside)
        mainView.infoButton.addTarget(self, action: #selector(infoPressed), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
    }
    
    @objc
    func addNewTargetPressed() {
        print("LOGGER: addNewTarget pressed")
        coordinator?.showAddTarget()
    }
    
    @objc
    func settingsPressed() {
        print("LOGGER: settings pressed")
        coordinator?.showSettings()
    }
    
    @objc
    func infoPressed() {
        print("LOGGER: info pressed")
        coordinator?.showInfo()
    }
    
    @objc
    func achievmentsPressed() {
        print("LOGGER: achievments pressed")
    }
}
