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
    
    func rsa() -> String {
        var cryptograph = ""
        
        guard let keys = key?.split(separator: ","),
            keys.count == 2,
            let p = Int(keys[0]),
            let q = Int(keys[1]) else {
                return "INVALID KEY. CHECK IF YOU HAVE INPUT KEYS WITH WRONG FORMAT"
        }

        let fi = (p-1) * (q-1)
        
//        print(Int.prime(upto: fi))
        
        
        return Int.prime(upto: fi).description
    }
    
    private func gcd() -> Int {
        return 1
    }
    
    
    
}

extension Int {
    ///generate the primes between 2 and spcified upper limit
    static func prime(upto upperLimit: Int) -> [Int] {
        var results: [Int] = {
            var result = [Int]()
            for i in 2...upperLimit {
                result.append(i)
            }
            return result
        }()
        
        var i = 2
//        var ndx = 0
        while pow(Double(i), 2) <= Double(upperLimit) {
            for j in i..<upperLimit {
                if j * i > upperLimit { break }
                if let index = results.index(of: j * i) {
                    results.remove(at: index)
                }
            }
            i += 1
        }
        
        return results
    }
}














