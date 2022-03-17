# 220315 Widget, Timeline, Decorator Pattern

# TIL (Today I Learned)

3월 17일 (목)

## 학습 내용

- Widget 활동학습
- Decorator 패턴

&nbsp;

## 고민한 점 / 해결 방법

**[Widget 활동학습]**

> 위젯 타겟을 추가하고, 생성된 파일의 Preview를 통해 구현된 위젯의 모습을 확인해 봅시다.

> ### 위젯을 구현하기 위한 Component 들에는 무엇이 있을까요?
https://developer.apple.com/documentation/swiftui/widget

![](https://i.imgur.com/pNvORjO.png)

* 위젯 타입 (Configuration)
    * StaticConfiguration
    * IntentConfiguration
* 업데이트 타이밍 정보 (TimelineProvider)
    * TimelineEntry
* 위젯의 뷰를 구성하는 SwiftUI (EntryView)

---

> ### 생성된 Widget 파일에 이미 정의되어있는 각 구성요소는 위젯에서 어떤 역할을 하고 있을까요? 

- `struct Provider: TimelineProvider`
  - 위젯의 내용(스냅샷, 타임라인)을 업데이트하는 주기(Timeline)을 제공하는 객체
- `struct SimpleEntry: TimelineEntry`
  - 위젯에 표시할 객체
- `struct MyWidgetEntryView : View`
  - SwiftUI 에서 화면을 구성하는 View 구조체
- `@main struct MyWidget: Widget`
  - 위젯을 구성하는 메인 구조체
- `struct MyWidget_Previews: PreviewProvider`
  - SwiftUI 프리뷰 구조체

> `EntryView를 조작해 어떤 변화가 있는지 살펴봅시다.`
> Provider 의 각 메서드는 어떤 역할을 할까요?

> ### placeholder, getSnapshot, getTimeline 메서드는 어떤 역할인가요?

- `func placeholder(in context: Context) -> SimpleEntry`
  - WidgetKit 이 처음 위젯을 렌더링할 때 사용한다.
- `func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ())`
  - 위젯 갤러리에서 위젯을 보여주기 위해, 스냅샷을 요청할 때 호출된다.
- `func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ())`
  - 위젯을 업데이트하는 타이밍(주기)와 policy 를 제공한다.

> ### Timeline의 policy를 변경하면 어떻게 될까요?

- `atEnd` : 주어진 Timeline 의 마지막 날짜(Date) 이후에 새로운 타임라인 요청하는 policy
- `after(date:)` : 마지막 날짜(Date) 이후 WidgetKit이 새 타임라인을 요청할 미래 날짜를 지정하는 policy
- `Never` : 누가 지시하기 전까지는 Timeline 을 요청하지 않는 policy
(WidgetKit은 앱이 WidgetCenter를 사용하여 WidgetKit에 새 타임라인을 요청하도록 지시 할 때 까지 다른 timeline을 요청하지 않는다)

> ### 위젯은 언제 업데이트될까요?

- getTimeline 메서드가 TimelineEntry를 제공하고, TimelineEntry에는 위젯의 콘텐츠를 언제 업데이트 할지에 대한 Date가 들어있다!
- WidgetKit은 그걸 보고 그 시간이 되면 그 때 나와야 할 view를 Widget에 전송한다.

> ### 위젯이 구성되는 방식을 순차적으로 설명해봅시다.

- TimelineEntry 가 보여줘야 하는 객체의 Model 및 날짜(Date 타입의 프로퍼티)를 갖고 있다.
- TimelineProvider
- EntryView
- Widget

---

**[Decorator Pattern]**

### Decorator 패턴이란?

![](https://i.imgur.com/1mNaHir.png)

* 기존 객체가 가진 동작들을 포함하는 특수 래퍼를 만들고, 새로운 기능을 추가할 수 있는 디자인 패턴
* 상속(Inheritance)과 합성(Composition)을 사용하여 객체에 동적으로 책임을 추가할 수 있게 하는 패턴
* 클래스의 코드를 전혀 바꾸지 않고도 객체에 새로운 임무를 부여하기 위해서 등장했다.
* 기존 객체를 감싸는 Wrapper를 만들고 해당 Wrapper 객체에 다른 기능들을 넣는 동작 때문에 Wrapper 패턴이라고도 한다.

### 언제 사용할까?
* 다른 객체들에 영향을 주지 않고 개별 객체에 기능들을 추가하고 싶을 때 사용한다.
* 추가한 기능들은 언제든 없앨 수 있다.
* 상속을 사용하여 기능을 확장하는 것이 힘들 경우에 사용한다.

### 구조

![](https://i.imgur.com/LhsZcVe.png)

`Component`
* 동적으로 추가된 기능을 가질 수 있는 객체에 대한 인터페이스를 정의한다.

`Concreate Component`
* Component 인터페이스의 기능을 실제로 구현한 객체
* 새로운 기능들이 추가될 수 있는 객체

`Decorator`
* Component 인터페이스를 따르는 객체를 참조할 수 있는 필드가 존재
* Component 인터페이스를 따르는 인터페이스를 정의

`Concreate Decorator`
* 구성 요소에 기능을 추가

`Client`
* Component 인터페이스를 통해 모든 객체와 함께 동작할 수 있게 해준다.

### 장점
* 상속을 통한 하위 클래스를 만들지 않고도 객체의 기능을 확장할 수 있다.
* 런타임에서 객체에 책임을 추가하고 제거할 수 있다.
* 객체를 여러 데코레이터로 래핑하여 여러 동작을 합칠 수 있다.
* 객체 지향 프로그래밍에서 중요한 단일 책임 원칙(OCP)을 지킬 수 있다.

### 단점
* 래퍼 스택에서 특정 래퍼를 제거하는 것이 어렵다.
* 데코레이터 기능이 데코레이터 스택 순서에 의존해야 한다.
* 코드가 복잡해질 수 있다.

### 코드 예제
```swift
// Component
protocol Juice {
    func cost() -> Int
}

// Concreate Component
class BananaJuice: Juice {
    func cost() -> Int {
        return 4000
    }
}

class OrangeJuice: Juice {
    func cost() -> Int {
        return 3800
    }
}

// Decorator
protocol JuiceDecorator: Juice {
    var wrappee: Juice { get set } // 객체를 참조할 wrappee를 정의
}

// Concreate Decorator
class StrawberryBanana: JuiceDecorator {
    var wrappee: Juice
    
    init(wrappee: Juice) {
        self.wrappee = wrappee
    }
    
    func cost() -> Int {
        return wrappee.cost() + 1500
    }
    
    func addHoney() { // 새로운 기능 추가
        print("딸바주스에 꿀 추가 해드렸슴다.")
    }
}

// Concreate Decorator
class KiwiBanana: JuiceDecorator {
    var wrappee: Juice
    
    init(wrappee: Juice) {
        self.wrappee = wrappee
    }
    
    func cost() -> Int {
        return wrappee.cost() + 1000
    }
    
    func addIce() { // 새로운 기능 추가
        print("키위주스에 얼음추가 해드렸슴다. 시원하게드세여~")
    }
}

// Concreate Decorator
class Absolute: JuiceDecorator {
    var wrappee: Juice
    
    init(wrappee: Juice) {
        self.wrappee = wrappee
    }
    
    func cost() -> Int {
        return wrappee.cost() + 8000
    }
    
    // 새로운 기능 추가
    func moreJuice() {
        print("주스를 더 많이 넣어드렸어여~")
    }
    
    func moreDrink() {
        print("술 더많이 타드렸어여~")
    }
}

let strawberryBananaJuice = StrawberryBanana(wrappee: BananaJuice())
print(strawberryBananaJuice.cost()) // 5500
strawberryBananaJuice.addHoney() // 딸바주스에 꿀 추가 해드렸슴다.

let kiwiBananaJuice = KiwiBanana(wrappee: BananaJuice())
print(kiwiBananaJuice.cost()) // 5000
kiwiBananaJuice.addIce() // 키위주스에 얼음추가 해드렸슴다. 시원하게드세여~

let screwDriver = Absolute(wrappee: OrangeJuice())
print(screwDriver.cost()) // 11800
screwDriver.moreJuice() // 주스를 더 많이 넣어드렸어여~

```

---

- 참고링크
    - https://refactoring.guru/design-patterns/decorator
    - https://icksw.tistory.com/244

