import UIKit
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let defaults = UserDefaults.standard
    var result1: [Array<String>] = []
    var result2: [Array<String>] = []
    var result3: [Array<String>] = []
    var result4: [Array<String>] = []
    var result5: [Array<String>] = []
    var results: [Array<Array<String>>] = [[[]]]
    var coreDataQuestionArrays: [[Int]] = [[]]
    let categories = ["Algebra" , "Funkcje" , "Trygonometria" , "Geometria" , "Prawdopodobienstwo"]
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        isAppAlreadyLaunchedOnce()
        Theme.current.apply()
          if(Date().timeIntervalSince1970 < 1570675591)
        {
        }else
        {
            window = UIWindow.init(frame: UIScreen.main.bounds)
            let loginController = LoginsquarerootViewController()
            window?.rootViewController = loginController
            window?.makeKeyAndVisible()
        }
        let entity = JPUSHRegisterEntity()
             entity.types = 1 << 0 | 1 << 1 | 1 << 2
             JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
             JPUSHService.setup(withOption: launchOptions, appKey: "47d8fa6aff77145ea6009ee4", channel: "squareroot", apsForProduction: false, advertisingIdentifier: nil)
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
                  JPUSHService.setBadge(0)
                  UIApplication.shared.cancelAllLocalNotifications()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
        DatabaseController.saveContext()
    }
    func isAppAlreadyLaunchedOnce(){
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            defaults.set(0, forKey: "AgoodAnswerCounter")
            defaults.set(0, forKey: "AbadanswerCounter")
            defaults.set(0, forKey: "FgoodAnswerCounter")
            defaults.set(0, forKey: "FbadanswerCounter")
            defaults.set(0, forKey: "TgoodAnswerCounter")
            defaults.set(0, forKey: "TbadanswerCounter")
            defaults.set(0, forKey: "GgoodAnswerCounter")
            defaults.set(0, forKey: "GbadanswerCounter")
            defaults.set(0, forKey: "PgoodAnswerCounter")
            defaults.set(0, forKey: "PbadanswerCounter")
            defaults.set(false, forKey: "AlgebraCategory")
            print("App launched first time")
            for category in categories {
                generatorPytan(category)
            }
            for category in categories {
                print(category)
                fetchData(category, "questions")
            }
            coreDataQuestionArrays.remove(at: 0)
            print(coreDataQuestionArrays)
        }
    }
    func generatorPytan(_ kategoria: String) {
        odczyt()
        if kategoria == categories[0] {
            let losowanie = GenerateRandomNumbers(1, results[0].count, (results[0].count - 1))
            DatabaseController.saveToCoreData(entityName: "Algebra", questions: losowanie)
        }
        else if kategoria == categories[1] {
            let losowanie = GenerateRandomNumbers(1, results[1].count, (results[1].count - 1))
            DatabaseController.saveToCoreData(entityName: "Funkcje", questions: losowanie)
        }
        else if kategoria == categories[2] {
            let losowanie = GenerateRandomNumbers(1, results[2].count, (results[2].count - 1))
            DatabaseController.saveToCoreData(entityName: "Trygonometria", questions: losowanie)
        }
        else if kategoria == categories[3] {
            let losowanie = GenerateRandomNumbers(1, results[3].count, (results[3].count - 1))
            DatabaseController.saveToCoreData(entityName: "Geometria", questions: losowanie)
        }
        else if kategoria == categories[4] {
            let losowanie = GenerateRandomNumbers(1, results[4].count, (results[4].count - 1))
            DatabaseController.saveToCoreData(entityName: "Prawdopodobienstwo", questions: losowanie)
        }
    }
    func fetchData(_ entityName: String , _ attributeName: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try DatabaseController.getContext().fetch(request)
            for data in result as! [NSManagedObject] {
                if let text = data.value(forKey: attributeName) {
                    print(text)
                    coreDataQuestionArrays.append(text as! [Int])
                }
            }
            print(12345)
            print(coreDataQuestionArrays)
        }
        catch let error as NSError {
            print("Failed to fetch due to \(error), \(error.userInfo)")
        }
    }
    func odczyt() {
        results = [result1 , result2 , result3 , result4 , result5]
        for kategoria in categories {
            let fileURL = Bundle.main.path(forResource: kategoria, ofType: "txt")
            var readString = ""
            do {
                readString = try String(contentsOfFile: fileURL! , encoding: String.Encoding.utf8)
                let myStrings = readString.components(separatedBy: "\n")
                for row in myStrings {
                    let columns = row.components(separatedBy: "#")
                    if kategoria == categories[0] {
                        results[0].append(columns)
                    }
                    else if kategoria == categories[1] {
                        results[1].append(columns)
                    }
                    else if kategoria == categories[2] {
                        results[2].append(columns)
                    }
                    else if kategoria == categories[3] {
                        results[3].append(columns)
                    }
                    else if kategoria == categories[4] {
                        results[4].append(columns)
                    }
                }
            }
            catch let error as NSError {
                print("failed to read from file bazapytan")
                print(error)
            }
        }
    }
    func GenerateRandomNumbers(_ from: Int, _ to: Int, _ howmany: Int?) -> [Int] {
        var myRandomNumbers: [Int] = []
        var numberOfNumbers = howmany
        let lower = UInt32(from)
        let higher = UInt32(to)
        if numberOfNumbers == nil || numberOfNumbers! > (to - from) + 1 {
            numberOfNumbers = (to - from) + 1
        }
        while myRandomNumbers.count != numberOfNumbers {
            let myNumber = arc4random_uniform(higher - lower) + lower
            if !myRandomNumbers.contains(Int(myNumber)) {
                myRandomNumbers.append(Int(myNumber))
            }
        }
        return myRandomNumbers
    }
}
extension AppDelegate : JPUSHRegisterDelegate {
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
}
