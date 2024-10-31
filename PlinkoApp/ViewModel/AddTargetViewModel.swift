
import Foundation
import UIKit

class AddTargetViewModel {
    
    let goalManager = GoalManager.shared
    
    func addTarget(name: String, arrGoals: [String]) {
        let updatedGoals = arrGoals.map { $0.isEmpty ? "None" : $0 }
        
        let block = GoalBlock(name: name)
        
        for i in 0..<updatedGoals.count {
            block.updateGoal(at: i, isDone: false, text: updatedGoals[i])
        }
        goalManager.addBlock(block: block)
    }
}
