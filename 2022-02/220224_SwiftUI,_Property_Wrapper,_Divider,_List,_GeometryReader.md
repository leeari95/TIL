# 220224 SwiftUI, Property Wrapper, Divider, List, GeometryReader
# TIL (Today I Learned)

2월 24일 (목)

## 학습 내용

- SwiftUI
    - Divider
    - List
    - Property Wrapper
    - GeometryReader

&nbsp;

## 고민한 점 / 해결 방법

**[SwiftUI]**

> `애플에서 소개하는 SwiftUI`
> SwiftUl은 모든 Apple의 사용자 인터페이스를 선언하는 현대적인 방법입니다.
연단 아름답고 역동적인 앱을 그 어느 때보다도 빠르게 만들 수 있습니다.

* 'UIKit - MVC' 구조는 event driven 방식인데, 'SwiftUI - MVVM' 구조는 data driven 방식이다.

> 왜 구조체로 정의했을까? 얻을 수 있는 이점은 무엇이 있을까?

* 뷰 사이에 retain cycle이 없다.
* SwiftUI는 특정 값이 변할 때 뷰를 다시 갱신해준다.
* 즉, 뷰를 다시 그려준다는 것인데, 새로 그려주는 과정 속에서 구조체로 그려준다면 비용이 저렴하다는 장점이 있다.
    * 이 말은 Heap에 갔다올 필요가 없어진다!

> Data Drive을 도와주는 친구, Property Wrapper

* `@State`
* `@ObservableObject`
* `@ObservedObject`
* `@Publushed`
* `@EnvironmentObject`
* `@StateObject`

---

**[SwfitUI - Property Wrapper]**
### `ObservableObject`
* 필수 구현을 필요로 하지 않는 프로토콜
* `Combine`에 속한 기능이고 `클래스`에서만 사용 가능하다.
* 이 프로토콜을 준수한 클래스는 `objectWillChange`라는 프로퍼티를 사용할 수 있다.
    * objectWillChange.send()를 이용하기 위함이다
    * 이 send()는 변경된 사항이 있다고 알려주는 기능을 한다.
* 그러나 변수도 많고 수정되는 부분이 복잡하다면 하나하나 신경쓰기 힘들어지는데, 이를 대신해주는 기능이 `@Published` 프로퍼티 래퍼가 있다.

### `@`Published
* 해당 변수가 변경되면 자동으로 `objectWillChange.send()`를 호출해준다.

### `@State`
* UIKit에선 Property Observer를 통해서 변화가 일어나면 뷰를 업데이트 시키는 방식을 사용했지만 SwiftUI는 `@State`라는 프로퍼티 래퍼를 통해서 같은일을 한다.
* @State로 선언된 변수의 값이 변할 때 View를 다시 계산해서 그려준다.
* 단 View의 body에서만 @State 변수에 접근해야한다.
    * 즉 private 선언이 따라오는 것을 권장한다.
    * 외부에서 이 변수에 접근하면 안된다.
* 경고문, 텍스트필드, 편집모드 같이 현재 화면의 상태를 잠깐 나타내거나 간단한 View의 상태를 나타낼 변수를 선언하는데 적합하다.

> View는 구조체 타입이다. 그리고 화면에 보여지는 실질적인 뷰인 body 변수가 get-only라는 점 때문에 View의 내용을 수정할 수 없다. 그럼 View의 상태를 어떻게 변경해서 보여줄까?
구조체 타입이라서 참조를 가지고 있지 않기 때문에 변경사항을 적용해서 그려줄 때 원래 View에 추가하는 방식이 아니라 View를 새로 그려주는 방식을 취한다. 새로 그려주는데 복사를 해서 수정하려해도 변경을 해야하는데... body는 읽기전용이다. 이때 @State를 사용하면 된다. 

> @State 변수는 Heap에 할당된다. View에는 포인터만 있고 새로운 View가 만들어지면 포인터를 새로운 View에 옮겨서 힙의 같은 메모리를 가르킨다면 데이터도 같을 것이다. 이런식으로 View의 상태를 저장하고 변경한다.

### `@Binding`
* @State의 변수에 `$` 달러표시를 붙여서 사용할 수 있는데, 프로퍼티 래퍼에 `$`를 붙이면 `projectValue`라고도 한다.
* `$` 달러표시를 붙이면 `Binding` 타입의 변수가 나타나는 것을 볼 수 있다.
* 부모 View의 @State와 같은 값을 `양방향`으로 연결되도록 해준다.

```swift
struct TestView: View {
    @State private var name: String = "parent"
    var body: some View {
        ChildView(childName: $name) Text(name)
    }
}

struct ChildView: View {
    @Binding var childName: String
    var body: some View {
        Button("Change Name") {
            childName = "child"
        }
    }
}
```

* 위 코드에서 TestView가 ChildView를 포함하고 있다.
* 여기서 현재 TestView의 name은 parent이다.
* ChildView의 childName도 같다.
* 이때 ChildeView의 Button을 누르게 된다면?
    * TestView, ChildView의 name 모두 child로 변경된다.
* 이렇듯 State의 `$` 달러표시는 다른 변수에 `연결`을 해주는 역할을 한다.
* 즉, Binding은 다른 어딘가에 연결되어있는 값이고, 해당 값이 변경되면 연결된 모든 값들이 변경된다. 
* 데이터에 대한 단일 소스를 갖는 형태이다. 같은 데이터를 가지고 있다면 한쪽에서 수정되면 당연히 같이 수정이 일어나야한다.


### `@ObservedObject`
* 대부분 `ViewModel`을 선언할 때 사용하는 프로퍼티 래퍼이다.
* `ObservableObject` 프로토콜을 준수하는 타입에 사용할 수 있다.
* ViewModel에서 변경사항이 있다면 뷰를 다시 그릴 수 있도록 해주는 역할을 한다.

### `@StateObject`
* ObservedObject와 같은 역할을 한다. 단점을 보완해서 iOS14에서 추가된 기능이다.
* State + ObservedObject 느낌이다.
* 차이점으로는 ObservedObject는 View가 새로 그려질 때 새로 생성될 수 있다.
    * `View Life Cycle에 의존한다.`
* 그러나 StateObject는 View가 새로 그려질 때 State처럼 새로 그려지지 않고 참조를 가지고 있어서 새로 생성되지 않는다.
    * `View Life Cycle에 의존하지 않는다.`
* 즉 새로 생성된다 라는 차이가 있다.
    * `데이터가 유실될 수 있는 문제점`
    * `ViewModel이 생성될 때 작업이 많다면 비효율적인 성능`
* 위 두가지를 개선한 것이 StateObject라고 보면 된다.
* 약간.. 모델이 계속 살아있을 수 있도록 하는... 싱글턴 패턴의 느낌인 것 같다.

### `@EnvironmentObject`
* 보통 앱 전반에 걸쳐 공유되는 데이터에 사용된다.
* `.environmentObject(_:)`를 통해 값을 전달할 수 있다.
* 전달하는 object는 ObservableObject 프로토콜을 준수해야 한다.
* 모든 View가 읽을 수 있는 shared data라고 보면 될 것 같다.

---

**[SwiftUI - Divider]**

https://developer.apple.com/documentation/swiftui/divider

Divider는 하나의 콘텐츠와 다른 콘텐츠를 구분하는 뷰이다.
구분선 같은 느낌...?
간단하게 선언만 해서 사용해주면 된다.

![](https://i.imgur.com/iDWkwfm.png)

![](https://i.imgur.com/LvPUdIZ.png)

* 위 사진을 보면 제목과 내용에 따라 구분선이 쭈욱.. 그어져있는 모습을 확인할 수 있다.

---

**[SwiftUI - List]**

https://developer.apple.com/documentation/swiftui/list

이름 그대로 목록 인터페이스를 구현하기 위한 타입이다.
`UITableView`와 하는 일이 상당히 비슷하다. 하지만 훨씬 간편하다.

```swift
List {  // 리스트 목록을 동적으로 만들기
        Toggle(isOn: $showFavoritesOnly) {
            Text("Favorites only")
        }
        ForEach(fillteredLandmarks) { landmark in
            NavigationLink {
                LandmarkDetail(landmark: landmark)
            } label: {
                LandmarkRow(landmark: landmark)
            }
        }
    }
```
* 위 코드에서는 List 내부에 `ForEach`를 활용하여 동적으로 리스트를 구성하고 있다.
* `landmark`라는 타입을 이니셜라이저로 할당해주고, 터치시 `Detail`로 넘어가고, 셀의 View는` LandmarkRow`라는 타입으로 설정해주고 있다.
    * `Toggle`의 경우 `@State private var showFavoritesOnly = false` 프로퍼티를 설정해주고 있다.

![](https://i.imgur.com/UBza4Sw.png)

```swift
struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable() //이미지 사이즈를 다시 설정
                .frame(width: 50, height: 50) // 높이 50 너비 50
            Text(landmark.name)
            Spacer() // 맨 뒤에 스페이서 추가하여 행을 완성
            if landmark.isFavorite { // 즐겨찾기 기능
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}
```
* `LandmarkRow`의 경우 `HStack` 안에 `Image`와 `Text`를 활용하여 셀 구성을 하고 있다.

---

**[GeometryReader란 무엇인가?]**

https://developer.apple.com/tutorials/swiftui/drawing-paths-and-shapes
> SwiftUI의 튜토리얼을 따라하다가 발견한 키워드. 이게 뭐하는 놈인지 도대체가 모르겠어서 한번 찾아보았다.

SwiftUI에선 Uikit으로 레이아웃을 작성할 때와 달리 뷰 객체에 직접 접근할 수 없다.
뷰 객체에 직접 접근해 뷰 정보(size, position 등)에 알 수 있었던 것과 달리 SwiftUI에서 뷰 객체는 일시적인(transient) 객체로 프레임워크가 뷰를 그리고 난 후 객체는 사라지기 때문에 UiKit과 같은 방식으론 뷰에 관한 정보를 알 수 없다.

그렇다고 모든 뷰에 `.frame(width:. height:)` 변경자를 사용해 직접 고정값을 넣어 하드코딩할 수도 없는 일이다. 이를 위해 등장한 개념이 GeometryReader로 상위뷰의 Geometry 정보를 하위뷰에 제공하는 역할을 한다.

* Size와 Position을 사용하여 Child View의 레이아웃을 설정할 수 있다.
* Content를 자신의 size 및 coordinate 공간의 함수로 정의하는 container view (이게 뭔말이여...)

> 앱의 다른 위치 또는 다른 크기의 디스플레이에서 view를 재사용할 때 올바르지 않을 수 있는 하드 코딩 번호 대신 GeometryReader를 사용하여 view를 동적으로 그리거나 position를 지정하고 size를 조정할 수 있다.
GeometryReader는 parent view와 장치에 대한 크기 및 위치 정보를 동적으로 reports하며 size가 변경될 때마다 업데이트 된다
(예: 사용자가 iPhone을 회전할 때).


---

## 느낀 점

* SwiftUI는 다 좋은데, 공식문서에서 설명해주는 개념들이 미완성된 모호한 정의를 내리고 있는게 있어서.. 헷갈리다.
* 구글링도 몇개 안나오는 듯한 느낌이다.
    * 코딩하다 문제가 생겼을 때 진짜 삽질해야될 것만 같은 느낌적인 느낌...
* Preview는 잡다한 버그가 많다.
* 그외에는 정말 뷰그리는 건 신세계 👍🏻

---

- 참고링크
    - https://nsios.tistory.com/145?category=922970
    - https://stackoverflow.com/questions/62544115/what-is-the-difference-between-observedobject-and-stateobject-in-swiftui
    - https://jaesung0o0.medium.com/swiftui-data-flow-stateobject-vs-observedobject-e32a37d80dd2
    - https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app
    - https://www.hackingwithswift.com/quick-start/swiftui/whats-the-difference-between-observedobject-state-and-environmentobject
    - https://www.hohyeonmoon.com/blog/swiftui-data-flow/
    - https://www.hohyeonmoon.com/blog/swiftui-data-flow/
    - https://velog.io/@sjoonb/SwiftUI-GeometryReader
    - https://protocorn93.github.io/2020/07/26/GeometryReader-in-SwiftUI/
