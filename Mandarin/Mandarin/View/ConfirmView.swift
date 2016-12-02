//
//  ConfirmView.swift
//  BinarySwipe
//
//  Created by Yuriy on 6/23/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation

class ConfirmView: UIView {
    
    static let sharedInctance = ConfirmView()

    var updateBlock: Block?
    internal let contentView = UIView()
    
    internal let cancelButton = Button(icon: "Cancel".ls, font: UIFont.boldSystemFont(ofSize: 13.0), textColor: UIColor.white)
    internal let approveButton = Button(icon: "Approve".ls, font: UIFont.boldSystemFont(ofSize: 13.0), textColor: UIColor.white)
    internal let titleView = UIView()
    internal let signalSettingsView = UIView()
    internal let successView = UIView()
    internal let timer = Label()
    internal let expirityTimeLabel = Label()
    internal let timeValueLabel = Label()
    internal let assetLabel = Label()
    internal let assetValueLabel = Label()
    internal let rateLabel = Label()
    internal let ratePositionLabel = Label(icon: "r", size: 10.0, textColor: Color.green)
    internal let rateValueLabel = Label()
    internal let investmentLabel = Label()
    internal let investmentValueLabel = Label()
    internal let payoutLabel = Label()
    internal let payoutValueLabel = Label()
    internal let successImageView = UIImageView()
    internal let successLabel = Label()
    
    internal var approveBlock: Block?
    internal var cancelBlock: Block?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.75)
        contentView.cornerRadius = 5.0
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.white
        add(contentView) { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
            make.width.equalTo(self).inset(30)
        }
        cancelButton.highlightedColor = Color.gray.withAlphaComponent(0.5)
        approveButton.highlightedColor = Color.green.withAlphaComponent(0.5)
        cancelButton.backgroundColor = Color.gray
        approveButton.backgroundColor = Color.green
        cancelButton.addTarget(self, touchUpInside: #selector(self.cancel(_:)))
        approveButton.addTarget(self, touchUpInside: #selector(self.approve(_:)))
        cancelButton.layer.cornerRadius = 5.0
        approveButton.layer.cornerRadius = 5.0
        timer.textColor = UIColor.white
        timer.textAlignment = .center
        contentView.add(titleView) {
            $0.leading.top.trailing.equalTo(contentView)
            $0.height.equalTo(40)
        }
        titleView.add(timer) {
            $0.center.equalTo(titleView)
        }
        setupSingalSettingsView()
    }
    
    func setupSingalSettingsView() {
        signalSettingsView.isHidden = false
        successView.isHidden = true
        titleView.backgroundColor = Color.caral
        contentView.add(signalSettingsView, {
            $0.leading.bottom.trailing.equalTo(contentView)
            $0.top.equalTo(titleView.snp.bottom)
        })
        signalSettingsView.add(cancelButton) {
            $0.leading.bottom.equalTo(contentView).inset(20)
            $0.height.equalTo(40)
        }
        signalSettingsView.add(approveButton) {
            $0.trailing.bottom.equalTo(contentView).inset(20)
            $0.leading.equalTo(cancelButton.snp.trailing).inset(-20)
            $0.size.equalTo(cancelButton)
        }
        signalSettingsView.add(specify(expirityTimeLabel, {
            $0.text = "Expirity Time"
            $0.textColor = Color.gray
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.trailing.equalTo(cancelButton)
        })
        signalSettingsView.add(specify(timeValueLabel, {
            $0.text = "27.07.16 20:15:00"
            $0.textColor = Color.darkBlue
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.centerY.equalTo(expirityTimeLabel)
            $0.leading.equalTo(approveButton)
        })
        signalSettingsView.add(specify(assetLabel, {
            $0.text = "Asset"
            $0.textColor = Color.gray
            $0.font = UIFont.boldSystemFont(ofSize:13.0)
        }), {
            $0.top.equalTo(expirityTimeLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(cancelButton)
        })
        signalSettingsView.add(specify(assetValueLabel, {
            $0.textColor = Color.darkBlue
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.centerY.equalTo(assetLabel)
            $0.leading.equalTo(approveButton)
        })
        signalSettingsView.add(specify(rateLabel, {
            $0.text = "Rate"
            $0.textColor = Color.gray
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.top.equalTo(assetLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(cancelButton)
        })
        signalSettingsView.add(ratePositionLabel, {
            $0.leading.equalTo(approveButton)
            $0.centerY.equalTo(rateLabel)
        })
        signalSettingsView.add(specify(rateValueLabel, {
            $0.textColor = Color.darkBlue
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.centerY.equalTo(rateLabel)
            $0.leading.equalTo(ratePositionLabel.snp.trailing).offset(5)
        })
        
        signalSettingsView.add(specify(investmentLabel, {
            $0.text = "Investment"
            $0.textColor = Color.gray
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.top.equalTo(rateLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(cancelButton)
        })
        signalSettingsView.add(specify(investmentValueLabel, {
            $0.textColor = Color.darkBlue
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.centerY.equalTo(investmentLabel)
            $0.leading.equalTo(approveButton)
        })
        signalSettingsView.add(specify(payoutLabel, {
            $0.text = "Payout"
            $0.textColor = Color.gray
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.top.equalTo(investmentLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(cancelButton)
            $0.bottom.equalTo(cancelButton.snp.top).offset(-20)
        })
        signalSettingsView.add(specify(payoutValueLabel, {
            $0.textColor = Color.darkBlue
            $0.font = UIFont.boldSystemFont(ofSize: 13.0)
        }), {
            $0.centerY.equalTo(payoutLabel)
            $0.leading.equalTo(approveButton)
        })
    }
    
    func setupSuccessView() {
        updateBlock = nil
        titleView.backgroundColor = Color.green
        timer.text = "00:00:00"
        signalSettingsView.isHidden = true
        successView.isHidden = false
        contentView.add(successView, {
            $0.leading.bottom.trailing.equalTo(contentView)
            $0.top.equalTo(titleView.snp.bottom)
        })
        successView.add(specify(successImageView, {
            $0.image = UIImage(named: "v")
        }), {
            $0.centerX.equalTo(successView)
            $0.centerY.equalTo(successView).offset(-30)
            $0.size.equalTo(100)
        })
        successView.add(specify(successLabel, {
            $0.text = "Success!"
            $0.textColor = Color.green
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 21.0)
        }), {
            $0.centerX.equalTo(successView)
            $0.top.equalTo(successImageView.snp.bottom).offset(10)
        })
    }
    
    func setupSignal() {
//        let signal = Signal.sharedInctance
//        timer.text = signal.remainTimeInterval.remainTime()
//        assetValueLabel.text = signal.asset
//        ratePositionLabel.contentMode = signal.isCall == true ? .left : .right
//        ratePositionLabel.rotate = true
//        rateValueLabel.text = signal.rate
//        investmentValueLabel.text = User.currentUser?.preferedAmountTrade
//        payoutValueLabel.text = "$\(signal.profit ?? "")"
//        
//        Signal.notifier.subscribe(self, block: { [weak self] _, signal in
//            Dispatch.mainQueue.async { _ in
//                self?.timer.text = signal.remainTimeInterval.remainTime()
//            }
//            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showInView(_ view: UIView, success: Block? = nil, cancel: Block? = nil) {
        self.approveBlock = success
        self.cancelBlock = cancel
        frame = view.frame
        view.addSubview(self)
        backgroundColor = UIColor.clear
        contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        contentView.alpha = 0.0
        setupSignal()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn , animations: { _ in
            self.contentView.transform = CGAffineTransform.identity
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn , animations: { () -> Void in
            self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            self.contentView.alpha = 1.0
            }, completion: nil)
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseIn , animations: { _ in
            self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.contentView.alpha = 0.0
            self.backgroundColor = UIColor.clear
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    internal func cancel(_ sender: AnyObject) {
        cancelBlock?()
        hide()
    }
    
    internal func approve(_ sender: AnyObject) {
//        SignalRequest.aproveTrade {[weak self] json in
//            if let result = json?["result"] , result == true {
//                UserRequest.getStatistics()
//                self?.setupSuccessView()
//                Dispatch.mainQueue.after(3.0, block: {
//                    self?.hide()
//                    self?.approveBlock?()
//                    Dispatch.mainQueue.after(1.0, block: {
//                        self?.setupSingalSettingsView()
//                    })
//                })
//            } else {
//                self?.hide()
//            }
//        }
    }
}
