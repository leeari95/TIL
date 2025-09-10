# 250910 pixel alignment issue

아이폰에서 특정 디바이스(iPhone 15 Plus)에서만 얇은 검은 선이 보이는 문제를 통해  
포인트와 픽셀, 픽셀 정렬, 안티앨리어싱 개념을 정리하고 원인을 분석했다.


9월 10일 (수)


# 학습내용

> 문제: 특정 디바이스에서 뷰의 너비가 소수점으로 계산되는 경우 안티앨리어싱 발생하는 문제.

안티앨리어싱이 발생하는 경우 디바이스 화면에 검은 실선이 보여지는 문제가 있다.

## 문제 현상 예시

![image](https://github.com/user-attachments/assets/bdf0aa06-c260-45d9-bbf0-a42cded2e6de)

### 1. 포인트(Point) vs 픽셀(Pixel)

- 픽셀: 화면을 이루는 가장 작은 네모 칸. 실제 디스플레이 물리 단위.
- 포인트: iOS 디자인/개발에서 쓰는 가상의 단위.
- 같은 앱이라도 iPhone 13(@3x), iPhone SE(@2x) 등 기기에 따라 픽셀 수가 다르지만, 포인트는 통일된 기준이라서 “100pt 버튼”은 모든 기기에서 같은 크기로 보인다.
- 예: iPhone 15 Plus는 @3x 기기라서 1pt = 3px.

### 2. 픽셀 정렬(Pixel Alignment)

- 화면에 요소를 배치할 때, 포인트 단위가 정확히 픽셀 배수로 떨어지는 것을 말한다.
- 예: 20pt → @3x에서는 60px → 픽셀 정렬 정확히 맞음 ✅
- 반대로 20.5pt → @3x에서는 61.5px → 픽셀이 반 칸에 걸려버림 ❌
- 픽셀 반 칸에 걸리면 화면이 흐릿하거나 얇은 선이 생길 수 있다.

### 3. 안티앨리어싱(Anti-aliasing)

- 픽셀 반 칸에 선이나 이미지가 걸리면, 픽셀을 온전히 칠할 수 없다.
- 이때 컴퓨터가 픽셀을 중간 색(회색/반투명 등) 으로 섞어 칠해 부드럽게 보이도록 보정하는 게 안티앨리어싱이다.
- 문제는, 원본 이미지 주변에 투명+검정 같은 픽셀이 있으면 이게 섞여서 검은 선처럼 보일 수 있다는 점이다.

### 4. 정리

- 포인트: 디자인/개발용 가상 단위 (기기에 상관없이 일정).
- 픽셀: 실제 화면 칸 (@2x, @3x로 확대됨).
- 픽셀 정렬: 포인트 값이 정수 배수로 맞아야 화면이 선명하게 나옴.
- 안티앨리어싱: 반 칸에 걸리면 보정이 들어가면서 원치 않는 색(검은 라인 등)이 섞여 보일 수 있음.

### 5. 포인트와 픽셀 배수 관계

- iOS 기기는 디스플레이 배율(@2x, @3x) 이 정해져 있다.
- 예를 들어 iPhone 15 Plus는 @3x → 1pt = 3px.
- 즉, 포인트 값 × 배율 = 실제 픽셀 수 가 정수로 떨어져야 화면에 정확히 표시된다.


> 👉 **요약**:
> - 포인트는 디자인 단위, 픽셀은 실제 화면 단위.  
> - `포인트 × 배율` 결과가 정수가 아니면 반 칸에 걸려서 안티앨리어싱이 발생.  
> - 이때 얇은 검은 선처럼 보일 수 있다.  


# 고민한 점 / 해결방법


- 왜 모든 기기에서 공통으로 발생하지 않고 일부 기기에서만 보이는가?  
  → 기기별 화면 폭, 마진 조합에 따라 남은 공간이 홀수/짝수로 갈리기 때문.
- 해결 방법  
  - 문제가 발생하는 뷰의 너비가 소수점으로 계산되면 올림 처리하여 정수 pt로 맞춤.
  → 예: 18.5pt → 19pt로 보정해 픽셀 정렬을 강제.


# 느낀점

- 레이아웃 계산 시 정수 보정을 습관화하는 것이 중요하다고 느꼈다. 


---


# 참고 링크


- [https://developer.apple.com/design/human-interface-guidelines/layout#display-scale](https://developer.apple.com/design/human-interface-guidelines/layout#display-scale)
- [https://xebia.com/blog/ios-pixel-misalignment-why-its-bad-how-to-fix-it/](https://xebia.com/blog/ios-pixel-misalignment-why-its-bad-how-to-fix-it/)
- [https://stackoverflow.com/questions/5832869/single-sub-pixel-misalignment-of-divs-on-ipad-and-iphone-safari](https://stackoverflow.com/questions/5832869/single-sub-pixel-misalignment-of-divs-on-ipad-and-iphone-safari)
