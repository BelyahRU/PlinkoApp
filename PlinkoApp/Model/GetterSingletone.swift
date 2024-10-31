
import Foundation
import UIKit

class GetterSingletone {
    
    static let shared = GetterSingletone()
    
    private init() {}
    
    var currentArray:[Int] = []
}
