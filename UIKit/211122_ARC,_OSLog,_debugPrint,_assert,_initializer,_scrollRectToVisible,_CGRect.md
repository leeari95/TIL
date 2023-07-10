# 211122 ARC, OSLog, debugPrint, assert, initializer, scrollRectToVisible, CGRect
# TIL (Today I Learned)


11월 22일 (월)

## 학습 내용
- **ARC 활동학습**
    - 메모리 영역을 4가지로 나누는 이유
    - weak는 언제 써야할지 알겠는데, unowned는 언제써야해?
- **계산기 프로젝트 STEP 3 피드백 고민**
    - 개발자에게 보여주기 위한 print문..?
        - OSLog
        - debugPrint
        - assert
    - override init과 required init의 차이점은?
- **계산기 모둠 프로젝트를 하면서 알게된 사실**
    -  scrollRectToVisible()을 이용해서 자동스크롤을 구현할 수 있었다.
&nbsp;

## 고민한 점 / 해결 방법
### 메모리 영역을 4가지로 나누는 이유
- 우리가 어떠한 프로그램을 구현할 때 각각의 변수, 함수, 클래스 등이 `호출되고 해제되는 시기가 다르기 때문`이다. 만약 어떠한 함수 내에서 한번 사용되는 변수가 프로그램의 처음부터 끝까지 메모리에 남아있다면 메모리가 낭비되는 일이 될 것이다.

### ARC가 하는 것과 못하는 것?
- 힙에 메모리를 자동으로 해제해주어 메모리관리를 대신 처리해주지만 `참조사이클까지는 자동으로 처리해주지 못한다.`
- 이를 해결하려면 약한 참조와 미소유참조 통해 해결할 수 있다.

### unowned는 언제 써야해?
- weak는 참조가 해제될 때 nil을 넣어주고 unowned는 nil을 할당하지 못하고 해제된 메모리 주소값을 계속 들고 있는다.
- 성능이 중요하거나 `Dangling pointer가 있는 위험을 감수`하겠다고 하면 unowned를 사용한다.
- weak와 달리 unowned는 다른 인스턴스보다 `긴 생명주기를 가진 인스턴스를 참조`할 때 주로 사용한다.
- 절대 먼저 메모리에서 해제될 일 없다는 걸 보장할 수 있고 시간/공간/계산의 복잡성을 제거할 수 있다.
- 객체의 라이프 사이클이 명확하고 개발자에 의해 제어 가능이 명확한 경우 weak Optional 타입 대신 사용하여 좀 더 간결한 코딩이 가능하다.

> Dangling pointer란?
> 원래 바라보던 인스턴스가 해제되면서 할당되지 않는 공간을 바라보는 포인터

---

- OSLog는 [일요일날 공부](https://github.com/leeari95/TIL/blob/main/2021-11/211121%20OSLog.md)를 해보았는데 나머지 두 부분은 한번 알아봐야겠다.
### debugPrint()
- print()의 경우 인스턴스를 출력할 때 핵심 내용만을 출력해주지만 debugPrint()의 경우 해당 인스턴스의 상세 내역까지 함께 출력해준다.
- 디버깅 진행 시 쓸데없는 내용까지 친절하게 다 출력해주므로 약간의 속도 저하나 찍혀있는 로그 내용을 읽는데 불편을 주는 경우도 있다.
### assert
- `특정 조건을 체크`하고 조건이 성립되지 않으면 `메세지를 출력`하게 할 수 있다. 실제 배포된 앱 성능에는 영향을 끼치지 않는다는 특징이 있다.
- 주로 디버깅 중 조건의 검증을 위하여 사용한다.
- API 테스트 등, 조건 체크 및 테스트를 해야할 때 유용하게 사용할 수 있다.

---

### override init 과 required init의 차이
- override init
    - 상속한 부모의 이니셜라이저를 재정의한 것
- required init
    - 상속받았을 때 필수로 정의해야하는 이니셜라이저

---

### scrollRectToVisible
```swift
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 ) {
    self.calculationHistoryScrollView
        .scrollRectToVisible(CGRect(x: 0,
                                    y: self.calculationHistoryScrollView.contentSize.height
                                        - self.calculationHistoryScrollView.bounds.height,
                                    width: self.calculationHistoryScrollView.bounds.size.width,
                                    height: self.calculationHistoryScrollView.bounds.size.height),
                             animated: true)
}
```
- 니코는 나와 아예 다른 방법으로 Scroll View의 자동스크롤을 구현을 했었다.
- 설명하자면 `DispatchQueue.main.asyncAfter` 메소드를 활용하여 `0.1초 딜레이`를 준 후 레이아웃을 계산하여 스크롤을 하는 방식이다.
- 스택뷰가 추가되고 난 후 0.1초 뒤 해당 메소드가 실행되어 스크롤 뷰의 레이아웃을 계산한다고 보면 된다.
- `scrollRectToVisible()` 메소드는 콘텐츠의 특정 영역을 스크롤 하는 메소드다.
- `setContentOffset()` 메소드와 다른 점은 **CGPoint**가 아니라 **CGRect**을 이용하여 스크롤을 한다는 차이점이 있는 것 같다.

### CGPoint와 CGRect의 차이점은 뭘까?
- 스크롤을 할때 사용하는 두 메소드의 파라미터 타입이 달라서 궁금해졌다.
```swift
func scrollRectToVisible(_ rect: CGRect, 
                animated: Bool)
```
```swift
func setContentOffset(_ contentOffset: CGPoint, 
             animated: Bool)
```
- **CGPoint**
    - 2차원 좌표계의 점을 포함하는 타입
    - x좌표와 y좌표를 가지는 타입이라고 보면 될 것 같다.
- **CGSize**
    - 너비와 높이 값을 포함하는 타입
    - 이것도 Point와 마찬가지로 너비와 높이의 값을 가지는 타입으로 보면 될 것 같다.
- **CGRect**
    - 사각형의 위치와 크기를 포함하는 타입
    - Rectangle의 약자인 듯
    - 너비와 높이를 가지고 있을 뿐만 아니라 원점도 가지고 있다.
    - 정의 부분을 살펴보면 origin은 CGPoint, size는 CGSize로 정의되어있다.
> 현실에서는 너비와 높이만 있어도 사각형을 그릴 순 있지만 iOS에서는 `위치`를 알아야 그릴 수 있다.



&nbsp;

---

- 참고링크
    - https://leeari95.tistory.com/15
    - https://developer.apple.com/documentation/swift/1539920-debugprint
    - https://developer.apple.com/documentation/swift/1541112-assert
    - https://developer.apple.com/documentation/uikit/uiscrollview/1619439-scrollrecttovisible
    - https://developer.apple.com/documentation/uikit/uiscrollview/1619400-setcontentoffset
    - https://zeddios.tistory.com/201
    - https://developer.apple.com/documentation/swift/1541112-assert
