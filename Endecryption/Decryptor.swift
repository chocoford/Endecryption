//
//  Decryptor.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/5.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Foundation

struct Decryptor {
    let cryptograph: String
    
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
    
    init(_ cryptograph: String, key: String? = nil) {
        self.cryptograph = cryptograph
        self.key = key == "" ? nil : key
    }
    
    func affineCipher() -> String {
        var plaintext = ""
        
        guard let keys = key?.split(separator: ","),
            keys.count == 2,
            let k0 = Int(keys[0]),
            let k1 = Int(keys[1]) else {
                return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }
        
        guard k1.isRelativelyPrime(with: count) else {
            return "THE K1 MUST BE A PRIME ACCORDING TO THE NUMBER OF VALID CHARACTER"
        }
        
        print(Int.prime(upto :121))
        for e in cryptograph {
            if e == "\n" {
                plaintext.append(e)
                continue
            }
            plaintext.append(Encryptor.validCharacter[((Encryptor.validCharacter.index(of: e)! -  k0) * k1.inverse(mod: count)) % count])
        }
        
        return plaintext
    }
    
    func vingenère() -> String {
        var plaintext = ""
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
        for e in cryptograph {
            if e == "\n" {
                plaintext.append(e)
                continue
            }
            plaintext.append(Encryptor.validCharacter[(Decryptor.validCharacter.index(of: e)! - Int(keys[i])! + count) % count])
            i = (i + 1) % keysCount
        }
        return plaintext
    }
    
    func multiple() -> String {
        var plaintext = ""
        guard key != nil,
            let key = Int(key!) else {
                return "IN THIS KIND OF ENCRIPTION, KEY MUST BE A NUMBER"
        }
        
        guard key.isRelativelyPrime(with: count) else {
            return "THE KEY MUST BE A PRIME ACCORDING TO THE NUMBER OF VALID CHARACTER"
        }
        for e in cryptograph {
            if e == "\n" {
                plaintext.append(e)
                continue
            }
            plaintext.append(Encryptor.validCharacter[(Decryptor.validCharacter.index(of: e)! * key.inverse(mod: count)) % count])
        }
        return plaintext
    }
    
    func rsa() -> String {
        var plaintext = ""
        let length = cryptograph.count
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
            let pk = Int(keys[0]),
            let n = Int(keys[1]) else {
                return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }
        /// split num
        var m: Int = defaultSplit
        if keys.count == 3 {
            m = Int(keys[2])!
        }
        
        let splitedLength = length / m
        var splitedCryptograph = ""
        for (i, e) in cryptograph.enumerated() {
            splitedCryptograph.append(e)
            if i % splitedLength == splitedLength - 1 {
                print(splitedCryptograph)
                plaintext.append("\(Int(splitedCryptograph)!.powMod(pow: pk, mod: n))")
                splitedCryptograph = ""
            }
            
        }
        return plaintext
    }
    
    func des(_ inputData: Data) -> String{
//        let inputData = cryptograph.data(using: .utf8)!
        if key == nil {
            return "PLEASE INPUT KEY."
        }
        let keyData: Data = key!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = UnsafeMutableRawPointer(mutating: (keyData as NSData).bytes)
        let keyLength = size_t(kCCKeySize3DES)
        let dataLength = Int(inputData.count)
        let dataBytes = UnsafeRawPointer((inputData as NSData).bytes)
        let bufferData = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)!
        let bufferPointer = UnsafeMutableRawPointer(bufferData.mutableBytes)
        let bufferLength = size_t(bufferData.length)
        var bytesDecrypted = Int(0)
        
        let cryptStatus = CCCrypt(
            UInt32(kCCDecrypt),
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
            let clearDataAsString = NSString(data: bufferData as Data, encoding: String.Encoding.utf8.rawValue)
            return "解密后的内容：\(clearDataAsString! as String)"
        } else {
            return "解密过程出错: \(cryptStatus)"
        }
    }
    
}

extension Int {
    func inverse(mod: Int) -> Int {
        var calculent = mod
        var reminder = self
        var t: [Int] = [0, 1]
        var q: [Int] = [-1]
        
        var ndx = 0
        while reminder > 0 {
            q.append(calculent / reminder)
            let temp = calculent
            calculent = reminder
            reminder = temp % reminder
            
            if ndx >= 2 {
                t.append((t[ndx - 2] - q[ndx - 1] * t[ndx - 1]) % mod)
            }
            
            ndx += 1
        }
        if ndx == 1 {
            return t[1] % mod
        }
        return ((t[ndx - 2] - q[ndx - 1] * t[ndx - 1]) + mod) % mod
    }
    func isRelativelyPrime(with num: Int) -> Bool {
        var a = self
        var b = num
        if( a == 1 || b == 1 ) {
            return true
        }
        while(true){
            let t = a % b
            if(t == 0) {
                break
            } else{
                a = b
                b = t
            }
        }
        if( b > 1) {
            return false
        }
        return true
    }
}









