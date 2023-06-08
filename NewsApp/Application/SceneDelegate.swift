import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let vc = NewsViewController()
        vc.title = "News App"
        
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
