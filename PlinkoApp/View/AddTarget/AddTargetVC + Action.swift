
import Foundation
import UIKit

extension AddTargetViewController {
    func setupButtons() {
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        saveTargetButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
    }
    
    @objc
    func backPressed() {
        coordinator?.backPressed()
    }
    
    @objc
    func savePressed() {
        viewModel.addTarget(name: textField.text ?? "Unknown", arrGoals: targetTexts)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.coordinator?.backPressed()
        }
        print(GoalManager.shared.getAllBlocks())
    }
}
