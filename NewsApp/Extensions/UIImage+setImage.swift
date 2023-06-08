import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Check if the image is cached
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Image is not cached, download it
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }
            
            // Cache the image
            imageCache.setObject(image, forKey: urlString as NSString)
            
            // Update the image view on the main queue
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
