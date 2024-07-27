# 220228 UserNotifications, AppDelegate

# TIL (Today I Learned)

2월 28일 (월)

## 학습 내용

- User Notification
    - 실습도 해보기~

&nbsp;

## 고민한 점 / 해결 방법

**[User Notifications]**


### UserNotifications란?
* 알림을 앱에서 띄우기 위한 프레임워크
* Notification은 서버에서 보낼 수도 있고, 앱 내에서도 보낼 수 있다.
* 앱이 구동중이든 아니든 중요한 정보를 사용자에게 전달할 때 활용할 수 있다.
    * 예를 들어 스포츠 앱은 사용자에게 가장 좋아하는 팀의 점수를 푸시로 알려줄 수도 있다.
* Notification은 alert을 띄우고 소리를 낼 수도 있고, 앱 아이콘을 뱃지로 보여줄 수 있다.

![](https://i.imgur.com/Hytaha6.png)

* 앱 내에서 서버에서 알림을 발생 시킬 수 있다.
* 앱 내부에서 알림을 띄운다면 앱은 Notification content를 생성하고 알림을 발생시킬 시간이나 지역과 같은 조건을 명시한다.
* 앱 외부에서 보내는 Notification(push)은 알림을 보내기 위해 회사 서버를 사용하고, Apple Push Notification service(APNs)가 사용자 기기로의 알림 전달을 다룬다.

이 프레임 워크는 아래의 것들을 할 때 사용한다.
* 앱이 지원하는 Notification의 타입을 정의한다.
* Notification 타입과 관련있는 커스텀 action을 정의한다.
* 앱 내부에서 알림을 띄우는 경우에 알림을 띄울 시간을 정의한다.
* 이미 전달된 알림을 처리한다.
* 사용자가 선택하는 action에 반응한다.

### User Notification의 종류
* Local Notification
    * 외부 서버를 통하지 않고 내부 앱에서 푸시 알림을 보내는 경우
        * 미리알림, 알람앱의 푸시 알림 등...
* Remote Notification
    * 외부 서버에서 APNs에 푸시 Notification을 보내주어 디바이스에 나타내는 경우(JSON 형태의 딕셔너리로 만들어 보내준다.)
    * 로컬보다는 지연이 있고 손실될 우려가 있다.
        * 게임에서의 이벤트 알림, 쿠폰 등등 여러 앱의 실사용에서 볼 수 있는 서버의 푸시 알림

---

**[직접 사용해보기]**

### 유저에게 알림 허락을 받아야한다. (권한을 얻어야한다.)

![](https://i.imgur.com/vjttUhW.png)

```swift
import UserNotifications

let center = UNUserNotificationCenter.current()
center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
    
    if let error = error {
        // 에러처리를 여기서...
    }

    // 유저가 승인하면 여기서 어떠한 로직을 처리할 수가 있다.    
    // 권한 부여에 따른 기능 활성화 등을 설정한다.

}

```

* 알림을 보내겠다는 권한을 명시적으로 요청할 때 사용자는 앱이 보내는 알림을 보기도 전에 권한을 허용하거나 거절해야하는데, 권한을 요청하기 전에 context를 잘 설정했다고 해도 사용자는 이를 바로 결정하기 힘들 수도 있다.
* options에 .provisional 이라는 옵션을 추가하면 임시 승인을 사용하여 알림을 보내겠다는 권한을 시도적으로 알림 권한을 요청할 때 활용할 수 있다.
* 시스템은 이런 옵션의 알림을 조용히 보낸다. 소리나 배너를 띄우지 않고 잠금 화면에 띄우지 않는다.
* 대신 알림 센터 기록에 남겨둔다. 이런 알림은 사용자가 계속 알림을 받을건지 아니면 알림을 끌건지 선택하게 하는 버튼을 포함시킬 수 있다. 

![](https://i.imgur.com/n1p0C7x.png)

* Keep 버튼 터치시 시스템은 알림을 눈에 띄게 할지, 아니면 조용히 하게 할지 선택하게 한다.
    * 만약 사용자가 눈에 띄게 하는 알림 설정을 하게된다면 앱은 provisional authorization에 포함된 모든 권한을 얻게된다.
    * 사용자가 조용한 알림을 선택했다면 시스템은 앱이 알림을 보낼 수 있게 허용은 하지만 alert, sound, 앱아이콘 배지를 띄우지 않게 한다.
    * 이 경우 알림은 오직 알림 센터 기록에만 뜨게한다.
* .provisional 이 옵션이 포함된다면 명시적으로 권한을 요청하는 것과는 다르게 사용자에게 알림을 받을 권한을 요청하지 않는다. 대신 이 메서드를 처음 호출할 때 자동으로 권한을 획득한다.
* 하지만 사용자가 명시적으로 keep하거나 turn off 하기 전까지 권한 상태는 UNAuthorizationStatus.provisional이다. 
* 사용자가 권한 상태를 언제든지 바꿀 수 있기 때문에 local notification을 보내기 전에 상태를 계속 확인해야 한다.


### Push 알림 메세지를 설정해주자

```swift
let content = UNMutableNotificationContent()
content.title = "Weekly Staff Meeting"
content.body = "Every Tuesday at 2pm"
```
* 모든 push 알림에는  메세지가 존재한다.
* 어떤 메세지를 가지고 유저에게 push 알림을 줄건지  

UNMutableNotificationContent를 사용하여 설정해줄 수 있다.

### 알림 트리거 설정

![](https://i.imgur.com/Iah5Rit.png)

* UserNotifications를 어떻게 작동할건지 트리거를 만들어야 한다.
* 특정 시간, 시간 간격, 위치 변경을 기반으로 트리거를 설정할 수 있다.
```swift
func scheduleNotification() {
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default

    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
}
```
* 위 코드에서는 일정한 시간이 지나면 알림을 나타나게 설정되어있다.
* 만약 특정 시간을 원한다면 아래와 같이 UNCalendarNotificationTrigger를 활용해볼 수도 있다.
```swift
var dateComponents = DateComponents()
dateComponents.hour = 10
dateComponents.minute = 30
let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
```
* 해당 설정은 repeats 설정이 true로 되어있기 때문에 매일 오전 10시 30분에 알림이 표시된다.

### 알림 요청을 한다.
* 위에서 만들어주었던 트리거를 가지고 알림을 요청(예약)해주는 작업을 해준다.
```swift
let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
```
* identifier는 알림 요청이 여러가지일 때 알림들을 구분할 수 있게 해주는 고유 식별자이다.

### 요청했던 알림을 알림센터에 추가해준다.
* UNUserNotificationCenter는 모든 알림 관련 동작을 관리하는 객체이다.
* 
* 유저가 알림을 받겠다고 허용한 경우 UNNotificationRequest는 UNNotification을 만드는데 사용되며 사용자에게 알려지게 된다.
```swift
UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
```
* 위와 같이 add라는 메소드를 사용해서 위에서 만들었던 request를 파라미터로 넣어주었다.

---

**[UserNotifications 활동학습]**

## [application(_:didFinishLaunchingWithOptions:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application)
* 실행 프로세스가 거의 끝나고 앱이 실행될 준비가 거의 완료되었음을 알리는 메소드이다.
* 앱이 완전 종료된 상태에서 push를 클릭하여 앱을 실행한 경,우 원하는 페이지로 원활하게 이동시키려면 해당 메소드에서 알림 동의 여부를 사용자에게 요청하는 것이 적절하다.

> 먼저 AppDelegate.swift에 UserNotifications를 import 해준다.

```swift
import UserNotifications
```

> 그리고 프로퍼티로 center를 선언해주고, application(_:didFinishLaunchingWithOptions:) 메소드에 아래와 같은 코드를 추가하여 앱을 처음 실행할 때 알림 환경을 설정하고 사용자 동의를 받도록 구현한다.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    let center = UNUserNotificationCenter.current()

// MARK: - UserNotification Authorization
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        center.delegate = self
        // 사용자에게 알림을 받겠냐는 승인 요청하기.
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // 에러처리를 여기서...
                print(error)
            }
            
            if granted {
                // 유저가 승인하면 여기서 어떠한 로직을 처리할 수가 있다.
                // 권한 부여에 따른 기능 활성화 등을 설정한다.
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // 유저가 승인을 거절했을 경우
                print("사용자가 push를 거절하였음.")
            }
        }
        
        return true
    }
...
```

> ViewController로 돌아와서 알림 콘텐츠와 트리거를 생성해서 알람을 만들어준다

```swift
class ViewController: UIViewController {
// 콘텐츠 생성
    var yellowContent: UNMutableNotificationContent = {
        let content = UNMutableNotificationContent()
        content.title = "로컬 알림 메세지"
        content.body = "준비된 내용을 보려면 탭하세요..."
        content.userInfo = ["target_view" : "yellow_view"]
        return content
    }()

// 트리거 생성
    let yellowTimeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
...
```

> 그리고 위에서 만든 콘텐츠와 트리거로 UINotificationRequest를 선언하고, 알림센터에 등록해주는 작업까지 해준다.

```swift
    func setUpUserNotification() {
        let yellowRequest = UNNotificationRequest(identifier: "yellowView", content: yellowContent, trigger: yellowTimeIntervalTrigger)
        UNUserNotificationCenter.current().add(yellowRequest, withCompletionHandler: nil)
    }
```

> 그리고 viewDidLoad 메소드에 위에서 만든 메소드를 호출해주면, 사용자가 알림을 허용하고나서 설정한대로 2초후 Push 알림이 뜨게 된다.

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserNotification()
    }
```

> `UNUserNotificationCenterDelegate`를 활용하여 [userNotificationCenter(_: didReceive: withCompletionHandler:)](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate/1649501-usernotificationcenter) 메소드를 정의하여 push를 터치하였을 때 처리해줄 작업을 처리해줄 수 있다. 

```swift
// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // tabBarController 를 캐스팅하여 선언
        let tabBarController = UIApplication.shared.connectedScenes.first?.delegate
            .flatMap { $0 as? SceneDelegate }
            .flatMap { $0.window?.rootViewController }
            .flatMap { $0 as? UITabBarController }

        // 여기도 마찬가지로 flatMap을 활용하여 바인딩하여 분기처리를 해주었다.
        response.notification.request.content.userInfo["target_view"]
            .flatMap { $0 as? String }
            .flatMap {
                switch $0 {
                case "yellow_view":
                    // 딕셔너리 값이 yellow_view일 경우 탭의 1번째를 select하고, performSegue를 해주었다. 이 때 sender에 content의 타이틀과 바디를 넘겨주었다.
                    tabBarController?.selectedIndex = 1
                    guard let navi = tabBarController?.selectedViewController as? UINavigationController else {
                        return
                    }
                    let title = response.notification.request.content.title
                    let body = response.notification.request.content.body
                    navi.topViewController?.performSegue(
                        withIdentifier: $0,
                        sender: (title, body)
                    )
                case "brown_view":
                    tabBarController?.selectedIndex = 2
                    let title = response.notification.request.content.title
                    let body = response.notification.request.content.body
                    tabBarController?.selectedViewController?.performSegue(
                        withIdentifier: $0,
                        sender: (title, body)
                    )
                default:
                    return
                }
            }
        
        
        // 앱이 메모리에 올라와있는지에 따라 아래처럼 분기처리를 해줄 수 있다.
        /*
        switch UIApplication.shared.applicationState {
        case .background:
            
        case .inactive:
            
        case .active:
            
        }
        */
    }
    
    //앱이 foreground에 있을 때. 즉 앱안에 있어도 push알림을 받게 해주는 메소드.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
}
```

> 그리고 performSegue를 하기전에 `prepare`를 활용하여 전달받은 sender를 뷰컨으로 전달해주었다

```swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController = segue.destination as? YellowViewController,
              let sender = sender as? (String, String) else {
            return
        }
        nextViewController.setUp(data: sender)
    }
```

> YellowViewController의 코드는 아래와 같다.

```swift
class YellowViewController: UIViewController {
    
    var userinfo: (String, String)?

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = userinfo?.0 // text 설정
        bodyLabel.text = userinfo?.1
    }

    func setUp(data: (String, String)) {
        self.userinfo = data // 데이터를 할당하고
    }
}
```

>요약 정리
* AppDelegate.swift에 알림을 받겠냐는 승인 요청을 구현한다.
* `push`를 터치했을 때 어떤 처리를 해줄 건지 `UNUserNotificationCenterDelegate`를 채택하여 메소드를 정의해준다.
* 알림 콘텐츠, 트리거를 선언하여 알림을 생성한다.
* 위에서 생성한 UserNotification을 센터에 추가한다.
    * 나의 경우 viewDidLoad에 했지만, 상황에 따라 앱이 백그라운드로 가는 시점 (applicationWillResignActive(_ application: UIApplication))에 등록해줄 수도 있고, 날짜나 시간에 따라 트리거를 설정하여 시점을 변경해줄 수 있다.


---

- 참고링크
    - https://yoojin99.github.io/app/User-Notifications/
    - https://zeddios.tistory.com/157
    - https://www.hackingwithswift.com/example-code/system/how-to-set-local-alerts-using-unnotificationcenter
    - https://green1229.tistory.com/69
    - https://github.com/outofcode-example/iOS-PushSetting/blob/master/AppDelegate.swift
    - https://developerbee.tistory.com/202
    - https://g-y-e-o-m.tistory.com/74
    - https://github.com/outofcode-example/iOS-PushSetting/blob/master/AppDelegate.swift

