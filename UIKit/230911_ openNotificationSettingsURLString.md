# 230911 openNotificationSettingsURLString
# TIL (Today I Learned)


9월 9일 (토)

## 학습 내용
- 앱에서 설정으로 바로가는 동작은 있는데, 설정 > 알림으로 바로갈 수 있는 방법도 있을까?

&nbsp;

## 고민한 점 / 해결 방법

앱에서 설정 앱 > 앱의 알림 설정 화면으로 바로 이동하는 기능이 존재하기는 하는데…
iOS 16.0 부터만 가능한 것 같다.

```swift

guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
Task {
    UIApplication.shared.open(settingsURL)
}
```



---

- 참고링크
    - https://stackoverflow.com/questions/63334516/ios-opening-app-push-notification-settings-screen-from-app
    - https://developer.apple.com/documentation/uikit/uiapplication/4013180-opennotificationsettingsurlstrin
