//
//  UIImageView+Helper.swift
//  shushu-mushu
//
//  Created by Pavlin Panayotov on 21.02.18.
//  Copyright © 2018 Natali Arabdziyska. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            image = cachedImage
            return
        }
        
        
        guard let url = URL(string: urlString) else {
            // invalid url
            return
        }
        
        //otherwise fire off a new download
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            //download hit an error so lets return out
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let downloadedImage = UIImage(data: data!) else {
                    return
                }
                
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                
                self?.image = downloadedImage
            }
        }).resume()
    }
}

