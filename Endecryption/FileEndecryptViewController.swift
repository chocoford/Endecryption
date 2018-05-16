//
//  FileEndecryptViewController.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/16.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Cocoa

class FileEndecryptViewController: NSViewController {
    @IBOutlet weak var inputFilePathTextField: NSTextField!
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var behaviorStyle: NSPopUpButton!
    @IBOutlet weak var cryptType: NSPopUpButton!
    @IBOutlet weak var commitButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var previewScrollView: NSScrollView!
    
    var inputFile: String! {
        didSet {
            if !commitButton.isEnabled {
                commitButton.isEnabled = true
                saveButton.isEnabled = true
            }
        }
    }
    var inputData: Data! {
        didSet {
            if !commitButton.isEnabled {
                commitButton.isEnabled = true
                saveButton.isEnabled = true
            }
        }
    }
    var outputFile: String!
    var outputData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        commitButton.isEnabled = false
        saveButton.isEnabled = false
    }
    
    @IBAction func openFile(_ sender: NSButton) {
        let openPanel = NSOpenPanel.init()
        if openPanel.runModal() == .OK {
            let url = openPanel.url!
            do {
                if url.path.hasSuffix(".txt") {
                    inputFile = try String.init(contentsOf: url)
                    inputFilePathTextField.stringValue = url.path
                } else {
                    inputData = try Data.init(contentsOf: url)
                    inputFilePathTextField.stringValue = url.path
                }

            } catch {
                inputFilePathTextField.stringValue = "cannot open such a file."
                commitButton.isEnabled = false
                saveButton.isEnabled = false
                return
            }
            
            
        }
    }
    
    @IBAction func commit(_ sender: NSButton) {
        switch behaviorStyle.selectedItem?.title {
        case "encrypt":
            let encryptor = Encryptor.init(inputFile, key: keyTextField.stringValue)
            switch cryptType.selectedItem?.title {
            case "Affine Cipher":
                outputFile = encryptor.affineCipher()
            case "Multiplication Cipher":
                outputFile = encryptor.multiple()
            case "Vingenère":
                outputFile = encryptor.vingenère()
            case "RSA":
                outputFile = encryptor.rsa()
            case "DES":
                let result = encryptor.des()
                outputFile = result.string
                outputData = result.data
            default: break
            }
        case "decrypt":
            let decryptor = Decryptor.init(inputFile, key: keyTextField.stringValue)
            switch cryptType.selectedItem?.title {
            case "Affine Cipher":
                outputFile = decryptor.affineCipher()
            case "Multiplication Cipher":
                outputFile = decryptor.multiple()
            case "Vingenère":
                outputFile = decryptor.vingenère()
            case "RSA":
                outputFile = decryptor.rsa()
            case "DES":
                outputFile = decryptor.des(inputData)
                break
            default: break
            }
        default:
            break
        }
        
        (previewScrollView.contentView.documentView as! NSTextView).string = outputFile
        
    }
    @IBAction func save(_ sender: NSButton) {
        let savePanel = NSSavePanel.init()
        savePanel.title = "save output"
        savePanel.nameFieldStringValue = "untitled.txt"
        if savePanel.runModal() == .OK {
            if cryptType.selectedItem!.title == "DES" {
                FileManager.default.createFile(atPath: savePanel.url!.path, contents: outputData, attributes: nil)
            } else {
                FileManager.default.createFile(atPath: savePanel.url!.path, contents: outputFile.data(using: .utf8)!, attributes: nil)
            }
            
        }
    }
    
}
