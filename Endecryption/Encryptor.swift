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
    
    static let validCharacter: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    init(_ plaintext: String) {
        self.plaintext = plaintext
        self.key = nil
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
            if e == " " {
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
            if e == " " {
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
            if e == " " {
                cryptograph.append(e)
                continue
            }
            cryptograph.append(Encryptor.validCharacter[(Encryptor.validCharacter.index(of: e)! * k1 + k0) % count])
        }
        
        return cryptograph
    }
    
    func rsaGenerator() -> String {
//        var cryptograph = ""
        
        guard let keys = key?.split(separator: ","),
            keys.count == 2,
            let p = Int(keys[0]),
            let q = Int(keys[1]) else {
                return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }
        let n = p * q
        let fi = (p-1) * (q-1)
        guard fi > 0 else { return "ERROR: FI IS EQUAL TO 0"}
//        print(Int.prime(upto: fi))
        
        let sk = 167
        let pk = sk.inverse(mod: fi)
        
        
        
//        return Int.prime(upto: fi).description
        return "KU = { \(pk), \(n) }  KR = { \(sk), \(n) }"
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
//        var ndx = 0
        while pow(Double(i), 2) <= Double(upperLimit) {
//            let resultsCopy = results
            print(results.suffix(from: i-2).count)
            for j in results.suffix(from: i-2) {
//                guard results.contains(j) else { continue }
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













