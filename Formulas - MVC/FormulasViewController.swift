import UIKit
class FormulasViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate , UIScrollViewDelegate {
    let quizView = QuizView()
    var frameViewController = PageViewController()
    let imageNames = ["mat1" , "mat2" , "mat3" , "mat4" , "mat5" , "mat6" , "mat7" , "mat8" , "mat9" , "mat10" , "mat11" , "mat12" , "mat13" , "mat14" , "mat15" , "mat16" , "mat17" , "mat18" , "mat19" , "mat20" , "mat21" , "mat22" , "mat23"]
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! PageViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)
        if currentIndex! > 0 {
            frameViewController = PageViewController()
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
        if revealViewController()  != nil {
            self.navigationItem.leftBarButtonItem = quizView.createMenuButton(vc: self)
            self.view.addGestureRecognizer((revealViewController()?.panGestureRecognizer())!)
        }
    }
}
class PageViewController: UIViewController , UIScrollViewDelegate {
    var imageName: String? { didSet {
        imageView.image = UIImage(named: imageName!)
        }}
    var imageView: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 5.0
        return scroll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tap)
        view.addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
    }
    @objc func doubleTapped() {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
