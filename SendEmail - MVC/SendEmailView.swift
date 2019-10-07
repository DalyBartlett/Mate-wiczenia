import UIKit
class SendEmailView: UIView {
    func createLogoImage() -> UIImageView {
        let imageViewLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
        imageViewLogo.contentMode = .scaleAspectFit
        let imageLogo = UIImage(named: "path2936.png")
        imageViewLogo.image = imageLogo
        return imageViewLogo
    }
    func createMenuButton(vc: UIViewController) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu-2"), for: UIControl.State.normal)
        button.widthAnchor.constraint(equalToConstant: 23).isActive = true
        button.heightAnchor.constraint(equalToConstant: 23).isActive = true
        button.addTarget(vc.revealViewController(), action: #selector(SWRevealViewController().revealToggle(_:)), for: .touchUpInside)
        let menuBtn = UIBarButtonItem(customView: button)
        return menuBtn
    }
}
