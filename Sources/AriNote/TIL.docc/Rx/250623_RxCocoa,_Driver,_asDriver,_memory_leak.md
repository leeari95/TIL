# 250623 RxCocoa, Driver, asDriver, memory leak

RxCocoa Driver의 내부 sharing 메커니즘으로 인한 메모리 누수 문제 해결

6월 23일 (월)

# 학습내용

- **RxCocoa Driver의 내부 동작 원리**
  - Driver는 내부적으로 `.share(replay: 1, scope: .whileConnected)` 사용
  - MainScheduler에서 실행되며 에러를 catch하는 편의 기능 제공
  - 성능 최적화를 위해 공유 Observable을 생성하여 중복 구독 방지

- **Driver의 메모리 누수 메커니즘**
  - 셀 재사용 시 `disposeBag = DisposeBag()` 호출로 개별 구독은 해제되지만
  - Driver의 공유 Observable(`.whileConnected`)은 모든 구독자가 해제될 때까지 유지
  - 빈번한 셀 생성/해제 환경에서는 구독자가 완전히 0이 되는 순간이 없어 누적됨

- **메모리 누수 증상**
  ```
  ShareReplay1WhileConnectedConnection<AVPlayerTimeControlStatus>
  CatchSink<ShareReplay1WhileConnectedConnection<AVPlayerTimeControlStatus>>
  AtomicInt (다수)
  KVOObserver (다수)
  ```

# 고민한 점 / 해결방법

- **문제 상황**
  - AVPlayer를 담고있는 셀들이 있는 페이지를 하단으로 스크롤 시 지속적인 메모리 누수 발생
  - 셀에서 AVPlayer의 timeControlStatus 구독 시 Driver 사용
  - 컬렉션뷰 셀의 빈번한 재사용으로 인한 메모리 누적

- **시도했던 해결 방법들**
  1. **AVPlayer+Rx.swift KVO 수정**: `observe()` → `observeWeakly()` → 이벤트 미발생
  2. **직접 KVO 구현**: `player.observe(\.timeControlStatus)` → 이벤트 미발생  
  3. **Observable.create로 래핑**: 복잡성 증가 및 효과 제한적

- **최종 해결방법**
  ```swift
  // 기존 문제 코드
  videoPlayer.rx.timeControlStatus
      .asDriver(onErrorJustReturn: .paused)  // 🚨 Driver의 내부 sharing
      .distinctUntilChanged()
      .drive(onNext: { ... })

  // 수정된 코드  
  videoPlayer.rx.timeControlStatus
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)  // 메인 스레드 보장
      .subscribe(onNext: { ... })
  ```

- **핵심 원리**
  - Driver 제거로 내부 sharing 메커니즘 회피
  - 각 셀마다 독립적인 KVO 구독 생성
  - `disposeBag = DisposeBag()` 시 완전한 구독 해제 보장

# 느낀점

- **RxCocoa의 편의성과 함정**
  - Driver, Signal 등의 편의 기능이 내부적으로 복잡한 sharing 메커니즘 사용
  - 대부분의 경우 성능 최적화에 도움이 되지만, 특정 상황에서는 오히려 독이 될 수 있음
  - 단순히 "편리하다"는 이유로 무분별하게 사용하면 안 됨

- **메모리 관리의 복잡성**
  - `disposeBag = DisposeBag()`만으로는 모든 메모리 누수가 해결되지 않음
  - RxSwift 내부 구현을 이해해야 근본적인 문제 해결 가능
  - Observable의 라이프사이클과 sharing 메커니즘에 대한 깊은 이해 필요

- **적절한 도구 선택의 중요성**
  - 컬렉션뷰 셀처럼 빈번한 생성/해제가 일어나는 환경에서는 Driver보다 일반 Observable이 적합
  - 상황에 맞는 도구 선택이 성능과 안정성에 직결됨
  - 코드의 "간결함"보다 "안정성"이 우선되어야 하는 경우가 있음

---

# 참고 링크

- [https://github.com/ReactiveX/RxSwift/blob/main/RxCocoa/Traits/Driver/Driver.swift](https://github.com/ReactiveX/RxSwift/blob/main/RxCocoa/Traits/Driver/Driver.swift)
- [https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Traits.md)