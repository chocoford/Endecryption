//
//  ViewController.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/2.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    ///For Encrypting
    @IBOutlet weak var plaintextField: NSTextField!
    @IBOutlet weak var keyField: NSTextField!

    @IBOutlet weak var cryptographScrollView: NSScrollView!
    
    
    @IBOutlet weak var encryptoStyle: NSPopUpButton!
    
    @IBOutlet weak var inputLabel: NSTextField!
    @IBOutlet weak var outputLabel: NSTextField!
    @IBOutlet weak var cryptionType: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func cryptionActionDidChange(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            inputLabel.stringValue = "明文"
            outputLabel.stringValue = "密文"
        case 1:
            inputLabel.stringValue = "密文"
            outputLabel.stringValue = "明文"
        default:
            break
        }
    }
    
    @IBAction func encrypt(_ sender: NSButton) {
        
        
        switch cryptionType.selectedSegment {
        case 0:
            var encryptor = Encryptor.init(plaintextField.stringValue)
            encryptor.key = keyField.stringValue == "" ? nil : keyField.stringValue
            switch encryptoStyle.selectedItem?.title {
            case "Affine Cipher":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = encryptor.affineCipher()
            case "Multiplication Cipher":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = encryptor.multiple()
            case "Vingenère":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = encryptor.vingenère()
            case "RSA":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = encryptor.rsa()
            default:
                break
            }
        case 1:
            var decryptor = Decryptor.init(plaintextField.stringValue)
            decryptor.key = keyField.stringValue == "" ? nil : keyField.stringValue
            switch encryptoStyle.selectedItem?.title {
            case "Affine Cipher":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.affineCipher()
            case "Multiplication Cipher":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.multiple()
            case "Vingenère":
                (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.vingenère()
//            case "RSA":
//                (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.rsa()
            default:
                break
            }
            
        default:
            fatalError()
        }
        

    }
    
    
    
}

