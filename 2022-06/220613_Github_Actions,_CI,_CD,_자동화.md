# 220613 Github Actions, CI, CD, 자동화

# TIL (Today I Learned)

6월 13일 (월)

## 학습 내용

- Github Actions로 자동화된 작업을 진행할 수 있도록 만들어보기

&nbsp;

## 고민한 점 / 해결 방법

> 요즘 Toss에서 개발자 컨퍼런스가 올라와서 관심있게 보고있는데, 그 중 자동화 언급이 되었던 부분을 내 개인 프로젝트에서도 한번 적용해보면 재밌겠다 싶어서 빌드 및 테스트를 자동화하는 방법을 찾아보았다.

**[Github Action]**

소프트웨어 개발 라이프 사이클안에서 PR, Push 등의 이벤트 발생에 따라 자동화된 작업을 진행할 수 있게 해주는 기능이다.

이런 자동화된 작업이 필요한 경우는 어떤 것들이 존재하는지 알아보자.

1. `CI/CD`
    * Github Actions을 활용하는 가장 대표적인 예시 중 하나
    * 로컬 레포지토리에서 원격 레포지토리로 푸쉬하고 난 후, Github Actions에서는 이벤트 발생에 따라 자동으로 빌드 및 배포하는 스크립트를 실행시켜주는 것
    * 애플리케이션의 규모가 클 수록 빌드, 배포 시간이 오래걸리는데 이를 자동화 시켜놓으면 해당 시간을 낭비하지 않을 수 있다.
2. `Testing`
    * 팀 프로젝트를 진행하다가 PR를 보내면 자동으로 테스트를 진행하는 것 또한 Github Actions으로 구현할 수 있다.
    * 테스트 성공 여부에 따라서 자동으로 PR을 Open 및 Close를 할 수 있다.
3. `Cron Job`
    * Github Actions를 통해 특정 시간대에 스크립트를 반복 실행하도록 구현할 수 있다.
    * 매일 특정 시간이 되면 크롤링 작업을 진행한다는 등의 예시가 존재한다.

## Github Actions의 구성 요소

* `Workflow`
    * 레파지토리에 추가할 수 있는 일련의 자동화된 커맨드 집합이다.
    * 하나 이상의 job으로 구성되어 있으며, push나 PR 같은 이벤트에 의해 실행될 수도 있고 특정 시간대에 실행될 수도 있다.
    * 빌드, 테스트, 배포 등 각각의 역할에 맞는 workflow를 추가할 수 있고, `.github/workflows` 디렉토리에 .yml 형태로 저장한다.
* `Event`
    * Workflow를 실행시키는 push, PR, commit 등의 특정 행동을 의미한다.
    * 위 특정 행동이 아닌, [Repository Dispatch Webhook](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)을 사용하면 Github 외부에서 발생한 이벤트에 의해서도 workflow를 실행시킬 수 있다.
    * 이벤트의 종류는 [Github Actions 공식문서](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)에서 확인 가능하다.
* `Job`
    * 동일한 Runner에서 실행되는 여러 Step의 집합을 의미한다.
    * 기본적으로 하나의 workflow 내의 여러 job은 독립적으로 실행되지만 필요에 따라 의존 관계를 설정하여 순서를 지정해줄 수 있다.
    * 예시로 테스트를 수행하는 Job과 빌드 작업을 수행하는 Job이 하나의 workflow에 존재한다고 생각해보면 여기서 테스트 job은 반드시 빌드 job 이후에 수행되어야 하는데, 여기서 의존관계를 설정해 빌드 job이 성공적으로 끝나야 테스트 job을 수행할 수 있도록 지정할 수 있다.
        * 따라서 만약 빌드가 실패할 시에는 테스트 job도 실행되지 않는다.
* `Step`
    * Github Actions workflow 내에 있는 Job을 실행시키기 위한 어플리케이션.
    * Runner Application은 Github에서 호스팅하는 가상 환경 또는 직접 호스팅하는 가상환경에서 실행가능하며, Github에서 호스팅하는 가상 인스턴스의 겅우 메모리 및 용량 제한이 존재한다.

## Github에서 제공하는 yml 템플릿

```yaml
# Repository의 Actions 탭에 나타날 Workflow 이름으로 필수 옵션은 아닙니다.
name: CI

# Workflow를 실행시키기 위한 Event 목록입니다.
on:
  # 하단 코드에 따라 develop 브랜치에 Push 또는 Pull Request 이벤트가 발생한 경우에 Workflow가 실행됩니다.
  # 만약 브랜치 구분 없이 이벤트를 지정하고 싶을 경우에는 단순히 아래와 같이 작성도 가능합니다.
  # on: [push, pull_request]
  push:
    branches: [develop]
  pull_request:
    branches: [develop]

  # 해당 옵션을 통해 사용자가 직접 Actions 탭에서 Workflow를 실행시킬 수 있습니다.
  # 여기에서는 추가적으로 더 설명하지는 않겠습니다.
  workflow_dispatch:

# 해당 Workflow의 하나 이상의 Job 목록입니다.
jobs:
  # Job 이름으로, build라는 이름으로 Job이 표시됩니다.
  build:
    # Runner가 실행되는 환경을 정의하는 부분입니다.
    runs-on: ubuntu-latest

    # build Job 내의 step 목록입니다.
    steps:
      # uses 키워드를 통해 Action을 불러올 수 있습니다.
      # 여기에서는 해당 레포지토리로 check-out하여 레포지토리에 접근할 수 있는 Action을 불러왔습니다.
      - uses: actions/checkout@v2

      # 여기서 실행되는 커맨드에 대한 설명으로, Workflow에 표시됩니다.
      - name: Run a one-line script
        run: echo Hello, world!

      # 이렇게 하나의 커맨드가 아닌 여러 커맨드도 실행 가능합니다.
      - name: Run a multi-line script
        run: |
          echo Add other actions to build,
          echo test, and deploy your project.
```

#

**[빌드 및 테스트를 자동화하는 workflow를 등록하는 방법]**

![](https://i.imgur.com/bstRdNW.png)

* 먼저 내 레파지토리에 들어가서 Actions 탭에 들어가 `New workflow` 버튼을 클릭!

![](https://i.imgur.com/Qe6Pr4b.png)

* `Set up a workflow youself`를 누르면 템플릿이 적용된 yml 파일을 생성할 수 있다.

```yaml
# name을 테스트 실행으로 바꾸어주었다.
name: Run Test 

on:
  # develop 브랜치에 push 나 pull request 이벤트가 일어났을때 해당 workflow 를 trigger
  push:
    branches: [ "develop" ]
  pull_request:
    branches: [ "develop" ]

  workflow_dispatch:

# workflow의 실행은 하나 이상의 job으로 구성 됨
jobs:
  # # 이 workflow 는 "build" 라는 single job 으로 구성
  build:
    # # job이 실행될 환경 - 최신 mac os
    runs-on: macos-latest

    # Steps은 job의 일부로 실행될 일련의 task들을 나타냄
    steps:
      # uses 키워드를 통해 Github Actions에서 기본으로 제공하는 액션을 사용 가능. 아래 액션은 repository 에 체크아웃하는 것
      - uses: actions/checkout@v3

      # shell 이용해서 하나의 command 수행
      - name: Start xcode build 🛠
        run: |
          xcodebuild clean test -project Animal-Crossing-Wiki/Animal-Crossing-Wiki.xcodeproj -scheme Animal-Crossing-Wiki -destination 'platform=iOS Simulator,name=iPhone 13 Pro,OS=15.2'
```

마지막으로 작성된 run 부분은 `xcodebulid command`를 사용한 것인데 좀 더 자세히 살펴보자 !

* `Xcodebulid command`란?
    * Xcode 프로젝트 및 workspace의 build, query, analyze, test, archive 작업을 수행할 수 있는 command를 뜻한다.
    * 사용할 수 있는 다양한 action 및 option은 man page(`x-man-page://xcodebuild`) 에서 확인 가능하다.

> 크롬 주소창에 `x-man-page://xcodebuild`을 입력하면 해당 창이 나타난다.

![](https://i.imgur.com/iipkyu0.png)

* 위에서 사용한 Action
    * `clean`
        * build products 및 intermediate 파일을 build root(SINROOT)에서 제거
    * `test`
        * build root(SINROOT)에서 scheme을 테스트(빌드가 성공적으로 진행된 후에 테스트가 진행됨). scheme와 destination 지정이 필요하다.

Option을 하나씩 살펴보자.

1. 우선 액션(clean, test) 뒤에 `-project`라는 플래그 뒤에 `.xcodeproj` 파일명을 확장자까지 입력한다. (경로 주의)
    * `xcodebuild clean test -project Animal-Crossing-Wiki/Animal-Crossing-Wiki.xcodeproj`
2. 스킴 설정을 위해 `-sche`me 플래그와 함께 빌드하고자 하는 scheme을 명시해준다.
    * `-scheme Animal-Crossing-Wiki`
3. `-destination` 플래그를 사용하여 빌드시 사용할 플랫폼, 기기명, iOS 버전을 명시해준다.
    * `-destination 'platform=iOS Simulator,name=iPhone 13 Pro,OS=15.2'`

> 풀로 설정된 명령어

```
xcodebuild clean test -project Animal-Crossing-Wiki/Animal-Crossing-Wiki.xcodeproj -scheme Animal-Crossing-Wiki -destination 'platform=iOS Simulator,name=iPhone 13 Pro,OS=15.2'
```

이렇게 .yml파일을 설정해주고, develop 브랜치에서 push를 하게 되면, 아까 Actions 탭에 작성해두었던 workflow가 트리거 되어 실행된다.

![](https://i.imgur.com/9d77sXy.png)

> 사진에서 보면 'Run Test'라는 이름이 yml 파일에서 가장 상위에 name: Run Test로 작성해줬던 값과 동일한 것을 확인할 수 있다.




---

- 참고링크
    - https://ji5485.github.io/post/2021-06-06/build-ci-cd-pipeline-using-github-actions/
    - https://sujinnaljin.medium.com/ci-cd-github-actions-%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-xcode-build-test-%EC%9E%90%EB%8F%99%ED%99%94-73b90a3dcc65

