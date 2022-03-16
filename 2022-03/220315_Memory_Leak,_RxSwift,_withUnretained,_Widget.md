# 220315 Memory Leak, RxSwift, withUnretained, Widget

# TIL (Today I Learned)

3월 15일 (화)

## 학습 내용

- modal이 닫혀도 사라지지 않는... memory leak 해결하기
- RxSwift - withUnretained()
- Widget 예습 (3/16)

&nbsp;

## 고민한 점 / 해결 방법

**[Memory Leak 확인하는 방법]**

> modal을 Cancel 버튼이 아니라 다른 View를 터치해서 창을 내릴 경우 메모리에서 사라지지 않고 메모리가 계속 늘어나는 것을 확인했다. 정확히 메모리 누수가 발생하는 것인지 궁금하여 찾다가 `Instrumnets`라는 도구를 알게되었다.

* 메모리 누수가 되고있는지 확인하려면 `Command + I`를 눌러 빌드를 한다.
* 그러면 Instrumnets 도구가 뜨는데...
    * Instrumnets란?
        * Xcode에 통합된 일련의 애플리케이션 성능 분석 도구
        * Allocation 상태를 확인 가능
        * Memory leak 상태 확인 가능

![](https://i.imgur.com/thRuFvQ.png)

* 도구가 뜨면 여러 아이콘 중에서 `Allocations`라는 아이콘을 클릭하면,

![](https://i.imgur.com/QAUgfyN.png)

* 위와 같은 창이 나타난다.
* 여기서 좌측에 빨간색 녹화버튼을 누르면 시뮬레이터가 실행되면서 수치를 기록해준다.

![](https://i.imgur.com/YWf4Ejj.png)

* 메모리 누수가 발생할 경우 아래처럼 메모리 카운트가 올라간다.

![](https://i.imgur.com/GbcKLb2.png)

---

**[RxSwift - withUnretained()]**

* 보통은 클로저 내부에서 강한 참조 사이클을 방지하기 위해 weak self와 guard let self를 활용하여 바인딩 처리를 해주는데, 이 동작을 간결하게 해주는 operator가 존재했다.
* RxSwift 6.0부터 새롭게 생겼으며, weak self 대신 활용할 수 있다.

```swift
viewModel.someInfo  // Observable<String>
    .withUnretained(self)  // (self, String) 튜플로 변환해줌
    .bind { (owner, string) in
        owner.label.text = string // owner를 self 대신 사용!
    }
    .disposed(by: disposeBag)
```

---

**[Widget 만들기]**

### 시작전

위젯은 기능이 제한적이며 interactive 하지도 않지만 우리는 앱과 위젯이 데이터를 공유하기를 원할수도 있다.

> App과 Extension 간의 관계
[App Extension Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1) 를 살펴보면 App 과 Extension 간의 관계를 볼 수 있다.

![](https://i.imgur.com/BzmcpTf.png)

* extension's bundle이 containing app's bundle내에 중첩되더라도 실행중인 app extension과 containg app은 서로의 contatiner에 접근할 수 없다.
* 하지만 데이터 공유를 활성화 할 수 있다.
    * container app과 contained app extensions의 App Groups를 활성화하고 앱에서 사용할 App Groups를 지정한다.
* App Groups를 활성화하면 app extension과 containing app 모두 UserDefaults를 사용해서 데이터를 공유할 수 있다.
* 그 후 새로운 UserDefaults 객체를 인스턴스화하고 App Groups의 식별자를 전달하면 된다.

### 프로젝트 설정 - App Groups 권한

> 우선 데이터를 공유하려면 App Groups에 추가해야한다.
* `main app Target` > `Signing & Capabilities` > `+ Capability` > `App Groups 추가`
* `New Container`를 추가한다.
    * 이때 `group.`을 prefix로 가지는 포맷이 제공되는데, App Group identifier는 bundle identifier처럼 유니크한 값이기 때문에 번들을 활용하여 이름을 지어주었다.
    * ex) `group.com.leeari.net.widget-example.My-Widget`

![](https://i.imgur.com/DJHnOin.png)

### 앱에 Widget Target을 추가하기

![](https://i.imgur.com/qyXbFQd.png)

* Xcode에서 프로젝트를 열고 `File` > `New` > `Target`을 클릭한다.
* Application Extension 그룹에서 `Widget Extension`을 클릭한다.
* 위젯 이름을 입력하고 create를 해주면 끝~

### WidgetConfiguration

* `IntentConfiguration`
    * 사용자가 구성할 수 있는 속성이 있는 위젯
    * 위젯에서 Edit을 통해서 위젯에 보여질 내용을 변경할 수 있다.
* `StaticConfiguration`
    * 사용자가 구성할 수 있는 속성이 없는 위젯
    * 정적인 데이터를 보여주기에 알맞은 타입의 위젯이다.
        * 일반적으로 주식시장 위젯이나 뉴스 헤드라인을 보여주는 위젯

> 이 구성들의 이니셜라이저 파라미터를 하나씩 살펴보자.

```swift
@main
struct MyWidget: Widget {
    private let kind: String = "My_Widget"

    var body: some WidgetConfiguration { // 위젯 식별 및 위젯의 Content 표시
        StaticConfiguration( // 정적인 데이터를 보여주기에 알맞은 타입의 위젯
            kind: kind, // 위젯의 identifier
            provider: Provider() // 렌더링할 시기를 widgetkit에 알려주는 타임라인을 생성
        ) { entry in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemLarge])
    }
}
```

* `Kind`
    * 위젯을 식별하는 문자열
* `Provider`
    * TimelineProvider를 준수하고 위젯을 렌더링할 시기를 WidgetKit에 알려주는 타임라인을 생성해준다.
    * 타임라인에는 사용자가 정의한 Custom TimelineEntry 타입이 포함되어있다.
    * TimelineEntry은 WidgetKit이 위젯의 콘텐츠를 업데이트하기를 원하는 date를 식별한다.
```swift
struct Provider: TimelineProvider { // 시간에 따른 위젯 업데이트 로직
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.leeari.net.widget-example"))
    var emojiData: Data = Data()

    // 특정 내용이 없는 시각적 표현
    func placeholder(in context: Context) -> EmojiEntry {
        EmojiEntry(emoji: Emoji(icon: "😶‍🌫️", name: "N/A", description: "N/A"))
    }
    
    // 위젯 갤러리에서 보여질 부분
    func getSnapshot(in context: Context, completion: @escaping (EmojiEntry) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else {
            return
        }
        let entry = EmojiEntry(emoji: emoji)
        completion(entry)
    }
    
    // 정의한 타임라인에 맞게 업데이트해서 보여질 내용
    func getTimeline(in context: Context, completion: @escaping (Timeline<EmojiEntry>) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else {
            return
        }
        let entry = EmojiEntry(emoji: emoji)
        let timeline = Timeline(entries: [entry], policy: .atEnd) // 타임라인을 제공해주는 시기를 가능한 즉시 새로운 타임라인을 요청
        completion(timeline)
    }
    
    
}

```
* `Content Closure`
    * SwiftUI 뷰를 포함하는 클로저
    * WidgetKit은 이를 호출하여 위젯의 콘텐츠를 렌더링하고 Provider로부터 TimelineEntry 파라미터를 전달한다.
```swift
struct WidgetEntryView : View { // 위젯을 표시하는 뷰
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family // 위젯 크기를 다양하게 접근할 수 있는 래퍼
    
    @ViewBuilder
    var body: some View {
        switch family { // 여러 사이즈에 대응하는 로직
        case .systemSmall:
            EmojiView(emoji: entry.emoji)
        case .systemMedium:
            HStack(spacing: 30) {
                EmojiView(emoji: entry.emoji)
                Text(entry.emoji.name)
                    .font(.largeTitle)
            }
        default:
            VStack(spacing: 30) {
                HStack(spacing: 30) {
                    EmojiView(emoji: entry.emoji)
                    Text(entry.emoji.name)
                        .font(.largeTitle)
                }
                Text(entry.emoji.description)
                    .font(.title2)
                    .padding()
            }
        }
        EmojiView(emoji: entry.emoji)
    }
}
```
* `Custom Intent`
    * Custom 가능한 속성을 정의하는 user configurable 프로퍼티

### Widget Modifier

![](https://i.imgur.com/r5iCn6o.png)

Configuration 밑에 modifier들이 붙어있는 것을 볼 수 있는데, 간단히 3가지 정도가 있다.

* `configurationDisplayName`
    * 사용자가 위젯을 추가/편집할 때 위젯에 표시되는 이름을 설정하는 메소드
* `description`
    * 사용자가 위젯을 추가/편집할 때 위젯에 표시되는 설명을 설정하는 메소드
* `supportedFamilies`
    * 위젯이 지원하는 크기를 설정할 수 있는 메소드
    * 배열에 하나만 넣어주면 하나의 사이즈만 나오게되고, 별다른 설정을 해주지 않는다면 3가지 사이즈가 기본으로 설정된다.

### TimelineEntry

```swift
struct EmojiEntry: TimelineEntry {
    var date: Date = Date()
    let emoji: Emoji
}
```

TimelineEntry는 프로토콜인데, date라는 프로퍼티를 필수적으로 요구한다.
이 date는 WidgetKit이 widget을 렌더링할 날짜를 의미한다.
Timleline은 위젯을 만들 때 Widget을 어떤 시점에 업데이트할지 알려줄 때 사용한다.
Provider의 getTimeline 메소드가 해당 역할을 한다.

### TimelineProvider

```swift
struct Provider: TimelineProvider { // 시간에 따른 위젯 업데이트 로직
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.leeari.net.widget-example"))
    var emojiData: Data = Data()

    // 특정 내용이 없는 시각적 표현
    func placeholder(in context: Context) -> EmojiEntry {
        EmojiEntry(emoji: Emoji(icon: "😶‍🌫️", name: "N/A", description: "N/A"))
    }
    
    // 위젯 갤러리에서 보여질 부분
    func getSnapshot(in context: Context, completion: @escaping (EmojiEntry) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else {
            return
        }
        let entry = EmojiEntry(emoji: emoji)
        completion(entry)
    }
    
    // 정의한 타임라인에 맞게 업데이트해서 보여질 내용
    func getTimeline(in context: Context, completion: @escaping (Timeline<EmojiEntry>) -> Void) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else {
            return
        }
        let entry = EmojiEntry(emoji: emoji)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
```
TimelineProvider도 프로토콜이다.
Widget의 디스플레이를 업데이트 할 시기를 WidgetKit에 알려주는 타입이다.

### TimelineReloadPolicy

가장 이른 날짜(the earliest date)를 나타내는 타입
타입 프로퍼티 3개를 가지고 있다.

* `atEnd`
    * 타임라인의 마지막 날짜가 지난 후 WidgetKit이 새 타임라인을 요청하도록 지정하는 policy이다.
    * 기본 refresh policy이다.
* `after(date:)`
    * WidgetKit이 새 타임라인을 요청할 미래 날짜를 지정하는 policy
* `never`
    * WidgetKit은 앱이 WidgetCenter를 사용하여 WidgetKit에 새 타임라인을 요청하도록 지시할 때 까지 다른 timeline을 요청하지 않는 policy이다.
    * 즉, 누가 지시할 때 까지 다른 timeline을 요청하지 않는다고 보면 될 것 같다.


---

- 참고링크
    - https://www.agnosticdev.com/blog-entry/ios/profiling-memory-allocations-ios-instruments
    - https://ios-development.tistory.com/604
    - https://stackoverflow.com/questions/58121495/memory-leak-when-displaying-a-modal-view-and-dismissing-it
    - https://velog.io/@dlskawns96/RxSwift-Closure%EC%97%90%EC%84%9C-Memory-Leak-%ED%94%BC%ED%95%98%EA%B8%B0
    - https://zeddios.tistory.com/1088
    - https://zeddios.tistory.com/1089
