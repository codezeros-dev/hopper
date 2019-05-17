//
//  ShowMixerViewController.swift
//  iOSProver
//
//  Created by Olivier van den Biggelaar on 17/05/2019.
//  Copyright © 2019 Olivier van den Biggelaar. All rights reserved.
//

import Foundation
import UIKit

class ShowMixerViewController: UIViewController {
    
    // MARK: - Public API
    
    var mixerAddress: String? { didSet { updateUI() } }
    
    // MARK: - UI
    
    @IBOutlet weak var qrCodeLabel: UILabel!  { didSet { updateUI() } }
    @IBOutlet weak var qrCodeImageView: UIImageView!  { didSet { updateUI() } }
    
    private func updateUI() {
        guard let mixerAddress = mixerAddress else { return }
        qrCodeImageView?.image = generateQRCode(from: mixerAddress)
        qrCodeLabel?.text = mixerAddress
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    private func copyAddress() {
        UIPasteboard.general.string = mixerAddress
        
        // Show Alert
        let alert: UIAlertController = UIAlertController(
            title: "Address Copied",
            message: "The Mixer address has been copied to your clipboard.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        copyAddress()
    }
    
    // MARK: - Navigation
    
    @IBAction func close(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

