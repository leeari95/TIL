# 250702 main, UIApplication, UIKit, SceneDelegate

`@main` vs `@UIApplicationMain`

7월 2일 (수)

## 배경

SwiftUI에서는 `@main`을 사용해 앱의 진입점을 정의하는 것이 일반적이며, UIKit에서도 기존의 `@UIApplicationMain` 대신 `@main` 사용이 점점 권장되는 추세다.

Swift Evolution 제안서(SE-0383)에 따라 `@UIApplicationMain`은 deprecated 대상으로 간주되며, 향후 제거될 가능성이 있다.

## 핵심 포인트

### 1. @main vs @UIApplicationMain
- `@UIApplicationMain`: UIKit 전용, main.swift 없이 앱을 시작할 수 있도록 UIApplicationMain(...) 호출 코드를 자동 생성. 단, SwiftUI나 커스텀 진입점에는 사용할 수 없음.
- `@main`: Swift 표준 속성, 어떤 타입(struct/class/enum)이든 앱의 진입점으로 지정 가능

> @main은 Swift 5.3 이상에서 사용 가능하며, Xcode 12 이상이 필요하다.

### 2. UIKit + @main 사용 시 주의사항
UIKit에서 `@main`을 사용할 때는 **별도의 main 함수 구현이 불필요**하다.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // Swift 컴파일러가 UIApplicationMain(...)을 자동으로 생성 및 호출함
}
```

### 3. main 함수가 필요한 경우

main 함수를 직접 구현해야 하는 경우는 다음과 같다:

- 커스텀 UIApplication 서브클래스 사용
- 앱 시작 전 특별한 초기화 로직 필요
- 런타임에 AppDelegate 클래스를 동적으로 결정

```swift
import UIKit

class CustomApplication: UIApplication {
    // 커스텀 로직
}

// @main을 사용하지 않고, 별도의 main.swift 파일에서 진입점 직접 정의
UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(CustomApplication.self),
    NSStringFromClass(AppDelegate.self)
)
```

### 4. Scene-based Lifecycle과의 호환성
`@main`은 SceneDelegate 기반의 앱 구조에서도 정상 작동하며, 다음 두 조건이 충족되면 SceneDelegate가 자동 호출된다:

1. `AppDelegate`가 Scene 생성을 위한 `configurationForConnecting` 메서드를 구현하고 있고
2. Info.plist에 `UIApplicationSceneManifest` 설정이 포함되어 있을 것

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
```

```xml
<key>UIApplicationSceneManifest</key>
<dict>
    <key>UIApplicationSupportsMultipleScenes</key>
    <true/>
    <key>UISceneConfigurations</key>
    <dict>
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>UISceneConfigurationName</key>
                <string>Default Configuration</string>
                <key>UISceneDelegateClassName</key>
                <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
            </dict>
        </array>
    </dict>
</dict>
```

## 결론
UIKit에서 `@main` 사용 시 대부분의 경우 main 함수를 별도로 구현할 필요가 없으며, 이는 코드를 더 간결하고 현대적으로 만들어준다. 단, 특별한 커스터마이징이 필요한 경우에만 main 함수를 직접 구현하면 된다.

## 참고 자료
- [Apple Documentation - App Structure](https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle)
- [Swift Evolution - SE-0281](https://github.com/apple/swift-evolution/blob/main/proposals/0281-main-attribute.md)
- [Swift Evolution - SE-0383](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0383-deprecate-uiapplicationmain-and-nsapplicationmain.md)