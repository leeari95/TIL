# 220114 Implementing Modern Collection Views Custom
# TIL (Today I Learned)


1월 14일 (금)

## 학습 내용
- iOS 14.0 부터 사용할 수 있는 컬렉션뷰 커스텀해보기
    - [커밋을 활용하여 단계[?]별로 쪼개보았다.](https://github.com/leeari95/ModernCollectionView_Example)


&nbsp;

## 고민한 점 / 해결 방법

**[UIWindow]**

* View 들을 담는 컨테이너
* 사용자 인터페이스에 배경을 제공하며 이벤트 처리 행동을 제공하는 객체이다.
* ![](https://i.imgur.com/HyGDGIY.png)
* 시각적인 화면을 가지고 있지 않고 기능적인 면을 담당한다.
    * 상호작용 처리, 라우팅 x축 레벨 설정, 좌표계 변환
* 자동으로 Xcode가 앱의 기본 Window를 제공한다.
    * 최초 iOS 프로젝트에는 StoryBoard를 사용하여 앱의 View들을 정의
    * Storyboard는 Xcode에서 자동으로 제공하는 Appdelegate 또는 SceneDelegate에 window 속성이 존재해야 가능하다.
* ![](https://i.imgur.com/r2NEzXR.png)
* 최초 프로젝트 생성 시 스토리보드와 연결된 View를 표현하기 위해 Strong으로 UIWindow 객체가 참조되고 있는 것을 확인
* 주의할 점
    * UIWindow는 UIView의 서브클래스이다.
    * ![](https://i.imgur.com/3U8qTbZ.png)
* 스토리보드가 아닌 코드로 View를 구성할 때에는 Window rootViewController 수정이 필요하다.
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else {
        return
    }
    window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController(rootViewController: ViewController())
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
}
```
* 먼저 scene 메소드 내부에 rootView를 설정해준다.
* 그리고 Main.storyboard 파일을 삭제한다.
* 프로젝트를 클릭후 General 탭에서 Main Interface에 Main 텍스트를 삭제한다.
* ![](https://i.imgur.com/7m5P5ML.jpg)
* 그리고 info.plist로 이동해서 Storyboad Name을 삭제한다.
* ![](https://i.imgur.com/JIEicgd.png)
    * window.makKeyAndVisible() 의미
    * keyWindow로 설정
    * keyWindow란?
        * 윈도우가 여러개 존재할 때 가장 앞쪽에 배치된 윈도우를 keyWindow라고 지칭한다.
            * https://developer.apple.com/documentation/uikit/uiwindow/1621610-makekey

---

[**[UICollectionViewCompositionalLayout.list]**](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout/3600951-list)

* 테이블뷰의 스타일(`.plain`, `.grouped`, `.insetGrouped`)과 같은 모양을 제공한다.
* 또한 CollectionView의 List 전용 `.sidebar`, `.sidebarPlain` 이라는 새로운 스타일을 사용하여 `iPadOS 14`에서 `다중 열 앱`을 구축할 수 있다.
* ![](https://i.imgur.com/m3ILpN3.png)
    * https://ios-development.tistory.com/314

---

**[UICollectionViewDiffableDataSource]**

* DataSource하면 떠오르는 것은 기존에 사용하던 `UICollectionViewDataSource`이다.
* UICollectionViewDataSource를 conform하는 대신 `UICollectionViewDiffableDataSource`를 conform 하는 것
* 기존 UICollectionViewDataSource는 `Protocol`이라 UIViewController가 이를 conform하곤 했다.
* 하지만 새롭게 생겨난 UICollectionViewDiffableDataSource는 Protocol이 아니라 `Generic Class`이다.
* 그리고 `UICollectionViewDiffableDataSourc`e가 `UICollectionViewDataSource를 conform`하고 있다.
* 애플이 Diffable DataSource 만든 이유는 [Advances in UI Data Sources](https://developer.apple.com/videos/play/wwdc2019/220/)에서 잘 설명해주고 있다.
* ![](https://i.imgur.com/BaklZqb.png)
* 새롭게 생긴 Diffable DataSource에는 performBatchUpdates()가 없다.
* 대신 Crashing, 번거로움, 복잡성, 처리하고 싶지 않은 모든것들이 없고 [apply](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource/3375811-apply)라는 단일 메소드가 있다.

---

**[NSDiffableDataSourceSnapshot]**

* Snapshot이라는 개념도 도입된다.
* Snapshot은 간단히 말해서 현재 UI state의 truth이다.
* Section과 item에 대해서 Unique identifiers가 있으며, indexPath가 아니라 이 `Unique identifiers로 업데이트`를 하게 된다.

---

- 참고링크
    - https://www.youtube.com/watch?v=5Q4KgyESHRA
    - https://stackoverflow.com/questions/19240054/could-not-find-a-storyboard-named-main-in-bundle
    - https://www.biteinteractive.com/cell-content-configuration-in-ios-14/
    - https://zeddios.tistory.com/1197
    - https://developer.apple.com/documentation/uikit/uicellaccessory
    - https://munokkim.medium.com/wwdc20-%ED%95%9C%EA%B8%80%EB%B2%88%EC%97%AD-lists-in-uicollectionview-ed47aa6793f9
    - https://stackoverflow.com/questions/64736932/uicollectionviewlistcell-always-sets-a-height-of-44-that-conflicts-with-anything
    - https://velog.io/@leeyoungwoozz/iOS-Cell-configuration
    - https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource
    - https://swiftsenpai.com/development/uicollectionview-list-custom-cell/
        - https://github.com/LeeKahSeng/SwiftSenpai-UICollectionView-List
    - https://developer.apple.com/documentation/uikit/uicollectionview
    - https://stackoverflow.com/questions/64049419/uicollectionview-list-with-custom-configuration-how-to-pass-changes-in-cell-to
    - https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot
