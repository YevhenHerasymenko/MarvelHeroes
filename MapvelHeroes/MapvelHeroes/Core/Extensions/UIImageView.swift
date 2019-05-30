//
//  UIImageView.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/30/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit

/// took help from jamesrochabrun Link https://github.com/jamesrochabrun/JSONTutorialFinal

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

  func imageFromServerURL(_ urlString: String?, placeHolder: UIImage?) {
    self.image = nil
    guard let urlString = urlString else {
      return
    }
    if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
      self.image = cachedImage
      return
    }

    if let url = URL(string: urlString) {
      URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in

        //print("RESPONSE FROM API: \(response)")
        if error != nil {
          print("ERROR LOADING IMAGES FROM URL: \(error.debugDescription)")
          DispatchQueue.main.async {
            self.image = placeHolder
          }
          return
        }
        DispatchQueue.main.async {
          if let data = data {
            if let downloadedImage = UIImage(data: data) {
              imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
              self.image = downloadedImage
            }
          }
        }
      }).resume()
    }
  }
}
