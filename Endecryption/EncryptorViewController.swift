//
//  EncryptorViewController.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/10.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Cocoa

class EncryptorViewController: EndecryptorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        inputLabel.stringValue = "明文"
        outputLabel.stringValue = "密文"
    }
    
    override func endecrypt() {
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
        case "DES":
            (cryptographScrollView.contentView.documentView as! NSTextView).string = encryptor.des().0
        default:
            break
        }
    }
    
}
