# 220221 Localization, 퀴즈 오답노트, SwiftUI Tutorial
# TIL (Today I Learned)

2월 21일 (월)

## 학습 내용

- 활동학습 퀴즈 오답노트
- Localization 활동학습
- SwiftUI - Stanford Tutorial

&nbsp;

## 고민한 점 / 해결 방법

**[퀴즈 오답노트]**

* CoreData는 `Foundation`을 참조할까?
    * ![](https://i.imgur.com/WvELlD9.png)
    * 참조하고 있다!
* `height intrinsic size`을 가지는 것은?
    * UIButton
        * width, height 모두 intrinsic size가 존재한다.
    * UISlider
        * width는 없고 height는 존재한다.
    * UITextField
        * width, height 모두 존재한다.
    * UITextView
        * 내용이 있든 없든 `isScrollEnabled == true` 라면 width, height 모두 intrinsic size가 없다.
        * false인 경우에는 내용이 있을 때 스크롤을 끄거나, 내용이 없을 때 스크롤을 꺼도 intrinsic size가 생긴다.
* 프로젝트에 적용된 코코아팟과 라이브러리 버전을 확인할 수 있는 파일은?
    * `Podfile.lock`
    * pod install을 하고나면 Podfile 이외에 Podfile.lock이라는 파일이 같이 생긴다.
    * Podfile.lock은 pod의 버전을 계속 추적하여 기록해놓고 유지시키는 역할을 한다.
    * 또한 Podfile.lock에는 유일성을 보증하는 해쉬값인 CHECKSUM이 부여된다.
    * 만약 pod 버전에 하나라도 변화가 생긴다면 CHECKSUM 또한 변하게 되는 것이다.
    * 이경우 Git을 사용할 경우 Podfile.lock이 diff로 잡히게 된다.
* Data Container 중 Library는 사용자가 접근할 수 있는 영역일까?
    * 아니다. Library는 사용자에게 직접 노출되지 않고, 앱의 기능이나 관리에 필요한 파일을 저장해두는 파일이다.
    * 사용자에게 노출되면 안되는 파일을 여기에 저장한다.
    * Data Container 중 사용자가 유일하게 접근할 수 있는 영역은 `Documents`이다.

---

**[Localization]**

### 지역화란?
* 지역화는 현지화한다는 뜻을 가졌다
* 즉, 해당 언어와 나라 지역에 맞게 앱을 설정해주는 것을 뜻한다.
* 국제화(internationalization)를 I18N or i18n으로, 지역화(localization)를 L10N이나 l10n으로 표기한다

### 지역화의 전제조건
* 해당 앱이 지역화가 되려면 여러 국가에 배포되어 국제화 되어있는 앱이라는 조건이 있어야 한다.
* 해당 앱이 한국에서만 사용되는 앱이라면 지역화가 의미 없을 것이다.

### 지역화 가능한 요소
* RTL, LTR (문화권에 따른 읽기/쓰기 방식), 언어, 시간, 날짜, 주소, 화폐단위 및 통화, 이미지 등등...

### 지역화와 접근성의 관계
* 지역화를 함으로 여러 국가와 지역에서 해당 앱에 대한 접근성(accessibility)가 우수해진다.
* 접근성은 애플의 가장 강점인 부분으로 꼭 이 부분을 잘 활용하여 구현해놓으면 좋다.
    * 접근성(accessibility)을 설정하려면 accessibility inspector를 활용하여 여러가지를 구현할 수 있다.

언어 지역화
* 지역화 하려는 언어를 프로젝트에 추가한다.
    * 타겟을 선택해서 다국어화

![](https://i.imgur.com/LXGcj3d.png)

*  코드로 다국어 처리
    * Strings 파일을 생성하고
        * `Localizable.strings` 로 네이밍 변경

![](https://i.imgur.com/WoU9xAR.png)

* Localize... 버튼 클릭

![](https://i.imgur.com/y32fgtE.png)

* 다시 타겟으로 돌아가서 지역화하고 싶은 언어를 추가해주기 

![](https://i.imgur.com/vbkbUyR.png)

* 아까 만든 파일을 체크해주고 Finish

![](https://i.imgur.com/nHotMZL.png)

* 프로젝트에 파일이 생성되어 있는 모습

![](https://i.imgur.com/jcCIwcf.png)

![](https://i.imgur.com/yclkqR1.png)

* Localizable.strings에 다국어 처리를 햅주면 되는데, Key와 Value로 다국어 처리를 해줄 수 있다.

![](https://i.imgur.com/6bOA2a5.png)

![](https://i.imgur.com/ne1UxDS.png)

* 그리고 다국어화 한 문자열을 사용할 땐 `NSLocalizedString` 메소드를 활용해주어야 하는데, 번거로우니 extension을 활용하여 간단히 사용해볼 수 있다.

```swift
test.text = String(format: NSLocalizedString("Test", comment: ""))

// String Extension for Localization
extension String {
    var localized: String {
    	return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
text.text = "Test".localized
```
> 스토리보드를 코드로 말고 Interface Builder Storyboard 옵션을 활용하여 스토리보드 자체를 지역화해줄 수도 있다.

![](https://i.imgur.com/x8neP9B.png)

> 앱의 언어를 바꿀 때는 App Language, App Region 둘다 바꿔주자.
![](https://i.imgur.com/sR5vqSC.png)

> 이미지의 지역화는 Assets에 접근해서 이미지를 클릭후 우측 인스펙터에서 Localization을 활성화 시켜주면 된다.
![](https://i.imgur.com/xCXc1AU.png)

> 날짜 지역화

```swift
let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        dateTimeLabel.text = date
```

> 통화 지역화

```swift
func currency(text: Double) -> String? {
    let locale = Locale.current
    let price = text as NSNumber
    let formatter = NumberFormatter()

    formatter.numberStyle = .currency
    formatter.currencyCode = locale.languageCode
    formatter.locale = locale

    return formatter.string(from: price)
}

currencyLabel.text = currency(text: 3000.34)
```

> 뷰의 방향을 지역화 (방향 바꿀 때에도 유용하게 쓰는 듯?)

```swift
view.semanticContentAttribute = .forceRightToLeft
```

> 여러 문자열들을 지역화할 때 구글 스프레드 시트를 활용하기

![](https://i.imgur.com/U4VhRNW.png)

* 구글 스프레드 시트를 새로 생성한 후 위 사진과 같이 국가코드와 번역할 문장을 적으면 된다.
* 좌측에 국제코드를 적고 우측에 아래 코드를 적으면 번역한 문장이 생성된다. ([국가코드 참고사이트](https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html))
```
// 예시
=GOOGLETRANSLATE("Welcome to yagom-academy", "en", A10)
```
---

**[SwiftUI - Stanford Tutorial]**

### Getting started with SwiftUI

> 프로젝트를 생성한다.
![](https://i.imgur.com/IjqHctr.png)

> 그럼 다음과 같은 코드가 기본적으로 생성된다

```swift
import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

* 먼저 MemorizeApp.swift 파일을 살펴보면, App 프로토콜을 채택하고 있는 것을 볼 수 있다.
* SwiftUI App Life Cycle을 사용하는 앱은 App 프로토콜을 준수해야하고, body 프로퍼티는 하나 이상의 scene을 반환한다.
* @main은 앱의 진입점을 가리키는 attribute identifier이다.

```swift
import SwiftUI

struct ContentView: View {
    var body: some View { // UI를 구성하는 코드
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { // 우측에 Preview를 띄워주는 코드
        ContentView()
    }
}
```

* 기본적으로 SwiftUI View file은 두 가지 구조체를 선언한다.
* 첫번째 구조체는 View 프로토콜을 준수하며 뷰의 컨텐츠와 레이아웃을 묘사한다.
* 두 번째 구조체는 해당 뷰에 대한 Preview를 선언하고 있다.

> Text의 속성을 바꾸고 싶다면?

* command 키를 누르고 Text를 클릭하면 아래와 같은 창이 뜨는데, Show SwiftUI Inspector...를 눌러주자

![](https://i.imgur.com/RRBIzHm.png)

* 그러면 Text의 각 속성값들을 바꿀 수 있는 Inspector가 표시되는 것을 확인할 수 있다.

![](https://i.imgur.com/xCloFxQ.png)

* 혹은 control + option 키를 같이 누르고 Text를 클릭해도 표시된다.

![](https://i.imgur.com/LXRgwOu.png)

* 인스펙터에서 설정한 모든 것들이 코드로 바로바로 표기되는 것을 확인해볼 수 있다.
* SwiftUI View를 커스터마이징 하기 위해서는 modifiers라는 메서드를 호출해야한다. 이 modifiers는 뷰를 랩핑하여 디스플레이나 다른 속성들을 변경한다.
* 각각의 modifiers는 새로운 View를 반환하므로 여러 modifier를 수직으로 쌓듯이 연결하는 것이 일반적이다.
* 따라서 SwiftUI Inspector를 통해 변경하던지, 아니면 코드의 modifer를 수정하던지 이러한 변경사항들을 Xcode는 즉각 업데이트 한다.

---

**[Combine Views Using Stacks]**

* SwiftUI 뷰를 생성할 때 뷰의 body 프로퍼티에는 content, layout 및 동작을 기술한다.
* 하지만 이 body 프로퍼티는 오직 하나의 싱글 뷰만 반환한다.
* 하지만 스택을 활용한다면 이 뷰들을 결합시키고 임베드할 수 있다.
* 스택에는 총 3가지 종류가 있다
    * HStack
        * Horizontal Stack 수평 스택
    * VStack
        * Vertical Stack 수직 스택
    * ZStack
        * Z축을 기준으로 뷰를 쌓는 스택
        * ZStack안에 뷰를 여러개 넣는다고 가정하면 제일 상위뷰에 addsubview하는 느낌이라고 생각하면 된다.

> Custom View를 생성

```swift
struct CardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(lineWidth: 3)
            Text("🍎")
                .foregroundColor(.orange)
                .font(.largeTitle)
        }
    }
}
```
* ZStack으로 쌓여있다.
    * RoundedRectangle가 2개
    * Text가 1개
    * 총 3개가 쌓여있다.
* 이렇게 만들어진 뷰를 ContentView에 HStack으로 쌓아올려보자

```swift
struct ContentView: View {
    var body: some View {
        HStack {
            CardView()
            CardView()
            CardView()
            CardView()
        }
        .padding()
        .foregroundColor(.red)
    }
}
```

* 이런식으로 View를 생성하여 레고처럼 쌓을 수 있다.

> Preview 디바이스에 다크모드 적용방법

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark) // 이 부분을 추가해주면 다크모드로 변한다.
    }
}
```

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
```

* 이렇게 한다면 라이트모드, 다크모드 두개의 디바이스를 Preview로 확인해볼 수 있다.

---

**[@State]**

https://developer.apple.com/documentation/swiftui/state

* View 구조체 안에서 var 키워드로 선언한 프로퍼티의 값을 구조체 내에서 변경하려고 하면 에러가 뜬다.
* Swift 구조체에서 mutating으로 선언되지 않은 연산 프로퍼티는 구조체 내부에서 그 값의 변경이 불가능하다.
* 이럴 때 `@State` 라는 속성을 부여해주면 해결해줄 수 있는데, 어떤 역할을 하는 것일까?
    * 단어 그대로 현재 상태를 나타내는 속성으로써 뷰의 어떤 값을 저장하는 데 사용한다.
    * 즉, State는 value 자체가 아니다. 값을 읽고 변경하는 수단으로, state의 기본값에 접근하려면 value프로퍼티를 사용해야 한다.
    * 그리고 현재 UI의 특정 상태를 저장하기 위해 만들어진 것이기 때문에 보통 private으로 지정하여 사용한다.
    * State 값이 변경되면 View가 appearance를 inbalidates하고 body를 다시 계산(recomputes)한다

```swift
struct CardView: View {
    @State private var isFaceUp: Bool = false // @State 속성 부여
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25.0)
            if isFaceUp { // 속성에 따라 카드를 다르게 보여주기
                shape
                    .foregroundColor(.white)
                shape
                    .stroke(lineWidth: 3)
                Text("🍎")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
            } else {
                shape
                    .fill()
            }
        }
        .onTapGesture {
            self.isFaceUp = !isFaceUp // 터치할 때마다 프로퍼티 값을 바꿔준다.
        }
    }
}
```
* 터치 이벤트가 발생할 때 마다 CardView 구조체가 갖고 있는 isFaceUp 변수에 있는 값을 변경하도록 코드를 수정해주었다.

> ### [onTapGesture(count:perform:)](https://developer.apple.com/documentation/swiftui/view/ontapgesture(count:perform:))

* SwiftUI에서 관리하는 값을 읽고 쓸 때 사용하는 메소드이다.
* 상태값이 변경되면 View를 다시 계산하고 업데이트 한다.
* 인스턴스 값이 아니라 값을 읽고 쓰는 수단이다
* 주의할 점은 뷰의 바디 안에서 또는 뷰에서 호출한 메소드에서만 접근해야하므로 뷰의 클라이언트가 접근하지 못하도록 private하게 선언해야 한다.
* 사용할 때는 $와 함께 사용하면 된다.

> ### 일반 변수로 선언해서 쓰면 되는 것이 아닌가?

* 그냥 변수로 선언할 경우 Cannot use mutating member on immutable value: 'self' is immutable 라는 에러가 발생한다.
* Swift는 mutating으로 선언되지 않은 연산 프로퍼티 구조체 내부에서 값 변경이 불가능하다.

> ### mutating으로 선언하면 되면 안될까...?

https://developer.apple.com/documentation/swiftui/view

* 여기서 살펴볼 것은 self는 View 프로토콜을 채택한 뷰이다.
* View의 내부를 살펴보면 body가 get으로 되어있는 것을 확인할 수 있다.
* 즉 mutating으로 바꿀 수가 없다.
* 고로 상태를 변경하기 위해선 @State를 이용해야한다.

> ### $는 언제 쓰는거지?

* $는 Binding을 파라미터로 가지고 있는 View들과 바인딩 하여 사용할 수 있다.

---

**[ForEach]**

https://developer.apple.com/documentation/swiftui/foreach

* 일반적으로 SwiftUI에서 Sequence를 반복하여 뷰들을 생성하고자 하는 경우 ForEach를 활용한다.
* ForEach는 자체적인 뷰 구조체이며, 원하는 경우 직접적으로 뷰 body로 반환할 수 있다.
* 항목의 배열을 제공하고 값이 변경될 때 업데이트 하는 방법을 알기 위해서 각각의 고유하게 식별할 수 있는 방법을 SwiftUI에게 알려줘야할 수도 있다.
* 또한 반복문의 각 항목에 대한 뷰를 생성하기 위해 실행할 클로저를 전달한다.

> ### id: \.self

* SwiftUI가 배열의 각 요소를 고유하게 식별할 수 있도록 하기 위해 필요한 파라미터다.
* 항목을 추가하거나 삭제 시 어떤 것을 처리했는지 SwiftUI가 정확히 알고 있다는 뜻이다.

> ### 배열에 Custom 타입이 있는 경우에는???

https://developer.apple.com/documentation/swiftui/view/id(_:)

* 타입에서 고유하게 식별할 수 있는 프로퍼티인 id를 사용해야한다.
    * 고유함을 보장하는 의미의 UUID 타입을 가진 프로퍼티를 만들어 활용할 수 있다.

```swift
struct SimpleGameResult {
    let id = UUID()
    let score: Int
}

struct ContentView: View {
    let results = [
        SimpleGameResult(score: 8),
        SimpleGameResult(score: 5),
        SimpleGameResult(score: 10)
    ]

    var body: some View {
        VStack {
            ForEach(results, id: \.id) { result in
                Text("Result: \(result.score)")
            }
        }
    }
}
```

> ### protocol `identifier` 

https://developer.apple.com/documentation/swift/identifiable

* 이 프로토콜을 준수하는 타입을 만들었을 경우에는 id: \.self를 제외한 ForEach를 사용할 수 있다.
* 해당 프로토콜을 준수한다는 것은 각 인스턴스를 고유하게 식별하는 id 프로퍼티를 추가한다는 것을 의미한다.

```swift
struct IdentifiableGameResult: Identifiable {
    var id = UUID()
    var score: Int
}

struct ContentView: View {
    let results = [
        IdentifiableGameResult(score: 8),
        IdentifiableGameResult(score: 5),
        IdentifiableGameResult(score: 10)
    ]

    var body: some View {
        VStack {
            ForEach(results) { result in
                Text("Result: \(result.score)")
            }
        }
    }
}
```

> ContentView에 배열을 추가하여 ForEach를 사용한 예제

```swift
struct ContentView: View {
    var emojis = ["🍎", "🍐", "🍑", "🍒"]
    var body: some View {
        HStack {
            ForEach(emojis, id: \.self) { emoji in
                CardView(contant: emoji)
            }
        }
        .padding()
        .foregroundColor(.red)
    }
}
```

---

**[Button]**

https://developer.apple.com/documentation/swiftui/button

```swift
Button(action: {
    // action
}) {
    // display
}
```

* SwiftUI에서 일반 버튼을 만들기 위해서는 위와 같이 선언해주면 된다.
    * action은 사용자가 버튼을 클릭하거나 탭할 때 작업을 수행하는 클로저 프로퍼티이다.
    * Label은 버튼의 텍스트나 아이콘 같은 동작을 실행하는 View를 나타낸다.

```swift
// 카드를 추가하는 버튼을 예시로 만들어보자.
    var add: some View { // 버튼 프로퍼티 생성
        return Button(action: { // 버튼을 클릭했을 때 실행할 액션
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        }, label: {
            HStack { // 버튼의 외관
                Image(systemName: "plus.circle")
            }
        })
    }
```

---

**[Spacer]**

https://developer.apple.com/documentation/swiftui/spacer

* 이름에서부터 알 수 있 듯 어떤 빈 공간을 만들어준다.
* 이 빈 공간은 다른 뷰의 크기에 Priority를 두고 그 크기가 변하지 않는 선에서 본인의 크기를 최대한 늘리고자하는 성질을 가지고 있다.
* 따라서 파라미터 minLength를 주지 않고 Spacer()를 그냥 호출할 경우, 늘어날 수 있는 최대한의 크기만큼 여백이 생긴다.

![](https://i.imgur.com/VXbEder.png)


```swift
// 여기까지 Full Code
struct ContentView: View {
    var emojis = ["🍎", "🍐", "🍑", "🍒", "🍊", "🥝", "🍌", "🍈", "🍓", "🥭", "🍍", "🍅", "🍇", "🍋", "🫐"]
    @State var emojiCount = 4
    var body: some View {
        VStack {
            HStack {
                // for문을 emojiCount만큼 반복하기
                ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                    CardView(contant: emoji)
                }
            }
            .foregroundColor(.red) // CardView가 담겨져있는 Stack만 빨강색, 아래 버튼들은 기본색인 blue로 입혀진다.
            Spacer(minLength: 20) // 스택 사이 20만큼 여백주기
            HStack {
                add // 플러스버튼
                Spacer() // 그 사이 여백주기
                remove // 빼기버튼
            }
            .font(.largeTitle) // 버튼의 크기
            .padding(.horizontal)
        }
        .padding()
    }
    
    var add: some View { // 버튼 프로퍼티 생성
        return Button(action: {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        }, label: {
            HStack {
                Image(systemName: "plus.circle")
            }
        })
    }
    
    var remove: some View { // 버튼 프로퍼티 생성
        return Button(action: {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        }, label: {
            HStack {
                Image(systemName: "minus.circle")
            }
        })
    }
}
```

---

**[LazyVGrid]**

https://developer.apple.com/documentation/swiftui/lazyvgrid

![](https://i.imgur.com/4gNdPfi.png)


* Grid는 List와 친척이라고 생각하면 된다
* Grid는 horizontal Direction으로 사진을 배열하여 화면을 구성하기 좋다.
* 가장 좋은 예로 Instargram, Netflix의 레이아웃을 떠올리면 된다.

![](https://i.imgur.com/rlweSrn.jpg)

https://developer.apple.com/documentation/swiftui/lazyvgrid

* columns 파라미터를 통해 그리드를 깔아줄 열의 개수만큼 GridItem() 배열을 넘겨주면 열의 개수를 지정할 수 있다.
* 특정 열에 fixed()를 활용해서 고정값을 주어 각 열의 크기를 다르게 조절할 수도 있다.

> ### Lazy 하다는 의미는 무엇일까?

https://developer.apple.com/documentation/swiftui/creating-performant-scrollable-stacks

> ### Creating Performant Scrollable Stacks
Display large numbers of repeated views efficiently with scroll views, stack views, and lazy stacks.

* SwfitUI에서는 `LazyVStack` , `LazyHStack` , `LazyVGrid` , `LazyHGrid` 와 같이 Lazy 라는 이름이 붙은 뷰 빌더들을 볼 수 있다.
* lazy와 함께 선언된 프로퍼티는 처음 호출될 때 값을 계산하기 때문에 필요하지 않는 시간 동안은 값을 생성하지 않는다.
* 따라서 SwiftUI에서 Lazy라는 이름이 앞에 붙은 뷰 빌더들도 화면에 그려야할 필요가 있는 뷰들에 한해서만 body를 계산한다.
* 때문에 `화면에 굳이 나타낼 필요가 없는 데이터`들을 계산하지 않기 때문에 많은 데이터를 다루는 경우 `효율적`으로 사용될 수 있다.

>Stack views and lazy stacks have similar functionality, and they may feel interchangeable, but they each have strengths in different situations. Stack views load their child views all at once, making layout fast and reliable, because the system knows the size and shape of every subview as it loads them. Lazy stacks trade some degree of layout correctness for performance, because the system only calculates the geometry for subviews as they become visible.
When choosing the type of stack view to use, always start with a standard stack view and only switch to a lazy stack if profiling your code shows a worthwhile performance improvement.

* 공식문서에서도 처음에는 표준 Stack을 통해 구현하면서 Profiling을 통해 성능을 확인해보다가 lazy Stack을 활용하였을 때 `유의미한 성능 개선이 발생된다면 사용하라고 권장`하고 있다.

---

**[GridItem]**

https://developer.apple.com/documentation/swiftui/griditem

* GridItem 인스턴스들은 LazyVGrid, LazyHGrid 뷰에서 그릴 아이템들의 레이아웃(간격, 정렬, 사이즈 등)을 설정하는 데에 사용된다.

```swift
.init(GridItem.Size, spacing: CGFloat?, alignment: Alignment?)
```

* Size에는 총 3가지 타입이 있다
    * adaprive
        * minimum 값 이상의 사이즈로 열마다 가능한 많은 아이템들을 배치하고자 할 때 사용되는 사이즈
    * flexible
        * minimum 값 이상의 사이즈로 column 수를 조절하고 싶을 때 사용되는 사이즈
        * adaptive와 유사하나 열마다 배치되는 아이템 수를 조절할 수 있다는 점에서 다르다.
    * fixed
        *  column 수와 크기를 직접 조절하고 싶을 때 사용하는 사이즈

```swift
// 위 Full Code에 ForEach를 LazyVGrid로 감싸서 그리드뷰를 구성
LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) { // 화면을 그리드 형식으로 최소사이즈 80
    // for문을 emojiCount만큼 반복하기
    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
        CardView(contant: emoji).aspectRatio(2/3, contentMode: .fit)
    }
}
```

> 얼추 완성된 카드게임

![](https://i.imgur.com/IriKYbE.gif)

---

- 참고링크
    - https://green1229.tistory.com/72
    - https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html
    - https://babbab2.tistory.com/59
    - https://ios-development.tistory.com/294
    - https://developer.apple.com/documentation/xcode/localization
