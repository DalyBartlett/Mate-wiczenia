import UIKit
import CoreGraphics
class MainScreenView: UIView {
    let beginText: UILabel = {
        let lbl = UILabel()
        lbl.text = "Jeszcze nie rozwiązałeś żadnego zadania. Przejdź do Quizu"
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        UIDevice.current.userInterfaceIdiom == .phone ?( lbl.font = UIFont.boldSystemFont(ofSize: 15) ): (lbl.font = UIFont.boldSystemFont(ofSize: 25))
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.contentMode = .scaleToFill
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()
    let Startbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Ucz się! ", for: .normal)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 22.0)
        UIDevice.current.userInterfaceIdiom == .phone ?(button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 22.0)): (button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 30.0))
        button.backgroundColor = Theme.current.ButtonsBackColor
        button.setTitleColor(#colorLiteral(red: 0.8210221529, green: 0.8669400215, blue: 0.8650611639, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let label4 = UILabel()
    var line1 = CAShapeLayer()
    var line2 = CAShapeLayer()
    var line3 = CAShapeLayer()
    var circle = CAShapeLayer()
    var smallcircle = CAShapeLayer()
    let circlecolor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1).cgColor
    let black = UIColor(white: 0, alpha: 1).cgColor
    let gray = UIColor(white: 0.8, alpha: 1).cgColor
    func createEssentials(view: UIView) {
        self.backgroundColor = Theme.current.mainColor
        createStartButton(view: view)
    }
    func createStartButton(view: UIView) {
        view.addSubview(Startbutton)
        Startbutton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        Startbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        Startbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        Startbutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    func createLogoImage() -> UIImageView {
        let imageViewLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
        imageViewLogo.contentMode = .scaleAspectFit
        let imageLogo = UIImage(named: "path2936.png")
        imageViewLogo.image = imageLogo
        return imageViewLogo
    }
    func createBeginText(view: UIView) {
        beginText.frame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
        view.addSubview(beginText)
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
    func setupLayout(goodAnswears: Double, view: UIView) {
        let dispx = view.center.x * 2
        let dispy = view.center.y * 2
        let center = CGPoint.init(x: dispx / 2, y: dispy * 6 / 16)
        let radius1 = dispx * 3 / 16        
        let radius2 = dispx * 33 / 192       
        let fi = 360 * goodAnswears / 2 * Double.pi / 180
        let goodx = (dispx / 2) - (radius1 * CGFloat(sin(fi)))
        let goody = (dispy * 6 / 16) + (radius1 * CGFloat(cos(fi)))
        let badx = (dispx / 2) + (radius1 * CGFloat(sin(fi)))
        let bady = (dispy * 6 / 16) - (radius1 * CGFloat(cos(fi)))
        smallcircle = createCircle(center: center, radius: radius2, color: gray , view: view)
        circle = createCircle(center: center, radius: radius1, color: circlecolor , view: view)
        if Int(round(goodAnswears * 100)) == 0 {
            line3 = createLine(x: dispx / 2 - 1 , y: dispy * 6/16 + 1, width1: 0, width: 1, height: radius2 * 2, strokeEnd: 0, color: gray , view: view)
        }
        else {
            line3 = createLine(x: dispx / 2 - 1, y: dispy * 6/16 + 1, width1: 0, width: 1, height: radius1 * 2, strokeEnd: 0, color: circlecolor , view: view)
        }
        animation(on: line3, from: 0, to: 1, duration: 2, beginat: 0, cp1: 0.75, cp2: 0.1, cp3: 0.28, cp4: 1, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.removed.rawValue, revers: false, count: 1)
        if Int(round(goodAnswears * 100)) != 100 && Int(round(goodAnswears * 100)) != 0 {
            line1 = createLine(x: badx, y: bady, width1: 0, width: 1, height: dispy * 5/8 - bady, strokeEnd: 0, color: black , view: view)
            setLabel(lbl: label2, text: "Źle", aligment: .left, fontSize: 15, alpha: 0, x: badx + 3, y: dispy * 5 / 8 - 15, width: 100, height: 15 , view: view)
            setLabel(lbl: label4, text: "\(100 - Int(round((goodAnswears) * 100)))%", aligment: .left, fontSize: 20, alpha: 0, x: badx + 3, y: dispy * 5 / 8 - 40, width: 100, height: 20 , view: view)
            animation(on: line1, from: 0, to: 1, duration: 1, beginat: 3, cp1: 0.75, cp2: 0.1, cp3: 0.28, cp4: 1, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 1)
            animation(on: circle, from: 0, to: goodAnswears, duration: 2 * goodAnswears, beginat: 1, cp1: 1, cp2: 0, cp3: 0.9, cp4: 1, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 0)
            animation(on: smallcircle, from: goodAnswears, to: 1, duration: 2*(1-goodAnswears), beginat: 1 + 2*goodAnswears, cp1: 0.1, cp2: 0, cp3: 0, cp4: 1, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 1)
            line2 = createLine(x: goodx, y: goody,width1: 0, width: 1, height: dispy * 6/8 - goody, strokeEnd: 0, color: black , view: view)
            setLabel(lbl: label1,text: "Dobrze", aligment: .left, fontSize: 15, alpha: 0, x: goodx + 3, y: dispy * 6 / 8 - 15, width: 100, height: 15 , view: view)
            setLabel(lbl: label3, text: "\(Int(round(goodAnswears * 100)))%", aligment: .left, fontSize: 20, alpha: 0, x: goodx + 3, y: dispy * 6 / 8 - 40, width: 100, height: 20 , view: view)
            animation(on: line2, from: 0, to: 1, duration: 1, beginat: 1 + 2*goodAnswears, cp1: 0.75, cp2: 0.1, cp3: 0.28, cp4: 1, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 1)
        }
        else {
            line2 = createLine(x: goodx - 20, y: goody,width1: 0, width: 1, height: dispy * 6/8 - goody, strokeEnd: 0, color: black , view: view)
            setLabel(lbl: label1,text: "Dobrze", aligment: .left, fontSize: 15, alpha: 0, x: goodx + 3 - 20, y: dispy * 6 / 8 - 15, width: 100, height: 15 , view: view)
            setLabel(lbl: label3, text: "\(Int(round(goodAnswears * 100)))%", aligment: .left, fontSize: 20, alpha: 0, x: goodx + 3 - 20, y: dispy * 6 / 8 - 40, width: 100, height: 20 , view: view)
            animation(on: circle, from: 0, to: goodAnswears, duration: 2 * goodAnswears, beginat: 1, cp1: 5/6, cp2: 0.2, cp3: 2/6, cp4: 0.9, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 0)
            animation(on: smallcircle, from: goodAnswears, to: 1, duration: 2*(1-goodAnswears), beginat: 1 + 2*goodAnswears, cp1: 5/6, cp2: 0.2, cp3: 2/6, cp4: 0.9, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 1)
            animation(on: line2, from: 0, to: 1, duration: 1, beginat: 2, cp1: 0.75, cp2: 0.1, cp3: 0.28, cp4: 1, path: "strokeEnd", key: " ", mode: CAMediaTimingFillMode.forwards.rawValue, revers: false, count: 1)
        }
    }
    func createCircle(center: CGPoint, radius: CGFloat, color: CGColor , view: UIView) -> CAShapeLayer{
        let circle = CAShapeLayer()
        let base = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat.pi / 2, endAngle: (CGFloat.pi / 2) + (CGFloat.pi * 2), clockwise: true)
        circle.path = base.cgPath
        circle.fillColor = UIColor(white: 1, alpha: 0).cgColor
        circle.strokeColor = color
        circle.lineWidth = radius * 2
        circle.strokeEnd = 0
        view.layer.addSublayer(circle)
        return circle
    }
    func createLine(x: CGFloat, y: CGFloat, width1: CGFloat ,width: CGFloat,height: CGFloat, strokeEnd: CGFloat, color: CGColor , view: UIView) -> CAShapeLayer{
        let path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: width1, height: height),cornerRadius: width / 2)
        let line  = CAShapeLayer()
        line.strokeColor = color
        line.lineWidth = width
        line.strokeEnd = strokeEnd
        line.path = path.cgPath
        view.layer.addSublayer(line)
        return line
    }
    func setLabel(lbl: UILabel, text: String, aligment: NSTextAlignment ,fontSize: CGFloat, alpha: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat , view: UIView){
        lbl.text = text
        lbl.textAlignment = aligment
        lbl.font = UIFont.boldSystemFont(ofSize: fontSize)
        lbl.alpha = alpha
        lbl.frame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(lbl)
    }
    func animation(on: CAShapeLayer, from: Double, to: Double, duration: Double, beginat: Double, cp1: Float, cp2: Float, cp3: Float, cp4: Float, path: String, key: String, mode: String, revers: Bool, count: Float){
        let animation = CABasicAnimation(keyPath: path)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + beginat
        animation.fillMode = CAMediaTimingFillMode(rawValue: mode)
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(controlPoints: cp1, cp2, cp3, cp4)
        animation.autoreverses = revers
        animation.repeatCount = count
        on.add(animation, forKey: key)
    }
}
