# 240729 Push Notification Console

푸시 알림을 손쉽게 테스트 하는 방법.


7월 29일 (월)


# 학습내용

## Push Notification 설정

> Notification Console은 웹 인터페이스이며, 장치 토큰과 채널에 대한 테스트를 모두 전송할 수 있다.


1. 프로젝트를 생성한다.
2. 생성 후 Capabilities > Push Notification 추가
![image](https://github.com/user-attachments/assets/bc16e604-f3a2-4e5e-baa7-93646a58cc88)

3. AppDelegate.swift 수정
```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.reduce("") {
        $0 + String(format: "%02X", $1)
    }
    print("Device Token:" + token)
}

func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(error.localizedDescription)
}
```

4. 사용자에게 알림 권한 요청하기
```swift
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
    didAllow,Error in

    DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
    }
})
```

5. 빌드 후 콘솔에 print 찍히는 디바이스 토큰을 얻어온다.
6. [Push Notification Console](https://icloud.developer.apple.com/dashboard/notifications)로 이동 후 프로젝트 번들 아이디를 찾는다.
![image](https://github.com/user-attachments/assets/7c003f2e-c44a-4f19-985f-3bfecc3afcda)

7. Create New Notification을 눌러서 테스트 값을 채워넣어준다.
![image](https://github.com/user-attachments/assets/f40bd37f-02b3-45fa-9695-841011744785)


#

* General
  * Name: Test Notification을 구분하는 이름
  * Environment: 개발 환경에서 전송됨을 의미.
  * Device Token: Xcode에서 앱 시작 시 얻을 수 있는 디바이스 토큰
* Request Headers
  * apns-topic: 알림을 수신하는 topic
  * apns-push-type: 푸시 타입
  * apns-expiration: 알림 전송 만료일
  * apns-priority: 즉시 전달(10), 디바이스 파워 상태에 따라 보냄(5), 디바이스 파워 상태 우선시하고 디바이스 깨어남 방지(1)
* Payload
  * event: 이벤트 타입
  * content-state: 라이브 액티비티 업데이트에 필요한 상태값
  * timestamp: 이벤트가 발생한 시간

#

필드값을 다 채워주었으면, send를 눌러주면 바로 푸시가 전송된다.

푸시가 전송되었는지 여부는 아래와 같이 로그를 확인하면 된다.
![](https://github.com/user-attachments/assets/ff2845ff-ad81-4c76-be9d-c8c91868fc62)

---


# 참고 링크


- [https://developer.apple.com/documentation/usernotifications/testing-notifications-using-the-push-notification-console](https://developer.apple.com/documentation/usernotifications/testing-notifications-using-the-push-notification-console)