import Foundation
import UIKit

class LoadingView: UIView {
    
    private let back = UIImageView(image:
            UIImage(named: Resources.Backgrounds.mainBackround))
    
    private let logoImage: UIImageView = {
       let im = UIImageView()
        im.image = UIImage(named: "loadingLogo")
        im.contentMode = .scaleAspectFit
        return im
    }()
    public var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
        progressView.layer.cornerRadius = 2
        progressView.layer.masksToBounds = true
        progressView.trackTintColor = .clear
        progressView.backgroundColor = .white
        progressView.setProgress(0.0, animated: false)
        return progressView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font =  UIFont.systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.66)
        return label
    }()
    
    private var timer: Timer?
    private var timerCounter: Float = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLoading()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(back)
        addSubview(textLabel)
        addSubview(logoImage)
        addSubview(progressView)
        
        back.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(316)
            make.height.equalTo(126)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        progressView.snp.makeConstraints { make in
            make.width.equalTo(283)
            make.height.equalTo(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom).offset(40)
        }
        
    }
    
    public func setupLoading() {
        timerCounter = 3
        progressView.layoutIfNeeded()
        progressView.setProgress(0, animated: false)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            self.timerCounter += 0.2
            if self.timerCounter >= 3{
                timer.invalidate()
            }
            let progress = self.timerCounter
            self.progressView.setProgress(progress, animated: true)
        }
    }
}
