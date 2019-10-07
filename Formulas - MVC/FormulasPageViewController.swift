import UIKit
class FormulasPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let quizView = QuizView()
    let imageNames = ["mat1" , "mat2" , "mat3" , "mat4" , "mat5" , "mat6" , "mat7" , "mat8" , "mat9" , "mat10" , "mat11" , "mat12" , "mat13" , "mat14" , "mat15" , "mat16" , "mat17" , "mat18" , "mat19" , "mat20" , "mat21" , "mat22" , "mat23"]
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! PageViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)
        if currentIndex! > 0 {
            let frameViewController = PageViewController()
            frameViewController.imageName = imageNames[currentIndex! - 1]
            return frameViewController
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! PageViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)
        if currentIndex! < imageNames.count - 1 {
            let frameViewController = PageViewController()
            frameViewController.imageName = imageNames[currentIndex! + 1]
            return frameViewController
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        configureController()
        let frameViewController = PageViewController()
        frameViewController.imageName = imageNames.first
        let viewControllers = [frameViewController]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    func configureController() {
        view.backgroundColor = Theme.current.mainColor
        self.navigationItem.titleView = quizView.createLogoImage()
    }
}
