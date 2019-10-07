import UIKit
enum Theme: Int {
    case `default`, dark, graphical
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    var mainColor: UIColor {
        switch self {
        case .default, .graphical:
            return UIColor(red: 209.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        }
    }
    var navBarColor: UIColor {
        switch self {
        case .default , .graphical:
            return UIColor(red: 39.0/255.0, green: 58.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 165.0/255.0, green: 183.0/255.0, blue: 193.0/255.0, alpha: 1.0)
        }
    }
    var ButtonsBackColor: UIColor {
        switch self {
        case .default , .graphical:
            return #colorLiteral(red: 0.1539692879, green: 0.2287807465, blue: 0.2559971213, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.6391119361, green: 0.7080974579, blue: 0.7493337989, alpha: 1)
        }
    }
    var categoryBackColor: UIColor {
        switch self {
        case .default, .graphical:
            return #colorLiteral(red: 0.5333321691, green: 0.719915092, blue: 0.800342381, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.6763739948, green: 0.6742035152, blue: 0.7121163878, alpha: 1)
        }
    }
    var tintColor: UIColor {
        switch self {
        case .default , .graphical:
            return #colorLiteral(red: 0.8544037938, green: 0.8911353946, blue: 0.8889012933, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.8568090796, green: 0.8580922484, blue: 0.8965544105, alpha: 1)
        }
    }
    var navigationBackgroundImage: UIImage? {
        return self == .graphical ? UIImage(named: "navBackground") : nil
    }
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        BasicTableViewCell.appearance().backgroundColor = mainColor
        UITableViewCell.appearance().backgroundColor = categoryBackColor
        UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).textColor = mainColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = UIColor.black
        UIButton.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().barTintColor = navBarColor
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
    }
}
