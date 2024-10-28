# 241028 confirmationDialog, LazyVStack

LazyVStack 내부에 있는 뷰들이 confirmationDialog를 띄우지 못하는 현상

10월 28일 (월)

# 학습내용

- confirmationDialog을 LazyVStack 내부에서 사용할 경우 오동작 문제

# 고민한 점 / 해결방법

## 원인

> 사실 정확한 원인은 찾지 못했다...

* Lazy한 컨테이너가 뷰의 생명주기와 상태 변경을 최적화하기 위해 지연 로딩을 적용하는데, 문제와 관련이 있는 것으로 추측된다.
* Lazy 컨테이너는 스크롤할 때 뷰를 필요에 따라 생성하고 제거하면서 성능을 최적화하므로 confirmationDialog의 isPresented 상태 변화를 즉각적으로 반영하지 못하는 상황이 발생하는 것 같다.

정리하면, Lazy 컨테이너의 최적화가 뷰의 상태 변화를 즉시 반영하지 않도록 최적화된 설계로 인해 confirmationDialog의 isPresented 바인딩이 즉각 반영되지 않는 것 같다.

## 해결

### 1. Store에 shouldShowConfirmationDialog 라는 State 값을 만들어서 관리하기

* Store의 Action에 버튼 탭 이벤트를 두고 탭 이벤트에 따라 shouldShowConfirmationDialog에 값을 재할당시켜준다. (타입은 UUID)
* 그리고 뷰에서는 onChange를 통해 store.state.shouldShowConfirmationDialog를 추적하면서 값이 재할당 될 때마다 실제로 confirmationDialog를 띄울 때 사용하는 상태값을 toggle해주도록 한다.

이렇게 하면 버튼 이벤트가 발생했을 때 store에 관련 액션을 보내게 되고, shouldShowConfirmationDialog 값이 변경되면서 뷰에서 이를 감지하고 관련된 상태값을 변경하게 되면서 confirmationDialog를 띄우는 형태가 된다.

### 2. onChange 수정자 활용하기

* 이 방법은 단순히 onChange 수정자를 통해 confirmationDialog 수정자가 사용하고 있는 상태값을 추적하기만 하면 된다.
* 해결되는 이유를 추측해보자면, onChange를 통해 상태값 변화를 강제로 감지하게 되면서 뷰 트리가 해당 변화를 즉시 반영하도록 유도하는 것 같다.
* 따라서 Lazy 컨테이너가 지연 로딩으로 인해 상태 변화를 인식하지 못하는 문제를 보완해준다.

```swift
.onChange(of: showActionSheet) { _ in
    // Workaround: Lazy 컨테이너 내에서 lazy 로드된 View가 confirmationDialog의 isPresented 바인딩 값을 제대로 감지하지 못하는 문제가 있다.
    // 이 경우, onChange를 사용해 바인딩된 프로퍼티를 감지하도록 추가하면 정상적으로 동작함.
}
.confirmationDialog(item.shorts.title, isPresented: $showActionSheet, titleVisibility: .visible) {
```


---

# 참고 링크

- [https://stackoverflow.com/questions/74377118/swiftui-confirmationdialog-has-abnormal-behavior-when-inside-a-lazyvstack](https://stackoverflow.com/questions/74377118/swiftui-confirmationdialog-has-abnormal-behavior-when-inside-a-lazyvstack)