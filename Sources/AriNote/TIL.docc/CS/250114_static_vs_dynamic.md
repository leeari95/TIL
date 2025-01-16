# 250114 static vs dynamic

모듈화를 진행할 때 각 모듈의 프레임워크는 어떤 기준으로 선택해야할까?

1월 14일 (화)

# 학습내용

- 각 프레임워크를 선택하는 기준이 뭘까?
- 각 기준의 기술적인 배경과 이유를 알아보자

# 고민한 점 / 해결방법

## 어떤 기준으로 정적 또는 동적을 선택해야할까?

* 앱 초기 로드 시간이 중요하다 → static
* 독립적인 업데이트와 배포가 필요하다 → dynamic
* 앱 크기 관리가 중요하다 → dynamic
* 빌드 시간을 줄이고 싶다 → dynamic
* 모든 코드가 하나로 통합되어야 한다 → static


### 앱 초기 로드 시간 → static

* 정적 프레임워크:
  * 정적 프레임워크는 빌드 시점에 앱의 실행 바이너리에 병합되므로, 앱 실행 시 라이브러리를 메모리에 로드하는 추가 작업이 필요 없어서 빠름.
  * iOS 런타임은 Mach-O 형식의 실행 파일을 로드할 때, 정적 프레임워크는 이미 포함되어 있기 때문에 별도의 작업이 줄어듦.
* 동적 프레임워크:
  * 런타임에 .dylib 파일을 로드하기 위해 Dynamic Linker가 추가적으로 작업을 수행해야 함.
  * 특히, 런타임에 프레임워크의 의존성 그래프를 분석하고 심볼 테이블을 매핑하는 과정이 앱 초기 로드 시간을 늘릴 수 있음.
* 기술적 근거:
  * iOS 앱의 로드 단계에서 dyld(Dynamic Link Editor)가 동적으로 링크된 모든 프레임워크를 메모리에 로드하고 심볼을 연결함. 이 과정이 많아지면 초기화 시간이 길어짐.

### 앱의 크기 → dynamic

* 정적 프레임워크:
  * 정적 프레임워크는 앱 바이너리에 필요한 코드만 포함하지만, 서로 다른 앱에서 중복되는 코드가 포함될 가능성이 있음.
  * 예를 들어, 여러 앱에서 같은 정적 프레임워크를 사용하면, 해당 코드는 각 앱의 바이너리에 모두 복사됨.
* 동적 프레임워크:
  * 동적 프레임워크는 .dylib 파일 형태로 외부에 존재하므로, 공유 가능(ex: App Extension에서 동일 프레임워크 사용 가능).
  * 앱이 동일한 동적 프레임워크를 여러 개 사용하는 경우에도 중복 없이 하나의 프레임워크만 저장됨.
* 기술적 근거:
  * 동적 프레임워크는 Mach-O 파일의 LC_LOAD_DYLIB 헤더에 의해 외부에서 로드되며, 바이너리 자체 크기를 줄이는 데 기여함.

### 코드 및 모듈 업데이트 → dynamic

* 정적 프레임워크:
    * 빌드 시 모든 코드가 앱 바이너리에 병합되므로, 특정 모듈의 업데이트를 위해선 앱 전체를 다시 빌드하고 배포해야 함.
    * 특정 모듈만 변경하는 것이 불가능.
* 동적 프레임워크:
    * 프레임워크는 별도로 컴파일되어 있으므로, 특정 모듈만 수정 후 다시 배포 가능.
    * 예를 들어, 프레임워크를 CocoaPods, Carthage, SPM 등을 통해 관리한다면, 모듈만 교체해 업데이트가 가능.
* 기술적 근거:
    * 동적 프레임워크는 런타임에 외부에서 로드되므로, 앱과 독립적으로 수정하거나 배포가 가능. 이는 모듈화의 진정한 이점을 활용하는 방식임.

### 빌드 및 링크 시간 → dynamic

* 정적 프레임워크:
    * 모든 코드를 정적으로 병합하기 때문에, 빌드 시 컴파일러와 링커가 더 많은 작업을 수행해야 함.
    * 큰 프로젝트일수록 정적 프레임워크의 빌드 시간이 더 오래 걸릴 수 있음.
* 동적 프레임워크:
    * 동적 프레임워크는 컴파일 시점에는 독립적인 바이너리로 유지되므로, 앱과 링크되는 과정이 간단.
    * 빌드 시간이 상대적으로 짧아질 수 있음.
* 기술적 근거:
    * 정적 프레임워크는 최종 바이너리에 포함되어야 하므로 컴파일러가 추가적인 최적화 작업(LTO, Link Time Optimization)을 수행. 동적 프레임워크는 이 작업이 생략됨.

### 팀과 프로젝트 구조 → dynamic

* 정적 프레임워크:
    * 모든 코드가 하나로 통합되므로, 특정 팀이나 모듈 단위의 독립적인 작업이 어렵고, 코드 변경이 전체 프로젝트에 영향을 미침.
* 동적 프레임워크:
    * 동적 프레임워크는 독립적으로 관리 가능하므로, 여러 팀이 협업하기에 더 적합.
    * 특정 모듈을 서드파티 라이브러리처럼 관리하면서, 프로젝트 전체와 독립적인 워크플로우를 가질 수 있음.
* 기술적 근거:
    * 동적 프레임워크는 Encapsulation(캡슐화)이 뛰어나며, 프로젝트의 결합도를 낮추는 데 기여함. 이는 모듈화를 진행하는 주된 이유 중 하나.

### 성능 → static

* 정적 프레임워크:
    * 앱의 모든 코드가 바이너리에 포함되므로, 실행 시점의 메모리 접근이나 호출이 빠름.
    * 런타임 로드나 심볼 테이블 관리가 필요 없기 때문에 실행 성능이 안정적.

* 동적 프레임워크:
    * 런타임에 로드 및 심볼 테이블 매핑 과정이 포함되므로, 미세하지만 추가적인 오버헤드가 발생.
    * 일반적으로 앱 성능에는 큰 영향을 주지 않지만, 성능에 민감한 부분에서는 차이가 날 수 있음.

* 기술적 근거:
    * 런타임 링크의 오버헤드는 심볼을 메모리 주소에 매핑하는 과정에서 발생. 특히 iOS 환경에서는 dyld가 이러한 작업을 수행하며, 작업량이 많아질수록 영향을 줄 수 있음.

## 결론

인터페이스 모듈을 동적 프레임워크로 만들고, 구현체 모듈을 정적 프레임워크로 만들어서 모듈화의 장점과 성능 최적화를 모두 얻어보자.

### 1. 공통 유틸리티 코드 분리

여러 동적 프레임워크에서 사용하는 공통 유틸리티(예: 네트워크 처리, 데이터 파싱)를 정적 프레임워크로 분리해 동적 프레임워크에 포함.

### 2. 보안 및 내부 의존성 캡슐화

외부에 노출되면 안 되는 코드(예: 내부 API, 보안 로직 등)를 정적 프레임워크로 만들어 동적 프레임워크 내부에 캡슐화.

### 3. 앱 크기 최적화

정적 프레임워크를 내부에 포함해 중복 코드를 제거하고, 여러 앱이나 Extension에서 공유 가능한 동적 프레임워크로 관리.

### 4. 독립 배포 필요

자주 변경되거나 독립적으로 관리해야 하는 기능을 동적 프레임워크로 만들고, 그 내부에 성능 최적화가 필요한 코드를 정적 프레임워크로 포함.

---

# 참고 링크

- [https://bamtori.tistory.com/180](https://bamtori.tistory.com/180)