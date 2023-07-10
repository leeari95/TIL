# 220711 ARC, dismiss, popViewController, memory leak

# TIL (Today I Learned)

7월 11일 (월)

## 학습 내용

- ViewController를 `dismiss`, 혹은 `popViewController` 했을 때, 메모리 할당이 해제 되지 않는 이유가 뭘까?

&nbsp;

## 고민한 점 / 해결 방법

> 개인 프로젝트를 하던 와중에 Coordinator 패턴을 활용하여 화면 제어를 하고 있었다. 그러다가 간혹 dismiss, popViewController를 시도하면 해당 뷰 컨트롤러가 메모리에서 사라져야 하는데, 죽지않고 살아남아있는 경우가 발생하는 걸 발견해버렸다. 이를 해결하려고 방법을 찾아보았다.

![](https://i.imgur.com/gar9H4P.gif)

* `첫번째 시도`
    * 뷰가 사라질 때 ViewController가 가지고 있는 ViewModel을 nil처리를 해주어보았다.
    * 하지만 효과는 없었다. 이 문제가 아닌 것 같았다.
* `두번째 시도`
    * 방법을 모색하던 와중에, 해당 내용에 대한 stackoverflow 질문 글을 찾게 되었다.
    * 뷰 컨트롤러를 닫거나, 팝할 때 강력한 참조를 만들지 않은 경우에만 할당이 해제된다는 답변이 있었다.

따라서 [이 답변](https://stackoverflow.com/a/21621174/19072322)을 참고하여, 문제가 발생하는 뷰 컨트롤러에 강한 참조를 하고 있는 부분이 있나 체크를 해보았다.

> 위에서 말했던 문제가 발생하던 뷰 컨트롤러의 수가 적지 않았다. 살펴보니 대부분 바인딩 처리해주는 부분에서 옵저버블을 구독하는 시점에 self를 약한 참조로 사용하지 않고 강한 참조로 사용하던 부분 때문에 발생하던 문제였다. 

* `해결 방법`
    * 뷰 바인딩 처리해주는 부분에서, 혹은 ViewController 내부에서 self를 사용하는 구간을 모두 약한 참조를 하도록 바꾸어주었다.
    * 그리고 viewModel을 뷰 컨트롤러가 소유했던 방향을 `bind(to:)` 라는 메소드로 변경하여 `파라미터로 뷰모델을 전달받아 바인딩 처리`를 하도록 구조를 수정해주었다.

![](https://i.imgur.com/QFFaMwa.gif)


---

- 참고링크
    - https://stackoverflow.com/questions/21398934/why-arc-is-not-deallocating-memory-after-popviewcontroller

