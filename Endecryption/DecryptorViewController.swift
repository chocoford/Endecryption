//
//  DecryptorViewController.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/10.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Cocoa

class DecryptorViewController: EndecryptorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        inputLabel.stringValue = "密文"
        outputLabel.stringValue = "明文"
    }
    
    override func endecrypt() {
        var decryptor = Decryptor.init(plaintextField.stringValue)
        decryptor.key = keyField.stringValue == "" ? nil : keyField.stringValue
        switch encryptoStyle.selectedItem?.title {
        case "Affine Cipher":
            (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.affineCipher()
        case "Multiplication Cipher":
            (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.multiple()
        case "Vingenère":
            (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.vingenère()
        case "RSA":
            (cryptographScrollView.contentView.documentView as! NSTextView).string = decryptor.rsa()
        default:
            break
        }
    }
}
