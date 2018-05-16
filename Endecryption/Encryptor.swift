//
//  Encryptor.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/2.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Foundation

struct Encryptor {
    let plaintext: String
    var key: String?
    
    var count: Int {
        return Encryptor.validCharacter.count
    }
    
    static let validCharacter: [Character] = {
        var characters = [Character]()
        for i in 32...127 {
            characters.append(Character.init(UnicodeScalar.init(i)!))
        }
        return characters
    }()
    
    
    init(_ plaintext: String, key: String? = nil) {
        self.plaintext = plaintext
        self.key = key == "" ? nil: key
    }
    
    func transposition() -> String {
        return ""
    }
    
    func multiple() -> String {
        var cryptograph = ""
        guard key != nil,
            let key = Int(key!) else {
                return "IN THIS KIND OF ENCRIPTION, KEY MUST BE A NUMBER"
        }
        guard key.isRelativelyPrime(with: count) else {
            return "THE KEY MUST BE A PRIME ACCORDING TO THE NUMBER OF VALID CHARACTER"
        }
        for e in plaintext {
            if e == " " || e == "\n" {
                cryptograph.append(e)
                continue
            }
            cryptograph.append(Encryptor.validCharacter[Encryptor.validCharacter.index(of: e)! * key % count])
        }
        return cryptograph
    }
    
    func vingenère() -> String {
        var cryptograph = ""
        guard let keys = key?.split(separator: ","),
            !keys.isEmpty else {
            return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }
        
        do { //check for keys' validation
            for key in keys {
                if Int(key) == nil {
                    return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
                }
            }
        }
        
        let keysCount = keys.count
        var i = 0
        for e in plaintext {
            if e == "\n" {
                cryptograph.append(e)
                continue
            }
            cryptograph.append(Encryptor.validCharacter[(Encryptor.validCharacter.index(of: e)! + Int(keys[i])!) % count])
            i = (i + 1) % keysCount
        }
        return cryptograph
    }
    
    func affineCipher() -> String {
        var cryptograph = ""

        guard let keys = key?.split(separator: ","),
            keys.count == 2,
            let k0 = Int(keys[0]),
            let k1 = Int(keys[1]) else {
                return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }
        print(Int.prime(upto :121))
        for e in plaintext {
            if e == "\n" || e == " " {
                cryptograph.append(e)
                continue
            }
            print(e)
            cryptograph.append(Encryptor.validCharacter[(Encryptor.validCharacter.index(of: e)! * k1 + k0) % count])
        }
        
        return cryptograph
    }
    
    func rsa() -> String {
        var cryptograph = ""
        let length = plaintext.count
        print(length)
        let defaultSplit: Int = {
            for i in 2..<length {
                if length % i == 0 {
                    return i
                }
            }
            return 1
        }()
        guard let keys = key?.split(separator: ","),
            keys.count >= 2,
            keys.count <= 3,
            let sk = Int(keys[0]),
            let n = Int(keys[1]) else {
                return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }
        /// split num
        var m: Int = defaultSplit
        if keys.count == 3 {
            m = Int(keys[2])!
        }
        
        let splitedLength = length / m
        var splitedPlaintext = ""
        for (i, e) in plaintext.enumerated() {
            splitedPlaintext.append(e)
            if i % splitedLength == splitedLength - 1 {
                print(splitedPlaintext)
                cryptograph.append("\(Int(splitedPlaintext)!.powMod(pow: sk, mod: n))")
                splitedPlaintext = ""
            }
            
        }
        return cryptograph
    }
    
    private func gcd() -> Int {
        return 1
    }
    
    func des() -> (string: String, data: Data) {
        let key: String = {
            let randomStringArray: [Character] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".map({$0})
            var string = ""
            for _ in (1...kCCKeySize3DES) {
                string.append(randomStringArray[Int(arc4random_uniform(
                    UInt32(randomStringArray.count) - 1))])
            }
            return string
        }()
        let inputData : Data = plaintext.data(using: String.Encoding.utf8)!
        
        let keyData: Data = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        
        let cryptStatus = CCCrypt(
            UInt32(kCCEncrypt),
            UInt32(kCCAlgorithm3DES),
            UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding),
            keyBytes,
            keyLength,
            nil,
            dataBytes,
            dataLength,
            bufferPointer,
            bufferLength,
            &bytesDecrypted)
        
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.length = bytesDecrypted
            var dec = Decryptor.init("")
            dec.key = key
            
            return ("随机生成的密钥为\(key)\n解密结果为\(dec.des(bufferData as Data))", bufferData as Data)
        } else {
            return ("加密过程出错: \(cryptStatus)", Data())
        }
    }
    
}





extension Int {
    ///generate the primes between 2 and spcified upper limit (not include the upper limit)
    static func prime(upto upperLimit: Int) -> [Int] {
        var results: [Int] = {
            var result = [Int]()
            for i in 2..<upperLimit {
                result.append(i)
            }
            return result
        }()
        
        var i = 2
        while pow(Double(i), 2) <= Double(upperLimit) {
            print(results.suffix(from: i-2).count)
            for j in results.suffix(from: i-2) {
                if j * i > upperLimit { break }
                
                if let index = results.index(of: j * i) {
                    results.remove(at: index)
                }
            }
            i += 1
        }
        
        return results
    }
    
    func powMod(pow: Int, mod: Int) -> Int {
        var result = self
        /// (pow - 1) times
        for _ in 1..<pow {
            result = (result * self) % mod
        }
        return result
    }
}













