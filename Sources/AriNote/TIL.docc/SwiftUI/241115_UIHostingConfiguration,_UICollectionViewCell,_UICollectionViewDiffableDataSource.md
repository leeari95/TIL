# 241115 UIHostingConfiguration UICollectionViewCell UICollectionViewDiffableDataSource


UICollectionView에 SwiftUI로 만든 뷰를 셀로 사용해보기


11월 15일 (금)


# 학습내용


- iOS 16 부터 제공되는 UIHostingConfiguration를 사용하는 방법


# 고민한 점 / 해결방법


- 회사에서 기존 UIKit 프로젝트 내에서 UIKit을 조금씩 걷어내보려는 시도를 해보고 있다.
- 새로운 과제를 맡게되어서 SwiftUI로 개편할 수 있을까? 살펴보았지만, 기존 기능을 유지해야해서 어쩔 수 없이 모두 제거할 수는 없었다.
- 그래서 최소한 셀만이라도 SwiftUI로 구현해보고 싶어서 도전하게 되었다!


## UIHostingConfiguration 사용하는 방법

1. 먼저 CellRegistration을 아래처럼 설정해준다.

```swift
let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item> { cell, _, item in
    cell.contentConfiguration = UIHostingConfiguration {
         VStack(alignment: .leading, spacing: 16) {
            Text("제목")
                .font(.bold(17))
                .foregroundStyle(Color.black)
                .frame(maxWidth: Const.width, alignment: .leading) // 디바이스 크기만큼 maxWidth를 설정하였음.
            Text(item.content)
                .font(.regular(15))
                .foregroundStyle(Color.black)
                .lineLimit(nil)
                .frame(maxWidth: Const.width, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // 셀 크기에 맞게 뷰가 늘어나도록 설정.
    }
    .margins(.horizontal, 20) // 셀의 좌, 우 마진을 설정
}
```

2. 이후 dataSource에서는 아래와 같이 셀을 재사용해주면 된다.

```swift
dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
    collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
})
```

나머지 컴포지셔널 레이아웃 설정이라던지.. 스냅샷 적용과 같은 로직들은 기존 UIKit 동작과 동일하게 설정해주면 된다.
진짜 셀만 SwiftUI로 구현해서 사용해볼 수 있다...! 너무 조은걸~~~! 😆

---


# 참고 링크

- [https://developer.apple.com/documentation/SwiftUI/UIHostingConfiguration](https://developer.apple.com/documentation/SwiftUI/UIHostingConfiguration)
- [https://stackoverflow.com/questions/74310650/remove-padding-when-using-uihostingconfiguration-in-cell](https://stackoverflow.com/questions/74310650/remove-padding-when-using-uihostingconfiguration-in-cell)