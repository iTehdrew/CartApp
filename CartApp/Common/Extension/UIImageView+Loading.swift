import UIKit

extension UIImageView {
    
    
    func setImage(from url: URL,
                  contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    
                    let response = response as? HTTPURLResponse
                    print("""
                        Image loading from \(url) has been failed.
                        Status code: \(response?.statusCode ?? 0)
                        """)
                    DispatchQueue.main.async() {
                        self.image = UIImage(named: "placeholder")
                    }
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func setImage(from url: String,
                  contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        guard let url = URL(string: url) else {
            return
        }
        setImage(from: url, contentMode: mode)
    }
}
