# 240819 SwiftUI Property Wrapper

SwiftUI의 프로퍼티 래퍼 종류 대해서 간단히 알아보자.

8월 19일 (월)

# 학습내용

회사 프로젝트 내 일부 화면을 SwiftUI와 Combine을 사용하여 리팩토링을 진행해보았는데, 사용한 프로퍼티 래퍼에 대한 이해도가 부족한 것 같아서 알아보았다.

## Property Wrapper

SwiftUI에서 프로퍼티 래퍼는 상태 관리를 쉽게 하고 뷰와 데이터 간의 상호작용을 간단하게 할 수 있도록 도와준다.

### `@State`

`@State`는 SwiftUI에서 로컬 뷰 상태를 관리하기 위해 사용된다. `@State`로 선언된 변수는 변경될 때 마다 해당 변수를 사용하는 뷰가 다시 렌더링된다.

* 언제 사용해야 할까?
  * 뷰 내부에서만 사용하는 간단한 상태를 관리할 때 사용한다. 예를 들어, 버튼의 활성화 상태, 토글 상태, 텍스트 필드의 입력 값 등을 관리할 때 적합하다.
  * 부모뷰나 외부에서 접근할 필요가 없으며 뷰가 다시 렌더링될 때마다 필요에 따라 업데이트 하게 된다.

`@State`는 뷰가 소멸되면 상태도 함께 사라지므로 뷰의 생명 주기와 함께 상태가 초기화된다. 따라서 장기적인 상태 저장이 필요한 경우에는 @AppStorage, @SceneStorage를 고려해야 한다.

### `@Binding`

`@Binding`은 부모뷰에서 관리하는 상태를 자식뷰로 전달하여 자식뷰에서 상태를 수정할 수 있게 해준다. `@Binding`을 사용하면 자식뷰가 부모뷰의 상태를 직접 수정할 수 있어 뷰 간 상태 동기화가 가능하다.

* 언제 사용해야 할까?
  * 부모뷰에서 정의된 상태를 자식뷰에서 참조하고 수정할 필요가 있을 때 사용한다.
  * 예를 들어 부모뷰에서 관리하는 텍스트 필드의 값을 자식뷰에서 편집할 수 있도록 해야할 때 적합하다.

`@Binding`을 통해 자식뷰가 상태를 수정할 수 있지만, 부모뷰의 상태가 예상치 않게 변경될 수 있으므로 신중하게 관리해야 한다.
간단한 상황에서는 `@State`만으로 충분할 수 있으며, 너무 빈번하게 `@Binding`을 사용하면 코드가 복잡해질 수 있으니 주의해야 한다.



```swift
// 하위뷰와 상태 공유 예시
struct PlayerView: View {
    var episode: Episode
    @State private var isPlaying: Bool = false // Create the state here now.


    var body: some View {
        VStack {
            Text(episode.title)
                .foregroundStyle(isPlaying ? .primary : .secondary)
            PlayButton(isPlaying: $isPlaying) // Pass a binding.
        }
    }
}

struct PlayButton: View {
    @Binding var isPlaying: Bool // Play button now receives a binding.


    var body: some View {
        Button(isPlaying ? "Pause" : "Play") {
            isPlaying.toggle()
        }
    }
}
```

### `@ObservedObject`

`@ObservedObject`는 `ObservableObject` 프로토콜을 준수하는 객체를 관찰하고, 해당 객체의 상태가 변경될 때마다 뷰를 자동으로 업데이트 한다.
주로 뷰 모델 패턴에서 사용되며, 뷰와 데이터 로직을 분리한다.

* 언제 사용해야 할까?
  * 뷰와 데이터 로직을 분리하고 여러 뷰에서 공유되는 상태를 관리할 때 사용한다.
  * 예를 들어 네트워크 요청의 결과를 저장하고 관리하는 뷰 모델을 뷰에서 참조할 때 `@ObservedObject`를 사용한다.
  * 데이터 모델이나 서비스 객체의 상태 변화를 뷰에서 감지하고 자동으로 UI를 업데이트해야 할 때 사용된다.
  
`@ObservedObject`는 뷰가 강한 참조를 가지지 않으므로 뷰가 소멸되더라도 객체가 해제되지 않는 메모리 누수에 주의해야 한다. `@ObservedObject`로 사용된 객체는 다른 곳에서 강하게 참조되어야 한다. 
데이터가 자주 변경되는 경우 적절한 동기화 없이 여러 뷰에서 동시에 상태가 업데이트되면 충돌이 발생할 수 있다.

`@ObservedObject`는 `@State`와 다르게 클래스 타입에서 사용된다.

```swift
class DataModel: ObservableObject {
    @Published var name = "Some Name"
    @Published var isEnabled = false
}


struct MyView: View {
    @StateObject private var model = DataModel()


    var body: some View {
        Text(model.name)
        MySubView(model: model)
    }
}


struct MySubView: View {
    @ObservedObject var model: DataModel


    var body: some View {
        Toggle("Enabled", isOn: $model.isEnabled)
    }
}
```

### `@Published`

`@Published`는 `ObservableObject` 프로토콜을 따르는 클래스 내에서 특정 프로퍼티가 변경되었을 때 해당 변경을 알리고 이를 관찰하고 있는 뷰가 자동으로 업데이트될 수 있도록 해준다.

* 언제 사용해야 할까?
  * 뷰 모델 패턴에서 `@ObservedObject`와 함께 사용하여 뷰가 데이터 모델의 특정 프로퍼티 변경에 반응하도록 할 때 사용한다.
  * 예를 들어 네트워크 응답이나 사용자 입력에 따라 동적으로 변하는 데이터를 관리할 때 유용하다.

`@Published`로 선언된 프로퍼티는 항상 뷰를 업데이트 하므로 빈번한 변경이 발생하는 경우 불필요한 뷰 업데이트가 발생할 수 있다. 따라서 성능 문제가 발생할 수 있으므로 꼭 필요한 경우에만 `@Published`를 사용해야 한다.
또한 `@Published`는 클래스 타입의 프로퍼티에만 사용되며 값타입에서는 사용할 수 없다.

### `@StateObject`

`@StateObject`는 SwiftUI에서 상태 객체(ObservableObject)를 관리하는 데 사용되는 프로퍼티 래퍼다. `@StateObject`는 특정 뷰의 생명 주기 동안 객체의 상태를 유지하고, 이 객체의 상태가 변경되면 뷰를 다시 렌더링한다. `@StateObject`는 뷰가 처음 초기화될 때 한 번만 객체를 생성하며, 뷰가 다시 생성될 때도 동일한 객체 인스턴스를 사용한다.

* 언제 사용해야 할까?
  *  뷰가 상태 객체의 생명 주기를 소유하고 관리해야 할 때 `@StateObject`를 사용한다. 
  *  예를 들어, 뷰가 특정 데이터 모델의 상태를 직접 관리해야 하거나, 뷰가 소멸될 때 상태 객체도 함께 소멸되어야 하는 경우에 적합하다.
  
`@StateObject`는 뷰의 초기화 시점에 한 번만 객체를 생성하므로, `@StateObject`로 선언된 객체는 뷰의 구조가 변경되어도 동일한 인스턴스가 유지된다. 만약 뷰 계층의 다른 곳에서 동일한 객체를 참조하려고 하면, `@ObservedObject`를 사용해야 한다.

같은 상태 객체를 여러 뷰에서 관리해야 할 때는 `@StateObject`와 `@ObservedObject`를 혼용하지 않도록 주의해야 한다. 객체의 생명 주기와 메모리 관리에 혼란을 초래할 수 있다.

`@StateObject`는 SwiftUI 2.0에서 도입되었으며, 뷰가 객체의 생명 주기를 책임져야 하는 상황에서 매우 유용하다. 특히 뷰가 상태 객체를 처음부터 소유하고 관리해야 하는 복잡한 애플리케이션에서 중요한 역할을 하게 된다.

`@StateObject`는 일반적으로 뷰가 처음 생성될 때 사용하는 것이 좋으며, 이미 생성된 상태 객체를 다른 뷰에서 사용할 때는 `@ObservedObject`를 사용한다.

>`@StateObject`는 `@ObservedObject`와 비슷해 보이지만, 중요한 차이점은 객체의 생명 주기와 초기화 방식에 있다. 
>`@StateObject`는 뷰가 상태 객체를 소유하고 관리하는 데 초점을 맞추며, 특정 뷰의 생명 주기 동안 상태 객체가 유지되도록 보장한다.

### `@EnvironmentObject`

`@EnvironmentObject`는 `ObservableObject` 프로토콜을 따르는 객체를 뷰 계층 구조 전반에 걸쳐 공유하는 데 사용된다. SwiftUI에서 환경에 의해 주입된 객체는 `@EnvironmentObject`로 참조할 수 있으며, 이를 통해 앱의 여러 부분에서 공통된 상태를 사용할 수 있다.

* 언제 사용해야 할까?
  * 앱의 여러 부분에서 공통된 상태를 공유하고 관리해야 할 때 사용한다.
  * 예를 들어 사용자 인증 상태, 전역 설정, 공통 데이터 소스 등을 `@EnvironmentObject`로 관리할 수 있다.
  * 계층이 깊은 뷰 구조에서 상위뷰에서 하위뷰로 상태를 계속 전달하는 대신 `@EnvironmentObject`를 사용해 간편하게 상태를 전달할 수 있다.

`@EnvironmentObject`는 뷰 계층의 상위에서 주입되어야 한다. 만약 해당 객체가 주입되지 않은 하위뷰에서 이를 사용하려고 하면, 런타임 에러가 발생할 수 있다.
또한 객체가 필요한 뷰들에 명시적으로 주입되도록 신경써야 하며, 명시적으로 선언되지 않은 `@EnvironmentObject`는 뷰에서 의도치 않게 동작할 수 있다.

### `@Environment`

`@Environment`는 시스템에서 제공하는 다양한 값들을 뷰에서 접근할 수 있게 해주는 프로퍼티 래퍼다. 예를 들어 색상 테마, 사용자의 접근성 설정, 레이아웃 방향 등을 `@Environment`를 통해 가져올 수 있다.

* 언제 사용해야 할까?
  * 사용자의 시스템 설정에 따라 UI 동작이나 스타일을 변경해야 할 때 사용된다.
  * 예를 들어 다크모드와 라이트 모드에 따라 색상을 조정하거나 접근성 설정에 따라 텍스트 크기를 변경해야 할 때 유용하다.

`@Environment`를 사용하여 시스템 환경에 의존하는 UI를 만들 때는 해당 값이 항상 예상대로 제공되는지 확인이 필요하다. 예를 들어 특정 환경 값은 테스트나 특정 상황에서 다르게 설정될 수 있다.

또한 너무 많은 `@Environment` 값을 사용하면 코드가 복잡해지고 관리가 어려워질 수 있어 과도한 사용은 피해야한다.

```swift
@Environment(\.colorScheme) var colorScheme: ColorScheme

if colorScheme == .dark { // Checks the wrapped value.
    DarkContent()
} else {
    LightContent()
}
```

### `@AppStorage`

`@AppStorage`는 iOS의 UserDefaults를 사용하여 값을 저장하고, 이 값을 자동으로 관리하는 프로퍼티 래퍼다. 이 래퍼는 간단한 값을 앱 전역에서 지속적으로 유지하고, 앱이 재시작되더라도 그 값을 유지할 수 있게 해준다.

* 언제 사용해야 할까?
  * 사용자가 설정한 간단한 값을 저장하고, 앱이 다시 시작되었을 때도 해당 값을 유지하고 싶을 때 사용한다. 
  * 예를 들어, 사용자 테마 설정, 로그인 상태, 또는 언어 설정을 `@AppStorage`를 통해 관리할 수 있다.

`@AppStorage`는 UserDefaults에 데이터를 저장하므로, 너무 많은 데이터나 복잡한 객체를 저장하는 데 적합하지 않다. 큰 데이터나 복잡한 구조를 저장할 경우 다른 영속성 메커니즘을 고려해야 한다.

또한 `@AppStorage`는 기본 데이터 타입만 지원한다. 복잡한 데이터 구조나 사용자 정의 객체는 Codable을 사용하여 직접 직렬화/역직렬화 해야 한다.

### `@SceneStorage`

`@SceneStorage`는 특정 뷰나 장면(Scene)의 상태를 자동으로 저장하고 복원할 수 있는 프로퍼티 래퍼다. 이는 iOS에서 앱이 여러 장면을 가질 수 있게 되었을 때 도입된 개념으로, 각 장면에 국한된 상태를 유지하는 데 유용하다.

* 언제 사용해야 할까?
  * 사용자가 특정 화면에서 입력하던 데이터를 유지하거나, 장면이 다시 활성화되었을 때 이전 상태를 복원해야 하는 경우에 사용된다. 
  * 예를 들어, 입력하던 텍스트 필드의 값을 저장하고, 장면이 다시 활성화되었을 때 이를 복원할 수 있다.

`@SceneStorage`는 장면(Scene)이 소멸되면 해당 상태도 사라질 수 있다. 장기적인 상태 저장이 필요한 경우에는 다른 프로퍼티 래퍼를 고려해야 한다.
만약 앱이 예기치 않게 종료되거나, 장면이 완전히 제거되면 `@SceneStorage`에 저장된 데이터가 손실될 수 있다.

---


# 참고 링크


- [https://developer.apple.com/documentation/swiftui/state](https://developer.apple.com/documentation/swiftui/state)
- [https://developer.apple.com/documentation/swiftui/binding](https://developer.apple.com/documentation/swiftui/binding)
- [https://developer.apple.com/documentation/swiftui/observedobject](https://developer.apple.com/documentation/swiftui/observedobject)
- [https://developer.apple.com/documentation/combine/published](https://developer.apple.com/documentation/combine/published)
- [https://developer.apple.com/documentation/swiftui/stateobject](https://developer.apple.com/documentation/swiftui/stateobject)
- [https://developer.apple.com/documentation/swiftui/environmentobject](https://developer.apple.com/documentation/swiftui/environmentobject)
- [https://developer.apple.com/documentation/swiftui/environment](https://developer.apple.com/documentation/swiftui/environment)
- [https://developer.apple.com/documentation/swiftui/appstorage](https://developer.apple.com/documentation/swiftui/appstorage)
- [https://developer.apple.com/documentation/swiftui/scenestorage](https://developer.apple.com/documentation/swiftui/scenestorage)