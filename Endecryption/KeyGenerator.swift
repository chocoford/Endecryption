//
//  KeyGenrator.swift
//  Endecryption
//
//  Created by Dove·Z on 2018/5/11.
//  Copyright © 2018年 Dove·Z. All rights reserved.
//

import Foundation

struct RsaKeyGenerator {
    let n: Int
    let p: Int
    let q: Int
    
    init(p: Int, q: Int) {
        self.n = p * q
        self.p = p
        self.q = q
    }
    
    var 𝜑: Int {
        return (p - 1) * (q - 1)
    }
    
    func genratePrime(_ num: Int) -> [Int] {
//        DispatchQueue.global().async {
//            let primes = Int.prime(upto: num)
//            DispatchQueue.main.async {
//                return primes
//            }
//        }
        return Int.prime(upto: num)
//        return []
    }
    
    func genrateKey(with sk: Int) -> (KU: (pk: String, n: String), KR: (sk: String, n: String)) {
        let n = p * q
        let fi = (p-1) * (q-1)
        guard fi > 0 else { return (("nan", "nan"),("nan", "nan"))}
        let pk = sk.inverse(mod: fi)
        return ((String(pk), String(n)), (String(sk), String(n)))
    }
    
}
