import UIKit

class LoadingIndicator: UIActivityIndicatorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder) 
        setUpUI()
    }
    
    private func setUpUI() {
        self.color = .blue
        self.hidesWhenStopped = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.style = .large
    }
}
