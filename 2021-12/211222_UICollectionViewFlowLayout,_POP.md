# 211222 UICollectionViewFlowLayout, POP
# TIL (Today I Learned)


12월 22일 (수)

## 학습 내용
- 은행창구매니저 STEP 1 피드백 확인 후 개선
- UICollectionViewFlowLayout 톺아보기
- Protocol Oriented Programming 예습하기

&nbsp;

## 고민한 점 / 해결 방법

**[Protocol Oriented Programming]**

* Protocol in Objective-C
    * 단지 기능의 청사진의 역할을 수행
    * 주로 Delegate, DataSource 등으로 이용
    * 기본 구현(Default Implementation) 불가
        * 카테고리 적용 불가
* Protocol in Swift
    * Objective-C의 프로토콜 기능은 기본
    * 기본 구현(Default Implementation) 가능
        * Protocol + Extension = Protocol extension
        * 특정 타입이 할 일 지정 + 구현을 한 방에!
* Protocol extension
    * 둘을 함께 사용한다면 공통된 기능을 채택하여 사용할 수 있게 해줄 수가 있다.
* Idea from...
    * 상속의 한계
        * 서로 다른 클래스에서 상속받은 클래스는 동일한 기능을 구현하기 위해 중복 코드 발생
    * 카테고리의 한계 및 부작용
        * 프로퍼티 추가 불가
        * 오직 클래스에만 적용 가능
        * 기존 메서드를 (자신도 모르게) 오버라이드 가능
    * 참조타입의 한계
        * 동적 할당과 참조 카운팅에 많은 자원 소모
* 프로토콜을 활용하여 기능을 조립할 수 있다.
* ![](https://i.imgur.com/LXDZBEo.png)
* 여기서 Extension을 사용하여 protocol을 구현해준다면 기능을 갖다 붙이는 것과 같은 효과를 줄 수 있게 된다.
* ### POP & Value in Project
* 테이블뷰 셀을 클릭하면 디테일뷰가 나오는 구성
    * 사진이 여러개 나오는 뷰도 추가해주면 안될까요?
        * CollectionView
```swift
protocol MediaContainer: class {
    var content: Content? { get set }
    var media: UIImageView { get }
    var note: UILabel { get set }
    
    func contentChanged()
}

extension MediaContainer {
    func contentChanged() {
        // Update view...
    }
}

class TimelineTableViewCell: UITabelViewCell, MediaContainer { 
    var media: UIImageView!
    var note: UILabel!
    var content: Content? {
        didSet {
            contentChanged()
        }
    }
}

class TimelineCollectionViewCell: UITabelViewCell, MediaContainer { 
    var media: UIImageView!
    var note: UILabel!
    var content: Content? {
        didSet {
            contentChanged()
        }
    }
}

class TimelineDetailView: MediaContainer { 
    var media: UIImageView!
    var note: UILabel!
    var content: Content? {
        didSet {
            contentChanged()
        }
    }
}
```
* MediaContainer 프로토콜을 가져다 쓰는 것만으로도 기능을 공통적으로 활용할 수 있다는 장점이 있다.
* ### Controller with POP & Value
* 셀을 클릭할 때 다음 화면으로 넘어가는 부분
    * 이런 공통된 기능을 protocol과 extension을 활용하여 정의해줄 수도 있다.
* ### Protocol과 extension을 사용하면서 얻을 수 있는 이점
    * 범용적인 사용
        * 클래스, 구조체, 열거형 등등 모든 타입에 적용 가능
        * 제네릭과 결합하면 더욱 파급적인 효과 (Type safe & Flexible code)
    * 상속의 한계 극복
        * 특정 상속 체계에 종속되지 않음
        * 프레임워크에 종속적이지 않게 재활용 가능
    * 적은 시스템 비용
        * Reference type cost > Value type cost
    * 용이한 테스트
        * GUI 코드 없이도 수월한 테스트

* ### 한계점
    * 자주 사용되는 Delegate, DataSource 등 프레임워크 프로토콜에는 기본 구현이 불가능 하다. (코코아터치 프레임워크...)
        * Objective-C Protocol + Swift Extension은 기본 구현(Default Implementation)이 불가능하기 때문이다.
* ### 그럼에도 사용하는 이유
    * Value Type을 사용하여 성능상의 이득을 취하자
    * protocol + extension + Generic은 환상의 조합
    * 이제 상속을 통한 수직 확장이 아닌 protocol과 extension을 통한 수평 확장과 기능추가를 고민해볼 때...
* 

---

**[UICollectionViewFlowLayout]**

* 컬렉션뷰의 셀을 원하는 형태로 정렬할 수 있다.
* 레이아웃 객체가 셀을 선형 경로에 배치하고 최대한 이 행을 따라 많은 셀을 채우는 것을 의미한다.
* 현재 행에서 레이아웃 객체의 공간이 부족하면 새로운 행을 생성하고 거기에서 레이아웃 프로세스를 계속 진행한다.
* ![](https://i.imgur.com/hKdr9vV.png)
* 플로우 레이아웃 수직 스크롤
* ![](https://i.imgur.com/7GAHUlO.png)
* 플로우 레이아웃 수평 스크롤
* ![](https://i.imgur.com/5dBifiZ.png)
* 플로우 레이아웃을 사용해 그리드 형태뿐만 아니라 다양한 레이아웃을 구현할 수 있다.
    * 셀을 하나의 행으로 만들어 정렬한 후 간격을 조정할 수도 있다.
* 플로우 레이아웃 단일 행
* ![](https://i.imgur.com/YXtKgyl.png)
* FlowLayout 구성 단계
    * 플로우 레이아웃 객체를 작성해 컬렉션뷰의 레이아웃 객체로 지정한다.
    * 셀의 너비와 높이를 구성한다.
    * 필요한 경우 셀의 간격을 조절한다.
    * 원할 경우 섹션 헤더 혹은 섹션 푸터의 크기를 지정할 수 있다.
    * 레이아웃의 스크롤 방향을 설정한다.
> Tip
> 플로우 레이아웃은 대부분 프로퍼티의 기본값을 가지고 있다. 하지만 셀의 너비와 높이는 모두 0으로 지정되어 있기 때문에 셀의 크기는 지정해주어야 한다. 그렇지 않을 경우 셀의 너비와 높이의 기본값이 0이기 때문에 셀이 화면에 보이지 않을 수도 있다.

* FlowLayout 속성 변경
    * 콘텐츠 모양을 구성하기 위해 여러가지 프로퍼티를 제공
    * 적절한 값을 설정하면 모든 셀에 동일한 레이아웃이 적용된다.
    * 예시로 itemSize 프로퍼티를 사용하여 셀의 크기를 설정할 경우 모든 셀의 크기가 동일하게 적용된다.
* FlowLayout 셀 크기 지정하기
    * 셀이 모두 같은 크기를 가질 경우 itemSize의 프로퍼티에 적절한 너비와 높이 값을 할당한다.
    * 각각 셀마다 다른 크기를 지정하려면 Delegate에서 `collectionView(_:layout:sizeForItemAt:)` 메소드를 구현해야 한다.
        * 메소드의 매개변수로 제공하는 인덱스 경로 정보를 사용해 해당셀의 크기를 반환할 수 있다.
* ![](https://i.imgur.com/Y2yZwgx.png)
> Tip
> 셀마다 다른 크기를 지정하게 되면 행에 있는 셀의 수는 행마다 달라질 수 있다.
> ![](https://i.imgur.com/o0tWeH8.png)
* 셀 및 행의 사이 간격 지정하기
    * 같은 행의 셀 사이의 최소 간격과 연속하는 행 사이의 최소 간격을 지정할 수 있다.
        * 최소 간격이라는 점을 명심하자.
    * 행끼리 간격은 플로우 레이아웃 객체에서 셀끼리의 간격에서와 같은방법을 사용한다.
    * 모든 셀의 크기가 같다면 행 간격의 최솟값을 절대적으로 수용하며 하나의 행에 있는 모든 셀이 다음 행의 셀과 균등한 간격을 유지할 수 있다.
    * 셀의 크기가 동일한 경우
    * ![](https://i.imgur.com/4zFjnUO.png)
    * 셀의 크기가 다른 경우 셀의 간격
    * ![](https://i.imgur.com/xNI5bJN.png)
* 콘텐츠 여백 수정하기
    * 섹션 Inset은 셀을 배치할 때 여백공간을 조절하는 방법의 하나이다.
    * Inset을 사용해 섹션 헤더뷰 다음과 푸터뷰 앞에 공간을 삽입할 수 있다.
    * 콘텐츠의 면 주위에 공간을 삽입할 수도 있다.
    * Inset은 셀 배치에 있어서 사용가능한 공간을 줄이기 때문에 이를 사용하여 주어진 행의 셀 수를 제한할 수도 있다.
    * ![](https://i.imgur.com/bBlsBDR.png)
* 셀 예상(Estimated) 크기 지정
    * UICollectionViewFlowLayout 클래스의 itemSize 프로퍼티를 이용해 모든 셀을 같은 크기로 설정하는 방법
    * UICollectionViewDelegateFlowLayout 프로토콜의 `collectionView(_:layout:sizeForItemAt:)` 메소드를 사용해 셀마다 다른크기를 지정하는 방법
    * 셀에 오토레이아웃을 적용하고 셀 스스로 크기를 결정한 후 이를 UICollectionViewLayout 객체에 알려준다.
        * 이 방법을 사용하려면 estimatedItemSize 프로퍼티를 사용해 대략적인 셀의 최소 크기를 미리 알려준다.
```swift
let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
flowLayout.estimatedItemSize = CGSize(width: 50.0, height: 50.0)

collectionView.collectionViewLayout = flowLayout
```
* UICollectionViewDelegateFlowLayout
    * UICollectionViewFlowLayout과 상호작용하여 레이아웃을 조정할 수 있는 메소드가 정의되어 있다.
    * 셀의 크기와 셀 간의 사이 간격을 정의한다.
```swift
// 지정된 셀의 크기를 반환하는 메소드
optional func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout, 
               sizeForItemAt indexPath: IndexPath) -> CGSize

// 지정된 섹션의 여백을 반환하는 메소드
optional func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout, 
           insetForSectionAt section: Int) -> UIEdgeInsets

// 지정된 섹션의 행 사이 간격 최소 간격을 반환하는 메소드.
// scrollDirection이 horizontal이면 수직이 행이 되고 vertical이면 수평이 행이 된다.
optional func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout, 
minimumLineSpacingForSectionAt section: Int) -> CGFloat

// 지정된 섹션의 셀 사이의 최소 간격을 반환하는 메소드
optional func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout, 
minimumInteritemSpacingForSectionAt section: Int) -> CGFloat

// 섹션의 헤더 크기를 반환하는 메소드
optional func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout, 
referenceSizeForHeaderInSection section: Int) -> CGSize

// 섹션의 푸터 크기를 반환하는 메소드
optional func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout, 
referenceSizeForFooterInSection section: Int) -> CGSize
```


---

- 참고링크
    - https://www.boostcourse.org/mo326/lecture/16906?isDesc=false
    - https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/UsingtheFlowLayout/UsingtheFlowLayout.html
    - https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CreatingCustomLayouts/CreatingCustomLayouts.html#//apple_ref/doc/uid/TP40012334-CH5-SW1
    - https://developer.apple.com/documentation/uikit/uicollectionviewdelegateflowlayout/1617708-collectionview
    - https://developer.apple.com/documentation/uikit/uicollectionviewdelegateflowlayout
    
