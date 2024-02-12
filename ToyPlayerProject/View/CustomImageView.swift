//
//  UIImageView+extension.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/24/24.
//

import Foundation
import UIKit

class CustomImageView: UIImageView{
    
    
    var task: URLSessionDataTask!
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "default_thum_vod_movie_list")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.image = UIImage(named: "default_thum_vod_movie_list")
    }
    
    func loadImage(imageUrl: String){
        image = nil
        let urlstr = (imageUrl == "") ? ImageURL.BACK_IMAGE_BLUREFFECT : imageUrl
        let ssl = URL(string: urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.applySSL())!
        let placeholderImageView = UIImageView(image: UIImage(named: "default_thum_vod_movie_list"))
        placeholderImageView.contentMode = .scaleAspectFit
        placeholderImageView.backgroundColor = .black
        if let task = task{
            task.cancel()
        }
        
        //        if let imageFromCache = imageCache.object(forKey: ssl.absoluteString as AnyObject) as? UIImage{
        //            self.image = imageFromCache
        //            return
        //        }
        
        task = URLSession.shared.dataTask(with: ssl) { data, response, error in
            if let error = error as NSError?, error.code == NSURLErrorCancelled{
                return
            }
            guard let data = data, let newImage = UIImage(data: data) else {
                print("\(ssl) load fail...")
                return
            }
            //            self.imageCache.setObject(newImage, forKey: ssl.absoluteString as AnyObject)
            
            DispatchQueue.main.async{
                self.image = newImage
            }
        }
        
        task.resume()
    }
}


