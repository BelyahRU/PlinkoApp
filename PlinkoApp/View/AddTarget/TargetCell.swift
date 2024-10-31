
import Foundation
import UIKit
import SnapKit

class TargetCell: UITableViewCell {
    
    static let reuseId = "TargetCell"
    
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "   Enter your goal"
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    let targetBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.52)
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
        self.selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCellLayout() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(targetBackView)
        contentView.addSubview(textField)
        numberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        targetBackView.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(286)
            make.height.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(targetBackView.snp.top)
            make.trailing.equalTo(targetBackView.snp.trailing)
            make.bottom.equalTo(targetBackView.snp.bottom)
            make.leading.equalTo(targetBackView.snp.leading).offset(10)
        }
        
    }
}
