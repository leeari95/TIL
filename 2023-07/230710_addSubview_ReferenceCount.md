# 230710 addSubview, Reference Count
# TIL (Today I Learned)


7월 10일 (월)

## 학습 내용
- addSubview 시 참조 카운트에 대한 것

&nbsp;

## 고민한 점 / 해결 방법

> 메모리 누수가 있어 문제를 해결하다가... 프로퍼티로 선언된 뷰를 addSubview를 하게 된다면 Reference가 어떻게 카운트 되는지 갑자기 궁금해져서 더 자세히 알고 싶었다.

</br>

공식문서를 살펴보면...

![image](https://github.com/leeari95/TIL/assets/75905803/4602d6e6-7981-47e7-88d1-11a4a46f73ff)

> addSubview로 추가한 뷰를 강한 참조로 카운트 된다고 설명하고 있다.

</br>

그렇다면 평소에 뷰를 프로퍼티로 선언할 때, 약한 참조로 설정해야할 때는 어떤 경우일까?

찾아보니 아래와 같은 경우라면 `weak`로 선언하는 것이 좋다고 대부분 이야기한다.

* 뷰가 런타임에 사라질 수 있는 경우

반대로 뷰가 항상 view hierarchy에 존재한다면 strong으로 선언해도 아무 상관이 없다는 뜻이다.
superView가 메모리에서 해제되면 subView도 메모리에서 해제되기 때문이다.

하지만 ViewController의 view에 addSubview를 하고, 런타임 때 subView를 removeFromSuperView() 메소드를 호출하여 화면에서도 제거하고 메모리에서도 제거하고 싶다면 `weak`로 선언해야 한다.
</br>

그 이유는, ViewController의 view는 뷰 컨트롤러가 메모리에서 해제될 때 같이 해제되기 때문이다.
즉, view가 런타임 때 해제되지 않는다면 그 하위뷰도 ViewController에서 강한 참조로 유지되고 있기 때문에 removeFromSuperView()를 호출해도 화면에서만 사라지고 메모리는 해제되지 않는다.
</br>

이러한 이유로 프로퍼티로 뷰를 선언할 때 weak로 선언하는 것을 대부분 선호하는 것 같다.
weak로 선언해두면 removeFromSuperView()를 호출했을 때 더이상 참조카운트가 존재하지 않기 때문에 subView가 스스로 메모리에서 해제될 수 있게 된다.

정리하자면...

* ViewController 내부에 뷰를 선언할 때 강한 참조든, 약한 참조든 상관없다.
* 강한 참조, 약한 참조로 선언하는 것에 대한 차이점은 해당 뷰가 스스로 메모리에서 해제될 수 있느냐 없느냐가 포인트다.
* 따라서 view hierarchy에 아예 사라지는 시점이 존재한다면 weak로 선언해주는 것이 자연스럽다.
    * 사라지는 시점에 바로 메모리가 해제되기 때문이다.
* 하지만 일시적으로 view hierarchy에서 사라지는 경우라면 strong으로 참조를 유지해주는 것이 좋다.
    * 사라졌다가 다시 보여져야하기 때문이다.
    * 하지만 보통은... 이런 경우에는 removeFromSuperView()를 호출하는 것보다 alpha를 조정하여 구현하는 것이 일반적이다.
    * 성능적으로 차이가 있어서 이 방법을 더 선호하는 것으로 알려져있는데... 자세히 모르겠네. 나중에 더 자세히 파보는 걸로...🙄

#

내가 경험했던 메모리 누수는 아래와 같은 상황이였다.

* 파라미터로 부모뷰를 전달 받아 addSubview를 호출하는 메소드가 구현되어있는 커스텀 뷰.
* 전달받은 부모뷰를 커스텀 뷰 내부 `parentView`라는 프로퍼티에 할당하는 작업이 존재.
* 예를 들어 parentView에 ViewController의 view가 전달된다면, addSubview로 1번, parentView로 1번 총 참조카운트가 2번 발생되는 것이다.
    * 이때 parentView 프로퍼티에 할당할 때 해당 프로퍼티는 강한 참조로 선언되어 있다.
* 따라서 view가 화면에서 사라져도 참조 카운트는 남아있어서 메모리 누수가 발생했다.
    * ViewController가 deinit되면서 view도 deinit 되어야하는데, customView에서 parentView로 강한 참조를 하고 있어서 deinit이 되지 않음.

그래서 해당 문제는 parentView라는 프로퍼티를 weak로 선언하여 참조 카운팅이 되지 않도록 하여 문제를 해결하게 되었다.


---

- 참고링크
    - https://developer.apple.com/documentation/uikit/uiview/1622616-addsubview
    - https://developer.apple.com/forums/thread/15082
