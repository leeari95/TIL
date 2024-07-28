# 240726 Live Activity, App Extension, Tuist, Widget


기존 UIKit 프로젝트에 Live Activity를 추가해보자!

7월 26일 (금)


# 학습내용


- Tuist에 App Extension 추가하는 방법
- Live Activity 초기 구현


# 고민한 점 / 해결방법

## Tuist로 관리하는 프로젝트에 위젯을 추가하기 위한 Extension 설정

1. 기존 프로젝트 타겟에 아래와 같이 추가해준다.

```swift
let targets: [Target] = [
    // 기존 프로젝트 타겟...
    .target(
        name: "LiveActivity",
        destinations: [.iPhone, .iPad],
        product: .appExtension,
        bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER).WidgetExtension",
        deploymentTargets: .iOS("15.0"),
        infoPlist: .file(path: "LiveActivity/Info.plist"),
        sources: [
            "LiveActivity/Sources/**"
        ],
        resources: .resources(["LiveActivity/Resources/**"], 
        dependencies: [],
        settings: .settings(
            configurations: [
                .debug(name: .debug, xcconfig: .relativeToRoot("Project/Configurations/LiveActivity.xcconfig")),
                .release(name: .release, xcconfig: .relativeToRoot("Project/Configurations/LiveActivity.xcconfig"))
            ],
            defaultSettings: .none
        )
    )
]
```

2. 프로젝트 Dependencies에 새로 만든 App Extension 타겟을 추가해준다.

```swift
let dependencies: [TargetDependency] = [
    // ....
    .target(name: "LiveActivity")
]
```


## Live Activity 초기 설정 구현해보기

Tuist에서는 타겟을 추가한다고 해서 초기 .swift 파일을 생성해주지 않기 때문에, Xcode에서 직접 타겟을 추가해서 해당 파일을 활용하였다.

![](https://github.com/user-attachments/assets/74a8ccdd-7c4c-491f-8ccd-4936f870668f)

![](https://github.com/user-attachments/assets/c8b95428-e917-42cd-8ad4-478ee06dff83)
![](https://github.com/user-attachments/assets/d3bb67af-39d5-4aca-a581-e71fbc8bb67c)

> Include Configuration App Intent: App Intent 프레임워크는 앱의 동작과 콘텐츠를 Siri, Spotlight, Widget, Control 등을 포함한 여러 플랫폼의 시스템 환경과 긴밀하게 통합하는 기능을 제공합니다. Apple Intelligence와 향상된 App Intent를 통해 Siri는 사람들이 앱의 기능을 발견할 수 있도록 앱의 동작을 제안하고 앱 내에서 그리고 앱 전반에서 동작을 수행할 수 있는 기능을 제공합니다.


기본 구현은 위젯까지 구현되어있지만, 나는 Live Activity만을 구현할거라 구현된 위젯 코드는 모두 제거해주고 Live Activity를 구현하기 위해 아래와 같이 필요한 코드만 남겨두었다.

```swift
import ActivityKit
import SwiftUI
import WidgetKit

// Target Membership for this file: UIKit App + Widget Exension
@available(iOS 16.2, *)
struct Attributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
```

여기서 Attributes는 UIKit을 사용하고 있는 앱 타겟에서 사용해야하기 때문에 Target membership을 둘다 추가해주었다.
주로 Live Activity를 활성화/비활성화, 그리고 업데이트 해줄 때 사용되는 타입이다.

```swift
import SwiftUI
import WidgetKit

// Target Membership for this file: Widget Exension
@available(iOS 16.2, *)
@main
struct Bundle: WidgetBundle {
    var body: some Widget {
        LiveActivity()
    }
}

@available(iOS 16.2, *)
struct LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveStreamNotificationAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
```

위 코드는 위젯의 UI를 그려주는 코드이다. Xcode에서 기본적으로 제공해주는 샘플 코드다.

그리고 UIKit 앱 내에서는 아래와 같이 주로 사용한다.

```swift
// 라이브 액티비티 활성화하기
let attributes = Attributes(name: "test")
let contentState = Attributes.ContentState(emoji: "🐷")

do {
    let activity = try ActivityKit.Activity<Attributes>.request(
        attributes: attributes,
        content: .init(state: contentState, staleDate: nil),
        pushType: nil
    )
    print(activity)
} catch {
    print("start Activity From App: \(error)")
}
```

```swift
// 라이브 액티비티 업데이트
Task {
    let updateContentState = Attributes.ContentState(emoji: state.emoji)
    for activity in ActivityKit.Activity<Attributes>.activities {
        await activity.update(.init(state: updateContentState, staleDate: nil))
    }
}
```

```swift
// 라이브 액티비티 비활성화
Task {
    for activity in ActivityKit.Activity<Attributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
    }
}
```

# Trouble shooting


## Live Acticity UI가 그려지지 않는 문제

### 문제

기존 UIKit 앱이 설치되어있는 상황에서 Live Activity 초기 설정을 구현하고, 빌드를 돌렸는데, 시뮬레이터와 디바이스 모두 Live Activity를 활성화하고, 백그라운드에서 다이나믹 아일랜드를 클릭하면 앱으로 진입은 되서 활성화는 된 듯 하나, UI가 전혀 보여지지 않는 문제였다.

### 해결

몇시간 삽질했는데 도저히 이유를 알 수가 없었다.
팀원분들에게 공유드렸는데, 같은 삽질을 했던 내용을 알게되었다.
해결방법은 너무 간단했다.

1. 기존 앱을 제거한다.
2. 빌드를 다시 돌려서 앱을 재설치한다.

앱 제거해도 나타나지 않으면 앱 제거후 디바이스를 재시작하여 앱을 다시 설치하면 된다고 한다.

위 방법으로 너무나도 손쉽게 문제를 해결할 수 있었다... Xcode 내에서 뭔가 충돌이 발생한 문제인걸까...?


---


# 참고 링크

- [https://developer.apple.com/documentation/widgetkit/making-a-configurable-widget](https://developer.apple.com/documentation/widgetkit/making-a-configurable-widget)
- [https://github.com/tuist/tuist/blob/main/fixtures/ios_app_with_extensions/Project.swift](https://github.com/tuist/tuist/blob/main/fixtures/ios_app_with_extensions/Project.swift)
- [https://developer.apple.com/documentation/AppIntents](https://developer.apple.com/documentation/AppIntents)
- [https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)
- [https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications](https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications)