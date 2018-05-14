//
//  ViewController.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/2.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Cocoa

class EndecryptorViewController: NSViewController {
    ///For Encrypting
    @IBOutlet weak var plaintextField: NSTextField!
    @IBOutlet weak var keyField: NSTextField!
    @IBOutlet weak var cryptographScrollView: NSScrollView!
    @IBOutlet weak var encryptoStyle: NSPopUpButton!
    @IBOutlet weak var inputLabel: NSTextField!
    @IBOutlet weak var outputLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func encrypt(_ sender: NSButton) {
        endecrypt()
    }
    ///
    func endecrypt() {
        fatalError("must rewrite on your own subclass.")
    }
    
}

