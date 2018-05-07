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
    
    static let validCharacter: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    init(_ cryptograph: String) {
        self.cryptograph = cryptograph
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
            if e == " " {
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
            if e == " " {
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
            if e == " " {
                plaintext.append(e)
                continue
            }
            plaintext.append(Encryptor.validCharacter[(Decryptor.validCharacter.index(of: e)! * key.inverse(mod: count)) % count])
        }
        return plaintext
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









