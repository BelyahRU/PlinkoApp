
import Foundation
import UIKit

extension AddTargetViewController: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TargetCell.self, forCellReuseIdentifier: TargetCell.reuseId)
        
        
        tableView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-40)
            if UIScreen.main.bounds.height < 800 {
                make.leading.equalToSuperview().offset(10)
                make.top.equalTo(targetsBackImageView).offset(115)
            } else {
                make.leading.equalToSuperview().offset(20)
                make.top.equalTo(targetsBackImageView).offset(126)
            }
            make.bottom.equalTo(saveTargetButton.snp.top)
            make.centerX.equalToSuperview()
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TargetCell.reuseId, for: indexPath) as? TargetCell else {
            return UITableViewCell()
        }
        cell.numberLabel.text = "\(indexPath.row + 1) "
        cell.backgroundColor = .clear
        cell.textField.text = targetTexts[indexPath.row]
        cell.textField.tag = indexPath.row
        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, let row = textField.tag as Int? {
            targetTexts[row] = text // Сохраняем текст в массиве
        }
    }

}
