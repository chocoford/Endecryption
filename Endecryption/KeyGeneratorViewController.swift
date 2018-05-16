//
//  KeyGenratorViewController.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/11.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Cocoa

class KeyGeneratorViewController: NSViewController {

    @IBOutlet weak var pTextField: NSTextField!
    @IBOutlet weak var qTextField: NSTextField!
    
    @IBOutlet weak var 𝜑Value: NSTextField!
    @IBOutlet weak var primeGenratingLoadingAnimator: NSProgressIndicator!
    
    @IBOutlet weak var skValue: NSTextField!
    @IBOutlet weak var skValueSlider: NSSlider!
    @IBOutlet weak var pkValue: NSTextField!
    
    @IBOutlet weak var publicKeyTextField: NSTextField!
    @IBOutlet weak var privateKeyTextField: NSTextField!
    @IBOutlet weak var logScrollView: NSScrollView!
    @IBOutlet weak var generateKeyButton: NSButton!
    
    var rsaKeyGenerator: RsaKeyGenerator!
    
    var primes: [Int]! {
        didSet {
            skValueSlider.maxValue = Double(primes.count - 1)
            (logScrollView.contentView.documentView as! NSTextView).string = "please input sk with a prime number. The options are listed below:\n\(primes)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        skValue.isEditable = false
        skValueSlider.isEnabled = false
        generateKeyButton.isEnabled = false
    }
    
    func enableGenerateButton() {
        if !generateKeyButton.isEnabled {
            generateKeyButton.isEnabled = true
        }
    }
    
    @IBAction func generate(_ sender: NSButton) {
        guard let p = Int(pTextField.stringValue),
            let q = Int(qTextField.stringValue) else {
            return
        }
        rsaKeyGenerator = RsaKeyGenerator.init(p: p, q: q)
        do {
            𝜑Value.integerValue = rsaKeyGenerator.𝜑
            skValueSlider.isEnabled = true
            skValue.isEditable = true
        }
        primes = rsaKeyGenerator.genratePrime(rsaKeyGenerator.𝜑)
    }
    @IBAction func skValueSlider(_ sender: NSSlider) {
        enableGenerateButton()
        let sk = primes[sender.integerValue]
        skValue.stringValue = String(sk)
        pkValue.integerValue = sk.inverse(mod: rsaKeyGenerator.n)
    }
    
    @IBAction func skValueTextField(_ sender: NSTextField) {
        enableGenerateButton()
    }
    
    @IBAction func generateKey(_ sender: NSButton) {
        let result = rsaKeyGenerator.genrateKey(with: skValue.integerValue)
        publicKeyTextField.stringValue = "{ \(result.KU.pk), \(result.KU.n) }"
        privateKeyTextField.stringValue = "{ \(result.KR.sk), \(result.KR.n) }"
    }
    
    
    
}
