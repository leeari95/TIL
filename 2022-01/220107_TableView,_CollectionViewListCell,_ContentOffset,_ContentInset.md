# 220107 TableView, CollectionViewListCell, ContentOffset, ContentInset
# TIL (Today I Learned)


1월 7일 (금)

## 학습 내용
- 오픈 마켓 프로젝트 STEP 2
- UICollectionView로 List를 커스텀할 수 있나...


&nbsp;

## 고민한 점 / 해결 방법

* 이번 프로젝트 때 리스트 뷰를 컬렉션뷰로 구현해야하나 고민이 많이 되었다.
    * 일단 테이블뷰에서는 설정할 수 있는 부분이 한정되어있다.
    * 따라서 확장 가능성이 있다면 컬렉션뷰로 구현해두는 것이 더 유연하다.
    * 하지만 목록만 보여주는 뷰라면 테이블뷰로 구현하는 것이 간편할 것이다.
    * 컬렉션뷰로도 리스트 구현이 가능하지만, 테이블뷰로 구현하는 것보다 해줘야할 설정이 많고, 복잡하다.
    * 또한 요즘에는 SwiftUI가 점점 선호되는[?] 추세라고 한다.
    * 그렇지만.. 제리랑 같이 발전된 컬렉션뷰(14.0버전)에 대해 알아보기 위해 삽질했던 시간이 아까워서 각자 한번 다시 도전해보기로 했고, 그래도 힘들다면 테이블뷰로 간편하게 구현하기로 하였다.
        * 컬렉션뷰로 둘다 구현한다면 셀만 갈아끼워서 간단히 구현할 수 있지 않나.. 라는 생각이 들기도 했다.

**[WWDC 2020]**

* setNeedsUpdateConfiguration()
    * 현재 Configuration 업데이트를 셀에 요청하는 메소드. 이 메소드는 자동으로 호출된다.
    * 셀이 ConfigurationState가 변경되었을 때

**[Collection View List Configuration]**

* ![](https://i.imgur.com/lnyFWIz.png)
* 콜렉션뷰에서 list를 작성하기 위해 레이아웃 측에서 필요한 3가지 유형
    * UICollectionLayoutListConfiguration
    * NSCollectionLayoutSection
    * UICollectionViewCompositionalLayout
* UICollectionLayoutListConfiguration은 NSCollectionLayoutSection과 iOS 13에서 도입한 기존 구성 레이아웃 시스템의 일부인 UICollectionViewCompositionalLayout 위에 구축되었다.
* iOS 14에서는 UICollectionLayoutListConfiguration이라는 새로운 타입을 제공한다.
* List Configuration은 테이블뷰의 스타일 (.plain, .grouped, .insetGrouped)과 같은 모양을 제공한다.
* 또한 콜렉션 뷰의 List 전용 .sidebar, .sidebarPlain라는 새로운 스타일을 사용하여 iPadOS 14에서 다중열 앱을 구축할 수 있다.

**[Simple setup]**

* ![](https://i.imgur.com/2GMThBg.png)
* list를 작성하는 가장 쉬운 방법은 UICollectionLayoutListConfiguration을 작성하고 appearance를 제공한 다음 이 구성을 사용하여 UICollectionViewCompositionaLayout을 작성하는 것이다.
* 섹션 별 설정
* ![](https://i.imgur.com/E6nN9ss.jpg)
* 구성은 동일하지만 이 구성을 사용하여 compositional layout 대신에 NSCollectionLayoutSection을 작성한다.
* 이 코드는 컴포지션 레이아웃의 기존 섹션 공급자 이니셜라이저 내에서 사용될 수 있으며, 컬렉션뷰의 모든 섹션에 대해 호출되어 특정 섹션에 고유한 개별 레이아웃 정의를 반환할 수 있다.

**[ContentOffset vs ContentInset]**

* ContentOffset
    * point이다. x, y 좌표를 의미하는 것으로 스크롤 한다는 것 자체가 ContentOffset이 변한다는 의미이다.
* ContentInset
    * 컨텐츠에 상하 좌우 여백을 주는 것이다.
    * 컨텐츠의 바깥쪽이 아닌 안쪽 여백을 말하는 것이다.
---

- 참고링크
    - https://jinshine.github.io/2018/12/06/iOS/ContentOffset%EA%B3%BC%20ContentInset/
    - https://www.raywenderlich.com/16906182-ios-14-tutorial-uicollectionview-list
    - https://shoveller.tistory.com/entry/WWDC20-Lists-in-UICollectionView
    - https://developer.apple.com/videos/all-videos/?q=collectionView
