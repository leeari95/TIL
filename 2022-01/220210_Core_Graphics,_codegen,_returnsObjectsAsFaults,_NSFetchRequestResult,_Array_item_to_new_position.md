# 220210 Core Graphics, codegen, returnsObjectsAsFaults, NSFetchRequestResult, Array item to new position. 
# TIL (Today I Learned)

2월 10일 (목)

## 학습 내용
- Core Graphics
    - 활동학습
- Core Data: `codegen`이 뭔데...?
- NSFetchRequest - returnsObjectsAsFaults
- Protocol - NSFetchRequestResult
- 동기화 메모장 프로젝트 문제해결
    - Array - extension (`move(from:to:)`)

&nbsp;

## 고민한 점 / 해결 방법

**[Core Graphics]**

https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007533-SW1

* Quartz 2D
    * iOS나 Mac OSX 어플리케이션 환경에서 접근할 수 있는 Drawing Engine으로써 2차원 그래픽을 그릴 때 사용된다.
    * Quartz 2D API를 통해서 좌표를 기준으로 그래픽 그리기, 투명도 조절, 그림자, 명암, 레이어의 투명도 등의 그래픽 특징을 조절할 수 있다.
    * Quartz 2D가 사용될 때는 언제든 그래픽 하드웨어의 도움을 받게 된다.
    * 2차원의 어떤 것들을 그리기 위한 엔진
    * iOS, tvOS, macOS의 2차원 그림을 그리는 개발도구엔진
    * Mac OS X에서 Quartz 2D는 다른 모든 그래픽 및 이미징 기술(Core Image, Core Video, OpenGL 및 QuickTime)과 함께 이용할 수 있다.
    * iOS에서 Quartz 2D는 Core Animation, OpenGL ES 및 UIKit 클래스와 같은 사용 가능한 모든 그래픽 및 애니메이션 기술과 함께 이용할 수 있다.
* Page
    * Quartz 2D는 이미지를 그리는데 painter's model을 사용한다.
    * painter's model에서 성공적으로 완성된 그리기 작업은 하나의 paint레이어를 Page라 불리는 출력용 캔버스에 적용시킨다.
    * 페이지 위에 paint는 다른 그리기 작업을 시행하여 그위에 다른 paint를 overlaying하는 방식으로 수정할 수 있다.
    * 한번 그려진 페인트는 이처럼 페인트를 오버레이어하는 방식 이외에는 수정할 방법이 없다.
    * 아래 그림은 두가지 다른 형태의 그림을 그릴 때 순서의 중요성에 대해 알 수 있는 그림이다.
    * 앞서 그린 것이 깔리게되고, 그 뒤에 그린 것이 겹쳐지게 되는 것을 설명한다.
    * ![](https://i.imgur.com/5xX9tAK.gif)
* Graphics Context
    * opaque data type
    * [CGContextRef](https://developer.apple.com/documentation/coregraphics/cgcontextref)는 이미지를 그리는데 사용하는 정보를 캡슐화한 불투명한 데이터 타입이다.
    * Quartz를 통하여 그려진 모든 이미지는 output device 즉 PDF, bitmap, window display에 사용되기 위하여 그려진다.
    * 어떤 디바이스든 사용할 수 있도록 캡슐화된 형태로 생각하면 될 것 같다.
    * ![](https://i.imgur.com/KvpeEAa.gif)
* 따라서 Quartz가 알아서 디바이스 환경에 따라서 만들어 줄 것이다.
* 위 그림처럼 drawing destination에 따라 여러가지 형태의 graphics context로 나타내질 수 있다.
* graphics context는 bitmap graphics context, PDF graphics context, window graphics context 등 여러가지 종류가 있다.
* 그 중 iOS는 View graphics context를 사용한다.

**[Quartz 2D Coordinate Systems]**

* Quartz는 그래픽을 생성할 때 고유의 coordinate system, 즉 좌표계를 통해 위치와 사이즈를 나타낸다.
* ![](https://i.imgur.com/Be2uB1E.gif) 
* Quartz의 좌표는 좌측 아래가 0.0이다.
* 그래픽을 출력하게되는 기기마다 디스플레이의 크기가 다르기 때문에 그래픽의 좌표를 디바이스 단에서 설정하게되면 기기마다 다르게 설정해줘야하는 번거로움이 있다.
* 때문에 Quartz는 그래픽을 디바이스와 독립된 user space에 좌표계를 생성하고 각 기기의 device space 좌표로 current transformation matrix나 CTM을 통하여 맵핑을 시킨다.
* current transformation matrix라는 일종의 좌표를 이동(평행이동, 회전 등)시킬 수 있는 행렬을 좌표에 곱하여 기존의 좌표를 이동시킨다.
* 따라서 그려질 좌표는 인식하되 실질적으로 그려지기 전에 기존의 Quartz 좌표계에 보이는 이미지를 그리는 것이 아닌 각 디바이스에 그려질 이미지로 변환하여 그려지게 된다.
* UIKit도 고유의 좌표계를 가지기 때문에 마찬가지로 Quartz의 좌표계에 그려질 그래픽을 UiKit 좌표계에 맞게 변형시킨 drawing contexts인 UIView를 활용하게 된다.
* ![](https://i.imgur.com/33HbCPg.jpg)
* 위 그래프와 같이 UiKit을 통하여 그려질 때는 Quartz 좌표계에서 y축의 양의 방향이 반대로 되어 좌표를 인식하게 된다.

> 이외에도 문서에는 Quartz의 graphics context에 따라 사용되는 Opaque Data Types, Quartz의 메모리 관리 방식, Quartz를 통해 완성된 객체를 수정할 수 있는 Graphics States에 관한 설명이 있다.

---

**[UIGraphicsGetCurrentContext]**

* `UIGraphicsGetCurrentContext`를 이용해서 View 위에 원을 그려보자~
    * 타입에 `@IBDesignable` 옵션을 준 후 원하는 속성(선 굵기, 컬러 등)에 `@IBInspectable` 속성을 붙여주어 스토리보드를 적극 활용하면 해당지식을 입문하기 좋은 것 같다.
> 먼저 UIView를 상속하는 커스텀 뷰를 생성해서 draw 메소드를 오버라이드 한다. 아래 예제는 UIButton을 Custom 타입으로 생성하였다.
```swift
override func draw(_ rect: CGRect) {

}
```
> 그리고 context 인스턴스를 생성해준다.
```swift
override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
        return
    }
}
```
> [beginPath](https://developer.apple.com/documentation/coregraphics/cgcontext/1456635-beginpath) 메소드를 호출해서 새 경로를 추가해주자.
```swift
override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
        return
    }
    context.beginPath() // 나 그림 그릴거야~~ 알려주기
}
```
> 먼저 원 형태의 도형을 그려볼 것이다. 그 전에 원의 Rect를 정의해보자.
> UIButton을 꽉 채우도록 bounds를 활용하여 설정해주었다. [insetBy(dx:dy:)](https://developer.apple.com/documentation/coregraphics/cgrect/1454218-insetby)
```swift
let width = bounds.width
let height = bounds.height

let circleRect = bounds.insetBy(dx: width * 0.05, dy: height * 0.05) // 좌표를 지정하면 CFRect을 반환한다.
```
> 선의 너비와, 채워줄 색상을 설정한다. [setLineWidth(_:)](https://developer.apple.com/documentation/coregraphics/cgcontext/1455270-setlinewidth) [setFillColor(_:)](https://developer.apple.com/documentation/coregraphics/cgcontext/1454079-setfillcolor)
```swift
override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
        return
    }
    context.beginPath() // 나 그림 그릴거야~~ 알려주기
    context.setLineWidth(lineWidth) // 선 굵기 지정
    context.setFillColor(fillColor.cgColor)
    // @IBInspectable var fillColor: UIColor = .systemBackground
}
```
> 그리고 아까 정의해두었던 CGRect를 활용하여 원을 그려준다. [addEllipse(in:)](https://developer.apple.com/documentation/coregraphics/cgcontext/1456420-addellipse)
```swift
override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
        ...
        
    context.addEllipse(in: circleRect)
```
> 원 그리기 완성!
![](https://i.imgur.com/R2S3Ydm.png)
* CGContext 공식문서를 보면 그림 그리기 위한 많은 메소드가 존재한다.
    * https://developer.apple.com/documentation/coregraphics/cgcontext

---

**[Codegen]**

https://developer.apple.com/documentation/coredata/modeling_data/generating_code

> 프로젝트 하는 도중에 codegen을 어떤 옵션으로 줘야할지 감이 안와서 찾아보았다.

* 해당 entity에 대한 클래스 선언을 자동으로 만들어 주는 옵션을 설정합니다.
    * None/Manual: 관련 파일을 자동으로 만들어주지 않는다. 개발자는 DataModel을 선택한 상태에서 Editor-Create NSManagedObject Subclass 항목을 클릭하여 클래스 선언 파일과 프로퍼티 extension 파일을 빌드시마다 추가시켜 주고, 이를 수동으로 관리해야 한다.
    * Class Definition: 클래스 선언 파일과 프로퍼티 관련 extension 파일을 빌드시마다 자동으로 추가시켜준다. 따라서 관련된 파일을 전혀 추가시켜줄 필요가 없다.(그래서도 안된다. 만약 수동으로 추가시켜준 상태에서 빌드를 시도하면 컴파일 에러가 발생한다.)
    * Category/Extension: 프로퍼티 관련 extension파일만 자동으로 추가시켜 준다. 즉, 클래스 선언에는 사용자가 원하는 로직을 자유롭게 추가할 수 있다.

**[NSFetchRequest - returnsObjectsAsFaults]**

https://developer.apple.com/documentation/coredata/nsfetchrequest/1506756-returnsobjectsasfaults

* CoreData을 관리하는 모델을 설계하다가 이런 프로퍼티를 발견하게 되었다.
* 기본값은 true인 속성이다.
* true인 경우 Request로 가져온 객체가 Faulting인 경우라고 한다.
    * https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/FaultingandUniquing.html

>Faulting 예시
![](https://i.imgur.com/ZbWKJo1.png)
* 사진과 같이 Department는 클래스 인스턴스이다. 그리고 인스턴스가 생성되어있지만, 속성은 비어있는 상태이다. 이 상태를 `결함이 있다`라고 본다는 것이다. (이를 오류라고 함) 부서가 존재하지 않으니 직원 인스턴스도 생성할 필요가 없을 뿐만 아니라 관계도 채울필요도 없음을 의미한다.
* 그래프가 완전 해야 하는 경우 직원의 프로퍼티를 편집하려면 궁극적으로 전체 기업 구조를 나타내는 개체를 만들어야한다.

> 따라서 returnsObjectsAsFaults가 true인 경우 위와 같은 결함을 가지고있는 경우에도 위 그림과 같은 Department 인스턴스를 생성하지않는다는 이야기인 것 같다. 즉 결함을 허용하겠다는 의미인걸까? false인 경우에는 결함이 있던 말던 모든 인스턴스를 반환하도록 강제한다는 뜻인 것 같다.

* 뭔 말인지 잘 이해가 가지 않아서 좀더 공부가 필요할 것 같다...
* 중요한 것은 returnsObjectsAsFaults 이 플래그가 CoreData에 매우 메모리 효율적인 Lazy loading를 수행하도록 지시한다고 한다. [?]
    * `메모리 최적화`랑 연관이 있다고...
    * https://ali-akhtar.medium.com/mastering-in-coredata-part-10-nsfetchrequest-a011684dd8f7

---

**[Protocol - NSFetchRequestResult]**

https://developer.apple.com/documentation/coredata/nsfetchrequestresult

* FetchRequest를 보낼때 단순히 NSManagedObject말고 다른 타입들도 유연하게 받고싶다면, 이 프로토콜을 활용할 수 있다.
* Conforming Types
    * NSDictionary
    * NSManagedObject
    * NSManagedObjectID
    * NSNumber

---

**[동기화 메모장 프로젝트]**

> 혼자 코드 끄적이다가... 몇가지 해결한 문제점들을 기록해본다

* textViewDidChange를 할때마다 코어데이터에 createMemo 메소드로 NSManagedObject를 생성하고 있는 부분 때문에 '+'버튼을 누를 경우 글자를 입력한 순서대로 와장창... 메모가 추가된다.
    * 예시) 텍스트 "asd"를 순서대로 입력하고 `'+' 버튼 클릭시` 메모 a, 메모 s,  메모 d 총 3개의 메모와 새로운 메모, 즉 `총 4개의 메모장`이 생성된다아...
* 코어데이터에 생성한 엔티티에 `고유한 식별자`가 없다.
    * 기존 메모를 수정해주려먼 해당 메모를 `NSPredicate로 필터링해서 fetch한 후` `수정`을 해주어야 하는데, 고유한 식별자가 없어서 불가능하다.
* 뷰에 보여줄 요소들을 별도의 타입으로 만들어준 부분(MemoListInfo, MemoDetailInfo)은 필요없다고 판단되었다.
    * 데이터를 가공해서 인스턴스를 만드는 작업까지 꽤나 많은 양의 코드가 들어가있다. 모두 제거해주고 3개의 ViewController에서 Memo 타입만을 사용하게 된다면 코드 가독성이 올라갈 것 같다.

**[문제해결을 하면서 알게된 부분]**

* 날짜가 최신이면 리스트에서 최상단으로 cell이 move했으면 좋겠어!
    * [UITableView - moveRow(at:to:)](https://developer.apple.com/documentation/uikit/uitableview/1614987-moverow)
> Cell이 이동하는 동시에 데이터도 처리가 필요해서 Array의 요소를 새 인덱스로 이동하는 기능이 필요한데...

* 뭐 구글링하니까 누가 좋은 코드를 써두었네 ㅎㅎ
```swift
// 배열의 요소를 새 인덱스로 이동시키 기능 확장
extension Array {
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        guard oldIndex != newIndex else { // 두 인덱스가 같으면 탈출
            return
        }
        if abs(newIndex - oldIndex) == 1 { // 절대값을 계산해서 1이라면
            return self.swapAt(oldIndex, newIndex) // 스왑해서 리턴
        }
        self.insert(self.remove(at: oldIndex), at: newIndex) // insert를 이용하네.. 지웠다가 새인덱스에 추가함
    }
}

```

---

- 참고링크
    - https://moonibot.tistory.com/52
    - https://moonibot.tistory.com/48
    - https://jcsoohwancho.github.io/2020-01-02-Core-Data-%EC%8B%9C%EC%9E%91%ED%95%98%EA%B8%B0(2)-Data-Model-%EB%A7%8C%EB%93%A4%EA%B8%B0(1)-entity%EB%A7%8C%EB%93%A4%EA%B8%B0/
    - https://stackoverflow.com/questions/34545708/what-is-the-purpose-of-returnsobjectsasfaults
    - https://ali-akhtar.medium.com/mastering-in-coredata-part-10-nsfetchrequest-a011684dd8f7
    - https://stackoverflow.com/questions/10532626/how-to-fetch-just-object-ids-but-also-include-the-row-data-in-coredata/23007159#23007159
    - https://stackoverflow.com/questions/36541764/how-to-rearrange-item-of-an-array-to-new-position-in-swift/43273824
