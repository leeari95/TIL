# 220121 selectedBackgroundView, UIRefreshControl, 피드백, paging
# TIL (Today I Learned)


1월 21일 (금)

## 학습 내용
- 오픈마켓2 STEP 1 PR 피드백 반영
- UICollectionView의 `selectedBackgroundView`
- 아래로 당겨서 새로고침 기능
- CollectionView로 Paging 구현하기


&nbsp;

## 고민한 점 / 해결 방법

**[CollectionViewCell에 선택했다는...? 효과 추가해보기]**

- UITableView같은 경우에는 기본적으로 seleted 했을 때, 회색 배경이 사라지지 않아서 delegate 메소드를 활용하여 deselect를 해주어야 배경색이 다시 원래대로 돌아왔었다.
- 하지만 UICollectionView 같은 경우에는 이 부분도 직접 설정을 해주어야 한다. 하는 방법은 정말 간단하다.
```swift
selectedBackgroundView = UIView(frame: self.bounds)
selectedBackgroundView?.backgroundColor = .systemGray5
```
* 셀을 초기화할 때 해당 코드를 추가해주면 셀을 선택했을 때 backgroundColoer가 입혀진 UIView로 바뀌는 로직인 것 같다.
* 하지만 이 코드만으로는 셀의 배경색이 그대로 바뀌어버린 채 원래 배경색으로 돌아오지 않는 현상이 있다.
* ![](https://i.imgur.com/jgslpbg.gif)
* 따라서 아래 메소드도 추가해주어야 한다.
```swift
// UICollectionViewDelegate...
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
}
```
* 이렇게하면 셀을 선택했을 때, 선택되었다는 효과가 일어난다.
* ![](https://i.imgur.com/31itgHC.gif)

---

**[피드백]**

* `NSPhotoLibraryUsageDescriptiond`: 사진 앨범 모든 기능에 대해 부여받는다.
* `NSPhotoLibraryAddUsageDescription`: 사진을 추가하기 위한 기능에 대해 부여받는다. (쓰기 전용)
* ![](https://i.imgur.com/VNDgoss.png)
* ![](https://i.imgur.com/fF9NJdc.png)
    * 이 부분은 정확하게 이해되지 않아서 차주에 다시 물어보기로 하였다.

---

**[아래로 당겨서 새로고침]**

* UIRefreshControl를 CollectionView에 추가하면 된다.
```swift
// 인스턴스 생성
private var refreshControl: UIRefreshControl  UIRefreshControl()
// addTarget 등록
collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateMainView), for: .valueChanged) 

@objc private func updateMainView() {
    // 네트워킹 메소드를 포함하고 아래 블럭을 추가하여 뷰를 업데이트 하기
    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
    }
}
```

---

**[CollectionView로 Paging 구현하기]**

* 먼저 CollectionView를 아래와 같이 선언해준다.
```swift
class ViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout() // 콜렉션뷰 내부 레이아웃을 잡기 위함
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        return collectionView
    }()

...
```
* 그리고 셀에 등록할 아이템들을 선언해준다.
```swift
// ViewController 내부
let emojies = ["🔥", "🥰", "🥲", "👍", "👨‍🔬", "🤪", "🐸", "⚾️"]
```
* 아래와 같이 컬렉션뷰의 레이아웃도 잡아주자~
```swift
private func setupCollectionViewLayout() {
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemGray
    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                           constant: -UIScreen.main.bounds.height / 1.4).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
}
```
* 데이터 소스 설정
```swift
extension ViewController: UICollectionViewDataSource { // 셀의 갯수와 재사용셀을 설정하기 위함
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.label.text = emojies[indexPath.item]
        
        return cell
    }
}
```
* 👉🏻 제일 중요한 부분이다. CollectionView의 경우 minimumLineSpacing이 기본적으로 값(10.0)이 들어가있다. 따라서 해당 부분을 아래와 같이 설정해주어야 스크롤 했을 때 밀림현상이 없어진다.
* 적용전에는 `itemSize`만 주었을 때이다.
* ![](https://i.imgur.com/tY0ND4c.gif)
* 이후 `minimumLineSpacing을 0으로 설정`해주었더니 위에서 스크롤이 조금씩 밀리던 현상이 해결되었다.
* ![](https://i.imgur.com/wszbJ1I.gif)
* UICollectionViewDelegateFlowLayout 코드
```swift
extension ViewController: UICollectionViewDelegateFlowLayout { 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width * 1.3)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}
```
---

- 참고링크
    - https://stackoverflow.com/questions/40443458/uicollectionviewcell-backgroundcolor-not-change-when-selected
    - https://mobikul.com/pull-to-refresh-in-swift/
    - https://stackoverflow.com/questions/51336929/uicollectionview-ispagingenabled
