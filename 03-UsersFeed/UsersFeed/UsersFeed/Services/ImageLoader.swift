
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 30
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async { completion(cachedImage) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data, let downloadedImage = UIImage(data: data), error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            self?.cache.setObject(downloadedImage, forKey: cacheKey)

            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }.resume()
    }
}
