# 211221 CollectionView, Unit Test
# TIL (Today I Learned)


12월 21일 (화)

## 학습 내용
- 은행창구매니저 STEP 1 PR, STEP 2 설계
- UICollectionView?

&nbsp;

## 고민한 점 / 해결 방법
**[private한 속성에 접근하여 테스트하는 것이 올바른 것일까?]**
* Queue나 LinkedList를 타입으로 구현하게 되면서 Node나 head, tail등 접근하여 테스트 하는 경우가 있다.
* 나랑 허황도 해당 문제 때문에 고민을 했었는데... 요한, 아카펠라, 호박네 팀도 같은 고민을 하고 있었다. 고민을 엿듣다가 다시 생각해보게 되었다.
* 직접 속성값을 접근하여 테스트 결과를 확인해보는 것이 올바른 것인지 의문이 들었다.
    * 오늘 다시 고민해보니 적절치 못하다는 생각이 들었다. 그 이유는 애초에 접근하지 못하도록 만든 속성값을 접근하여 테스트 결과를 확인한다는 것이... 말이 안되기 때문이다. 접근하지 못하는 프로퍼티는 테스트가 불가능한 것이 맞다는 생각이 들었다. 따라서 접근할 수 있는 프로퍼티나 메소드를 활용하여 최소한으로 테스트를 진행하는 것이 맞다는 판단이 들었다.
* 나랑 허황은 해당 문제를 해결하기 위해 Mock 타입을 따로 구현하였다.
    * 하지만 이 방법은 만약 LinkedList에 기능이 추가된다면 Mock에도 기능이 추가되어야하는데, 똑같이 기능이 추가된다는 보장이 없다.
    * 따라서 Mock을 쓰는 것은 적절하지 않다 라는 생각이 들었다.
    * 기능을 준수하게 만드는 프로토콜을 생성한다면 이 문제를 해결할지도 모르겠다.
        * Mock타입, 실제 타입 둘다 프로토콜을 준수하게 만든다면 추후 기능이 추가되더라도 프로토콜을 수정할 것이니 둘다 수정할 수 있을 것이다.
* 하지만 테스트를 통해 알고싶은 것은 상태값인데, 그렇다면 상태값을 반환하는 프로퍼티나 메소드를 추가로 만들어야 하는 것일까?
    * 테스트를 위한 코드이기 때문에... 그것이 걸렸다.
    * 테스트 외에 사용하지 않는 기능이라면 구지 추가해줄 필요가 있을까..?
* 그렇다면 인덱스를 통해 값을 접근할 수 있도록 Subscript를 활용하는 것은 어떨까?
    * 이것또한 테스트를 위해서만 활용될 거라는 추측 때문에... 좋은 방법인지는 확신이 서질 않았다.
* 해당 부분에 대해서 리뷰어에게 추가적으로 조언을 구해보면 좋을 것 같다.

---

**[컬렉션뷰]**

* 컬렉션뷰란?
    * 유연하고 변경 가능한 레이아웃을 사용하여 데이터 아이템의 정렬된 세트를 표시하는 수단이다.
    * 가장 일반적인 용도는 데이터 아이템을 그리드와 같은 형태로 표현한다.
    * ![](https://i.imgur.com/2vYHtLg.png)
- 컬렉션뷰의 구성요소
    - 셀(cell)
        - 컬렉션뷰의 주요 콘텐츠를 표시한다.
        - 컬렉션뷰는 컬렉션 데이터 소스 객체에서 표시할 셀에 대한 정보를 가져온다.
        - 각 셀은 `UICollectionViewCell` 클래스의 인스턴스 또는 `UIColletionViewCell`을 상속받은 클래스의 인스턴스이다.
    - 보충 뷰(Supplementary views)
        - 섹션에 대한 정보를 표시한다.
        - 셀과 달리 보충 뷰는 필수는 아니며, 사용법과 배치 방식은 사용되는 레이아웃 객체가 제어한다.
            - 헤더와 푸터를 예로 들 수 있다.
    - 데코레이션 뷰(Decoration views)
        - 콘텐츠가 스크롤 되는 컬렉션뷰에 대한 배경을 꾸밀 때 사용한다.
        - 레이아웃 객체는 데코레이션 뷰를 사용하여 커스텀 배경 모양을 구현할 수 있다.
    - 레이아웃 객체(Layout Object)
        - 컬렉션뷰 내의 아이템 배치 및 시각적 스타일을 결정한다.
        - 컬렉션뷰 데이터소스 객체가 뷰와 표시할 콘텐츠를 제공한다면, 레이아웃 객체는 크기, 위치 및 해당 뷰의 레이아웃과 관련된 특성들을 결정한다.
- 컬렉션뷰 구현을 이루기 위한 클래스 및 프로토콜
    - 최상위 포함 및 관리(Top level containment)
        - `UICollectionView`
            - 컬렉션 뷰의 콘텐츠가 보이는 영역을 정의한다.
        - `UICollectionViewController`
            - 컬렉션 뷰를 관리하는 뷰 컨트롤러이다. 선택적으로 사용할 수 있다.
    - 콘텐츠 관리
        - `UICollectionViewDataSource`
            - 컬렉션뷰와 관련된 중요한 객체이며 필수적으로 제공해야 한다.
            - 컬렉션뷰의 콘텐츠를 관리하고 해당 콘텐츠를 표시하기 위한 뷰를 제공한다.
        - `UICollectionViewDelegate`
            - 사용자와의 상호작용과 셀 강조 표시 및 선택 등을 관리한다.
    - 표시(Presentation)
        - `UICollectionReusableView`
            - 컬렉션에 표시된 모든 뷰는 해당 클래스의 인스턴스여야 한다.
            - 컬렉션뷰에서 사용중인 뷰 재사용 매커니즘을 지원한다.
            - 새로운 뷰를 만드는 대신 뷰를 재사용하여 성능을 향상 시킨다.
        - `UICollectionViewCell`
            - 인스턴스에 제공되는 데이터를 화면에 표시하는 역할을 담당한다.
    - 레이아웃(Layout)
        - `UICollectionViewLayout`
            - 해당 클래스의 서브클래스는 레이아웃 객체라고 하며 컬렉션뷰 내부의 셀 및 재사용 가능한 뷰의 위치, 크기 및 시각적 속성을 정의한다.
        - `UICollectionViewAttribute`
            - 컬렉션뷰 내의 지정된 아이템의 레이아웃 관련 속성을 관리한다.
            - 레이아웃 프로세스 중에 컬렉션뷰에 셀과 재사용 가능한 뷰를 표시하는 위치와 방법을 알려준다.
            - 레이아웃 객체 아이템이 삽입, 삭제 혹은 컬렉션 뷰 내에서 이동할 때마다 레이아웃 객체는 UICollectionViewUpdateItem의 인스턴스를 받는다.
    - 플로우 레이아웃(Flowlayout)
        - `UICollectionViewFlowLayout` / `UICollectionViewDelegatFlowLayout`
            - 그리드 혹은 다른 라인기반(lined-based) 레이아웃을 구현하는 데 사용된다.
            - 클래스를 그대로 사용하거나 동적으로 커스터마이징할 수 있는 플로우 델리게이트 객체와 함께 사용할 수 있다.
            - `UICollectionViewFlowLayout`는 컬렉션뷰를 위한 디폴트 클래스로, 그리드 스타일로 셀들을 배치하도록 설계되어있다. scrollDirection 프로퍼티를 통해 수평 및 수직 스크롤을 지원한다.

---

**[컬렉션뷰 셀]**

* 컬렉션뷰 셀이란?
    * 컬렉션뷰에서 데이터를 화면에 표시하기 위해 사용된다.
    * 냉장고 속에 있는 반찬통으로 생각할 수 있다. 컬렉션뷰라는 냉장공가 있고, 냉장고 안에는 실제 반찬(콘텐츠)을 담고 있는 컬렉션뷰 셀이라는 반찬통이 있다고 생각할 수 있다.
* 특징
    * 데이터 아이템을 화면에 표시한다.
    * 하나의 셀은 하나의 데이터 아이템을 화면에 표시한다.
    * 두개의 배경을 표시하는 뷰와 하나의 콘텐츠를 표시하는 뷰로 구성되어 있다. 두개의 배경뷰는 셀이 선택되었을 때 사용자에게 시각적인 표현을 제공하기 위해 사용된다.
    * 컬렉션뷰의 레이아웃 객체에 의해 관리된다.
    * 뷰의 재사용 메커니즘을 지원한다.
    * 일반적으로 컬렉션뷰 셀 클래스의 인스턴스는 직접 생성하지 않는다. 대신 특정 셀의 하위 클래스를 컬렉션뷰 객체에 등록한 후 컬렉션뷰 셀 클래스의 새로운 인스턴스가 필요할 때, 컬렉션의 `dequeueReusavleCell(withReuseIdectifier:for:)` 메소드를 호출한다.
        * 스토리보드를 활용할 때에는 컬렉션뷰에 따로 셀 클래스를 등록할 필요는 없다.
- `UICollectionViewCell`
    - 셀의 구성요소 관련 프로퍼티
        - `var contentView: UIView`
            - 셀의 콘텐츠를 표시하는 뷰
        - `var backgroundView: UIView?`
            - 셀의 배경을 나타내는 뷰
            - 셀이 처음 로드되었을 경우 셀이 강조 표시되지 않거나 선택되지 않을 때 항상 기본배경의 역할을 한다.
        - `var selectedBackgroundView: UIView?`
            - 셀이 선택되었을 때 배경뷰 위에 표시되는 뷰
            - 셀이 강조 표시되거나 선택될 때마다 기본 배경 뷰인 backgroundView를 대체하여 표시된다.
    - 셀의 상태 관련 프로퍼티
        - `var isSelected: Bool`
            - 셀이 선택되었는지를 나타낸다.
            - 셀이 선택되어있지 않다면 false다.
        - `var isHighlighted: Bool`
            - 셀의 하이라이트 상태를 나타낸다
            - 하이라이트 되어있지 않다면 기본값은 false다.
    - 셀의 드래그 상태 관련 메서드
        - `func dragStateDidChange(_:)`
            - 셀의 드래그 상태가 변경되면 호출된다.
            - 드래그 상태는 UICollectionViewCellDragState의 열거형으로 표현된다.
                - None, lifting, dragging의 3가지 상태를 갖는다.
- 컬렉션뷰 셀 vs 테이블뷰 셀
    - 테이블 뷰 셀의 구조는 콘텐츠 영역과 액세서리뷰 영역으로 나뉘었지만, 컬렉션뷰 셀은 배경뷰와 실제 콘텐츠를 나타내는 콘텐츠 뷰로 나뉘어져있다.
    - 테이블뷰 셀은 기본으로 제공되는 특정 스타일을 적용할 수 있지만 컬렉션뷰 셀은 특정한 스타일이 없다.
    - 테이블뷰 셀은 목록형태로만 레이아웃 되지만, 컬렉션뷰 셀은 다양한 레이아웃을 지원한다.

---

**[DataSource와 Delegate]**

![](https://i.imgur.com/5FdeptX.png)

- 데이터소스(DataSource)
    - 가장 중요한 객체이며, 필수로 제공해야 한다.
    - 컬렉션뷰의 콘텐츠(데이터)를 관리하고 해당 콘텐츠를 표현하는 데 필요한 뷰를 만든다.
    - 데이터소스 객체를 구현하려면 UICollectionViewDataSource 프로토콜을 준수하면 된다.
    - 그리고 데이터소스 객체는 최소한 `collectionView(:numberOfItemsInSection:)`*과* `collectionView(:cellForItemAt:)` 메서드를 구현해야 하며 나머지는 선택사항이다.
    - 필수 메소드
        - `func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int`
            - 지정된 섹션에 표시할 항목의 개수를 묻는 메소드
        - `func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell`
            - 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 메소드
    - 주요 선택 메소드
        - `optional func numberOfSections(in collectionView: UICollectionView) -> Int`
            - 컬렉션뷰의 섹션의 개수를 묻는 메소드
            - 구현하지 않으면 섹션 개수 기본값은 1이다.
        - `optional func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool`
            - 지정된 위치의 항목을 컬렉션뷰의 다른 위치로 이동할 수 있는지를 묻는 메소드
        - `optional func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)`
            - 지정된 위치의 항목을 다른 위치로 이동하도록 지시하는 메소드
- 델리게이트(Delegate)
    - 컬렉션뷰에서 셀의 선택 및 강조표시를 관리하고 해당 셀에 대한 작업을 수행할 수 있는 메소드를 정의한다.
    - 주요 메소드
        - `optional func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool`
            - 지정된 셀이 사용자에 의해 선택될 수 있는지 묻는 메소드
            - 선택이 가능한 경우 true로 응답하며 아닌경우는 false로 응답한다.
        - `optional func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)`
            - 지정된 셀이 선택되었음을 알리는 메소드
        - `optional func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool`
            - 지정된 셀의 선택이 해제될 수 있는지 묻는 메소드
            - 선택해제가 가능한 경우 true로 응답하며, 그렇지 않다면 false로 응답한다.
        - `optional func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)`
            - 지정된 셀의 선택이 해제되었음을 알리는 메소드
        - `optional func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool`
            - 지정된 셀이 강조될 수 있는지 묻는 메소드.
            - 강조해야하는 경우 true로 응답하며 그렇지 않다면 false로 응답
        - `optional func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath)`
            - 지정된 셀이 강조되었을 때 알려주는 메소드
        - `optional func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath)`
            - 지정된 셀이 강조가 해제될 때 알려주는 메소드

---

- 참고링크
    - https://www.boostcourse.org/mo326/lecture/16906?isDesc=false
    
