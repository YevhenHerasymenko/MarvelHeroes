//
//  Crypto.swift
//  MarvelHeroesCore
//
//  Created by Yevhen Herasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import Foundation
import CommonCrypto

enum Crypto {

  static func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    guard let messageData = string.data(using: .utf8) else {
      fatalError("Incorrect data building from message")
    }
    var digestData = Data(count: length)

    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
      messageData.withUnsafeBytes { messageBytes -> UInt8 in
        if let messageBytesBaseAddress = messageBytes.baseAddress,
          let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
          let messageLength = CC_LONG(messageData.count)
          CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
        }
        return 0
      }
    }
    return digestData
  }

}
