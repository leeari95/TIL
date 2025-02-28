# 250228 UICollectionViewDiffableDataSource, animatingDifferences

`UICollectionViewDiffableDataSource`의 `apply` 메소드를 호출할 때 파라미터 `animatingDifferences`를 `true`로 하는것과 `false`로 하는 것이 내부 동작 차이

2월 28일 (금)

# 학습내용

- `animatingDifferences: true`는 데이터 간 차이를 계산해 애니메이션과 함께 업데이트하며, `false`는 애니메이션 없이 변경사항만 적용함  
- iOS 13~14에서는 false가 단순 reloadData처럼 동작했으나, iOS 15부터는 diff 계산 후 애니메이션 여부만 결정된다고 한다.
- true일 때 대규모 데이터셋 업데이트 시, 애니메이션 적용으로 인해 추가 셀 생성, UI 업데이트 이벤트가 많이 발생하여 CPU, GPU, 메모리 부하가 증가하게 된다.

# 고민한 점 / 해결방법

### iOS 버전별 동작 차이 이해

iOS 13~14에서는 `animatingDifferences: false`가 전체 reload처럼 동작해 성능 부담이 적었으나, iOS 15 이상에서는 diff 연산이 수행되므로 애니메이션 여부만 달라진다.

* [https://www.jessesquires.com/blog/2021/07/08/diffable-data-source-behavior-changes-and-reconfiguring-cells-in-ios-15/](https://www.jessesquires.com/blog/2021/07/08/diffable-data-source-behavior-changes-and-reconfiguring-cells-in-ios-15/)
* [https://developer.apple.com/videos/play/wwdc2021/10252](https://developer.apple.com/videos/play/wwdc2021/10252)

### 대규모 데이터 업데이트 최적화

대량의 셀 업데이트 시 애니메이션 적용으로 불필요한 셀 생성과 UI 업데이트가 발생해 성능 저하를 유발한다. 이에 따라 상황에 맞게 animatingDifferences를 `false`로 사용하거나, iOS 15 이상의 `applySnapshotUsingReloadData`를 활용하는 방법을 고려하면 되겠다.

- [https://developer.apple.com/forums/thread/706349#:~:text=Generally%20speaking%2C%20when%20you%20are,animation%20for%20the%20inserted%20cells](https://developer.apple.com/forums/thread/706349#:~:text=Generally%20speaking%2C%20when%20you%20are,animation%20for%20the%20inserted%20cells)
- [https://stackoverflow.com/questions/73242482/uicollectionview-snapshot-takes-too-long-to-re-apply#:~:text=Using%20,rows%20by%20making%20this%20change](https://stackoverflow.com/questions/73242482/uicollectionview-snapshot-takes-too-long-to-re-apply#:~:text=Using%20,rows%20by%20making%20this%20change)

###  Diff 연산 비용과 UI 업데이트 부담

diff 알고리즘은 `O(n)` 선형 복잡도를 가지지만, 변경 항목 수가 많아질수록 UI 업데이트 및 셀 재생성 비용이 누적된다. 따라서, 필요한 경우 데이터 페이징이나 배치 처리를 통해 한 번에 처리하는 아이템 수를 제한하는 전략이 좋겠다.

### 실제 개발 환경에서의 성능 분석 중요성

Instruments 및 개발자 커뮤니티의 사례를 통해 성능 테스트의 중요성을 재확인하였으며, 애니메이션 옵션 선택이 UX와 성능 사이의 트레이드오프임을 명확히 인지하게 되었다.

# 느낀점

- diffable data source의 내부 동작과 애니메이션 옵션에 따른 성능 차이를 명확하게 이해할 수 있었음.
- 상황에 맞는 최적의 업데이트 전략 수립의 중요성을 재확인하며, 실제 테스트 및 포럼 사례가 큰 도움이 됨.
- 데이터 양과 업데이트 방식에 따라 성능 최적화를 위해 애니메이션 사용 여부를 신중하게 선택해야 한다는 점을 깨달음

---

# 참고 링크

- [ChatGPT - apply animatingDifferences 성능 차이 분석](https://hackmd.io/@OsPD18twQM2Jv-q7O5bkWQ/rkBYnu0qyx)
- [Apple 개발자 문서 및 WWDC 영상](https://developer.apple.com/videos/play/wwdc2021/10252/#:~:text=changes%2C%20its%20representation%20in%20diffable,First%2C%20let%27s)
- [StackOverflow: diffable data source diff 계산 관련](https://stackoverflow.com/questions/67996442/why-dispatchqueue-main-async-is-required-when-using-coredata-nsfetchedresultsco#:~:text=,method%20exclusively%20from%20the%20main)
- [StackOverflow: UICollectionView 스냅샷 성능 이슈](https://stackoverflow.com/questions/73242482/uicollectionview-snapshot-takes-too-long-to-re-apply#:~:text=Using%20,rows%20by%20making%20this%20change)
- [Jesse Squires 블로그: diffable data source 최적화](https://www.jessesquires.com/blog/2024/12/19/diffable-data-source-main-actor-inconsistency/#:~:text=involved%20in%20creating%20cells%2C%20measuring,number%20of%20items%20populated%20in)
- [Apple Developer Forums](https://forums.developer.apple.com/forums/thread/706349#:~:text=Generally%20speaking%2C%20when%20you%20are,animation%20for%20the%20inserted%20cells)
