# 240813 WidgetKit, Timeline, TimelineReloadPolicy, TimelineProvider

위젯의 특성과 타임라인에 대해 공부해보자!


8월 13일 (화)


# 학습내용

## 왜 위젯의 EntryView에서 이미지를 비동기로 설정하는데 적용이 안될까?

위젯은 기본적으로 정적인 뷰다. 즉, 위젯이 한번 렌더링되면 사용자 상호작용이나 실시간 데이터 업데이트에 즉각적으로 반응할 수 없다는 것을 의미한다.
따라서 위젯은 'Timeline' 이라는 개념을 사용해서 콘텐츠를 업데이트 해야한다.
타임라인은 시간에 따른 위젯 상태의 스냅샷 시리즈를 의미한다. 각 스냅샷은 특정 시점에 어떻게 보여야 하는지를 나타낸다.

## 위젯을 네트워크 요청으로 구성하는 방법 (with Kingfisher)

위젯 내부에서는 직접적인 비동기 요청이 불가능하다. 따라서 네트워크를 통해 이미지나 데이터를 가져오는 작업은 타임라인을 생성할 때 수행해야 한다.

* `getTimeline(for:in:completion:)` 메소드 내에서 `ImagePrefetcher(resources:options:completionHandler:)`를 호출하여 이미지를 미리 다운받아 캐시에 이미지를 저장한다.

```swift
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    // 업데이트 날짜 설정...
    let resources: [Resource] = items.compactMap { $0.imageURL }
    ImagePrefetcher(resources: resources, options: [.cacheOriginalImage]) { _, _, _ in
        let entry = SampleEntry(date: Date(), items: items)
        let timeline = Timeline(entries: [entry], policy: /* 위에서 설정한 업데이트 설정...*/)

        // 이미지를 모두 다운로드 받은 후 timeline 생성을 마무리한다.
        completion(timeline)
    }.start()
}
```

* 이후 EntryView에서 캐시에 저장된 이미지를 가져와 사용할 수 있도록 아래와 같이 구조를 설정해준다.

```swift
struct SampleWidgetEntryView: View {
    // ...

    var source: Source? {
        guard let imageURL = item.imageURL else { return nil }
        return .network(imageURL)
    }
    
    var body: some View {
        // ...
        // 여기서 source를 통해 네트워크로 이미지를 요청하는데, 캐시에 이미 존재해서 즉시 이미지를 설정한다.
        KFImage(source: source)
            .placeholder {
                PlaceholderImage()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .resizable()
        // ...
    }
    // ...
}
```

네트워크로 이미지가 아닌 데이터가 필요한 경우, `getTimeline(for:in:completion:)` 메소드에서 네트워크 요청이 완료된 후 타임라인을 생성하도록 구조를 잡아주면 된다!

## 위젯의 업데이트 주기를 설정하는 방법 (TimelineReloadPolicy)

타임라인을 생성할 때 `policy`라는 파라미터에 업데이트 정책을 설정할 수가 있다.
정책 종류는 아래와 같다.

* `.atEnd` 
  * 마지막 Entry가 끝난 시점에 위젯이 더이상 업데이트 되지 않는다. 즉, 처음에 제공된 타임라인이 끝나면 더이상 자동으로 업데이트 하지 않는다. 
  * 콘텐츠가 오랫동안 변경할 필요가 없거나, 특정 이벤트가 끝날 때까지 같은 내용을 표시해야 하는 경우 유용하다.
  * 카운트 다운을 표시하는 위젯이나, 단일 이벤트 정보를 보여주는 위젯에 적합하다.
* `.after(Date)` 
  * 지정된 날짜 이후에 위젯이 자동으로 업데이트 되도록 설정한다. 설정한 날짜에 도달하면 시스템이 자동으로 위젯을 새로 고치기 위해 `getTimeline` 메소드를 다시 호출한다.
  * 위젯이 주기적으로 업데이트되어야 하거나, 특정 시간 간격으로 새로운 데이터를 가져와야 할 때 사용된다.
  * 날씨나 뉴스 헤드라인처럼 자주 갱신되는 정보를 제공하는 위젯에 적합하다.
* `.never` 
  * 타임라인을 갱신하지 않도록 설정한다. 위젯이 처음 표시된 후 자동으로 다시 업데이트되지 않는다.
  * 매우 정적인 정보를 표시하는 경우 유용하다.
  * 사용자에게 한번만 보여줘도 되는 설정이나, 도움말, 또는 이벤트 참여 후 바뀌지 않는 고정된 정보를 제공하는 위젯에 적합하다.

나는 .after(Date)를 사용해서 위젯 업데이트 주기를 설정하였는데, 정확하게 15분 간격으로 위젯을 업데이트하고 있지는 않은 것 같다. 이유가 궁금해서 찾아보았다:
* 위젯의 업데이트는 시스템이 정해진 `예산` 내에서 허용된다. 이 예산은 배터리와 성능 최적화를 위해 시스템에서 제한한다고 한다. ([공식문서](https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date#Plan-reloads-within-a-budget))
* 너무 자주 업데이트하면 시스템이 이를 제한할 수도 있다는 의미다.
* 따라서 이 점을 고려해 꼭 필요한 시기에 업데이트를 할 수 있도록 계획해야하며, 불필요한 업데이트를 피해야한다.

Apple에서 업데이트 주기 시간을 명시적으로 권장하고 있지는 않지만, 위젯의 업데이트 빈도는 배터리 소모와 성능을 고려하여 신중하게 설정해야 한다고 설명하고 있다.

공식문서에서는 일반적으로 15분에서 1시간 간격이 합리적인 업데이트 주기로 여겨진다는 내용이 있기는 하다.


## TimelineProvider의 주요 메서드 역할

* `placeholder(in:)` 
  * 데이터가 준비되지 않은 상태에서 기본 UI를 제공해주는 메소드로 로딩 상태를 사용자에게 보여준다.
  * 위젯이 실제 데이터를 받아오기 전에 잠시 보여줄 기본적인 콘텐츠를 생성하는 역할을 한다.
  * 주로 위젯이 로드되기 전, 데이터가 준비되지 않았을 때 사용자가 볼 수 있는 기본적인 UI를 정의한다.
  * Entry를 반환하도록 되어있지만, 해당 Entry를 활용하여 위젯의 뷰를 모두 설정한 후 스켈레톤 형태로 보여지게 된다.

> `placeholder(in:)`로 뷰가 세팅되었지만 데이터를 표시하지는 않는다. (아래 예시 사진)

![IMG_AC598843FA37-1](https://github.com/user-attachments/assets/63b90e91-f554-4396-bf85-833683911c8c)

* `getSnapshot(in:completion:)` 
  * 위젯이 미리보기 상태에서 표시할 콘텐츠를 제공한다. 
  * 일반적으로 가장 최근에 사용 가능한 데이터 또는 고정된 샘플 데이터를 사용하여 위젯의 모습이 어떻게 보일지 미리 보여준다.
* `getTimeline(in:completion:)` 
  * 이 메서드는 실제로 위젯이 사용자에게 표시될 데이터를 제공하고, 타임라인을 구성하는 역할을 한다.
  * 위젯이 주기적으로 갱신될 데이터 리스트, 타임라인을 생성하여 특정 시간대에 어떤 데이터가 표시될지를 정의한다.
  * 또한 다음 업데이트 시점을 설저하여 위젯이 언제 다시 데이터를 요청할지 결정한다.

---


# 참고 링크


- [https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date](https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date)
- [https://developer.apple.com/documentation/widgetkit/making-network-requests-in-a-widget-extension](https://developer.apple.com/documentation/widgetkit/making-network-requests-in-a-widget-extension)