# 220307 High Performance Auto Layout, RxSwift, Single, DTO

# TIL (Today I Learned)
3월 7일 (월)

## 학습 내용

- Advanced Auto Layout 활동학습
- 프로젝트 매니저 코드리뷰
  - RxSwift - Single
  - DTO

&nbsp;

## 고민한 점 / 해결 방법

**[WWDC 2018 - High Performance Auto Layout]**

* Constraint를 추가할 때 어떤 일이 발생하는지 살펴보자
* 코드가 어떤 영향을 미칠지에 대한 감각을 얻기 위해 auto layout의 내부를 살펴보자

> 요약

* 오토 레이아웃은 Engine을 통하여 방정식을 계산하고 계산된 값을 통해 레이아웃을 업데이트 한다.
    * Engine은 layout cache이며, dependency tracker이다.
* 이러한 과정이 Render Loop 안에 속하며, Render Loop는 1초안에 150번 발생한다.
* 불필요한 deative, active를 하지말아야 한다. 그렇게 되면 엔진에서 계속 계산하고 없애고 계산하고를 반복하게 된다.
* 그러므로 유동적인 오토 레이아웃을 원한다면, 정적인 것과 동적인 것을 최대한 구분하여 정적인 것은 한번만 계산하고 최소한의 변경이 필요한 것만 업데이트 하도록 한다.
* removeFromsuperView보다 hide가 훨씬 싼 비용이 든다.
* intrinsic content size는 내부 요인을 계산하여 intrinsic content size를 계산하므로 intrinsic content size가 필요하지 않는 경우에는 override하여 성능을 향상할 수 있다.
* system layout fitting size는 오토 레이아웃 계산 결과가 끝난 후의 frame을 반환하는데, 이는 engine을 만들고 constriant를 계산하고 engine을 삭제하는 사이클로 형성된다. 자주 호출하면 이러한 것이 자주 발생하므로 주의해야 한다.

> Performance 요약
* 불필요한 consraint를 deallocate, allocate 하지마라
* constraint들이 관련이 덜할수록 선형적인 시간이 된다. 단순 방정식에 계산할 뿐이다.
* Engine은 layout cache 이고, dependency tracker이다

### Constraint churn 피하기

* 모든 Constraint를 삭제하는 것을 피한다.
* 정적인 고정적인 constraint는 한번만 생성한다.
* 변화가 필요한 constraint만 변경한다.
* View를 remove하지말고 hide하도록 하라 (물론 없어져도 다른 View에게 영향을 주지 않는 경우)

### Intrinsic Content Size

* 모든 뷰들이 갖고있는 것은 아니다.
* UIImage, UILabel 같은 경우는 가지고 있다.
* UIView는 이것을 사용하여 constraint를 만들어 낸다.
    * UILable은 내부의 텍스트들을 고려하여 intrinsic content size를 만들어낸다.
* 때로는 intrinsic content size를 overriden 하는게 좋을 수 있다.
    * 이렇게 되면 intrinsic content size를 이미 정해놨기 때문에 따로 text measurement 하지 않는 장점이 있다.
    * 즉 intrinisic content size가 필요하지 않는 경우에 이렇게 사용하면 좋은 방법이 있다.

### Unsatisfiable constraint

* 해결책이 없고,연습이 많이 필요하고, 디버그를 잘해라.
* Mysteries of Auto Layout , Part 2 - wwdc 2015를 살펴봐라

---

**[RxSwift - Single]**

목적성이 있는 옵저버블

> 특징

- 옵저버블을 상태가 `onNext`, `onError`, `onCompleted` 등이 있는데, 애는 `success` , `error` 밖에없음
- 싱글은 이벤트를 한번 발행하면 끝임.
- 네트워크 쪽이나 코어데이터에 사용하기 적합하다.
- 레파지토리나 스토리지 단에서 싱글을 주로 활용함.

```swift
// create
func getRepo(_ repo: String) -> Single<[String: Any]> {
    return Single<[String: Any]>.create { single in
        let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/repos/\(repo)")!) { data, _, error in
            if let error = error {
                single(.error(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                  let result = json as? [String: Any] else {
                single(.error(DataError.cantParseJSON))
                return
            }

            single(.success(result))
        }

        task.resume()

        return Disposables.create { task.cancel() }
    }
}
```

```swift
// subscribe
getRepo("ReactiveX/RxSwift")
    .subscribe(onSuccess: { json in
                   print("JSON: ", json)
               },
               onError: { error in
                   print("Error: ", error)
               })
    .disposed(by: disposeBag)
```

---

**[DTO (Data Transfer Object)]**

- 데이터 전송을 위한 객체
- 데이터를 오브젝트로 변환하는 객체
- 같은 시스템에서 사용되는 것이 아닌 다른 시스템으로 전달하는 작업을 처리하는 객체
- 메소드 호출 횟수를 줄이기 위해 데이터를 담고 있는 것
- 로직을 가지지 않는 순수한 객체
- API에서 데이터를 받을때 받고싶은 구조대로 안올 수도 있는데, 다체적으로 원하는 형식으로 바꿀 수 있지만, 서버에서 내려주는대로 그냥 받고, 필요한 부분만 변환해서 따로 타입으로 만든다.

---

- 참고링크
    - https://vapor3965.tistory.com/20
