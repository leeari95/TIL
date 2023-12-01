# 231201 AVPlayer, waitingToPlayAtSpecifiedRate, evaluatingBufferingRate

12월 1일 (금)

## 학습 내용
- AVPlayer를 담은 셀을 재사용할 때, AVPlayerItem을 할당하여 재생하고 있는데, play()는 제대로 호출하고 있으나 waitingToPlayAtSpecifiedRate에서 playing으로 넘어가지 않고 무한 로딩이 걸리는 문제 해결

&nbsp;

## 고민한 점 / 해결 방법

> 비디오 스트리밍을 재생하는 셀이 컬렉션뷰 리로드를 할 때, 재생하던걸 멈추고 셀을 모두 리셋한 다음 다시 데이터가 설정되면서 비디오 스트리밍을 재생해야하는데, 몇개의 셀들이 간헐적으로 재생되지 않는 문제가 발생하여 이를 해결해보았다.

처음엔 비디오를 자동 재생을 하는 로직이나 재생하는 시점 로직에 문제가 생겨 사이드 이펙트가 일어나는 줄 알았다.
하지만 디버깅 해보니 로직에는 문제가 없었고 정상적으로 `AVPlayer의` `play()` 메소드는 제대로 호출되고 있었다.

그래서 AVPlayer의 `timeControlStatus`, `reasonForWaitingToPlay를` 관찰해보았다.
* `timeControlStatus가` `waitingToPlayAtSpecifiedRate`에서 `playing`으로 바뀌어야하는데, 간헐적으로 바뀌지 않고 계속 `waitingToPlayAtSpecifiedRate` 상태인 채로 멈춰서 재생을 하지 않는 것 같았다.
* 이때 `reasonForWaitingToPlay를` 추가로 관찰해보니 `evaluatingBufferingRate에서` 멈춰서 더이상 상태가 바뀌지 않았다.

그래서 구글링을 해보았는데... AVPlayer의 자체적인 버그인 것 같았다. 비슷한 현상을 겪는 stackoverflow 글들이 몇개가 존재했다.
  * ios avplayer indefinite waitingToPlayAtSpecifiedRate

그래서 `play()` 메소드를 호출하기 전에 아래와 같이 로직을 수정하였다.
  * `AVPlayerItem`을 다시 초기화한다.
  * `replaceCurrentItem(with:)` 메소드를 재호출시켜준다.

일단 문제되었던 무한로딩 현상은 사라졌지만, 간헐적인 현상이였던지라 이게 정확한 원인인지는 잘 파악이 되진 않는다.  
하지만 일단 오늘 테스트해보았을 때, 더이상 비디오가 재생되지 않는 현상은 사라져서 이걸로 마무리하기로 했다!

---

- 참고링크
    - https://stackoverflow.com/questions/36858988/avplayer-does-not-fire-playbackbufferempty-but-does-not-play-either
    - https://developer.apple.com/documentation/avfoundation/avplayer/timecontrolstatus/waitingtoplayatspecifiedrate
    - https://developer.apple.com/documentation/avfoundation/avplayer/waitingreason/1643489-evaluatingbufferingrate
