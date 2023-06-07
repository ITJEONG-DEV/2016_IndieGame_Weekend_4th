# 2016_IndieGame_Weekend_4th


## 맨홀의 저편

<p align="justify">
인디게임 위크엔드에서 `reboot`를 주제로 기획된 고전 RPG 게임

### 게임 개요
아주 오래 전에 개발되어 방치된 고전 게임 곳곳에서 오류가 발생하게 되었습니다. 이 오류들은 외관상으로 멀쩡해 보이는 부분들에까지 영향을 주게 됩니다. 이 영향을 주는 요소를 `reboot`라고 부릅니다. `reboot` 가 가득한 게임 맵을 무사히 빠져나가 보스를 잡는 것이 이 게임의 목표입니다. `reboot` 요소와 마주하게 되면, 자비 없이 처음으로 돌아가게 됩니다.

- 아래 사진의 흰 사각형 부분이 `reboot` 요소로, 실제 게임에서는 시각화되지 않음.

<img src="/.images/physics.png">

</p>


<br>

## 기술 스택

| CoronaSDK | lua |
| :--------: | :--------: |
|   <img src="/.images/coronasdk.png" width="200" height="180"/>   |   <img src="/.images/lua.png" width="200" height="200"/>    |

<br>

## 구현 화면


### 시작화면

<img src="/.images/title.png">

### 메뉴 선택 화면

<img src="/.images/menu.png">

### 스테이지 선택 화면

<img src="/.images/menu_2.png">

### 필드

<img src="/.images/field.png">
<img src="/.images/field_2.png">
<img src="/.images/ui.png">

<br>

## 배운 점

<p align="justify">
- 씬 이동과 리소스 관리
    - 씬 이동 관련 기능 및 라이프사이클에 대한 학습
    - 씬의 라이프사이클에 맞춘 리소스 생성, 삭제, 해체 시점 고민

- 프로젝트의 첫 빌드
    - 프로젝트단의 구현 및 확인 뿐만 아니라, 실제 플레이가 가능하도록 윈도우 빌드 진행해 봄

- 캐릭터 동작 구현
    - 캐릭터의 움직임 구현 (실제 이동 및 sprite 적용)
    - 캐릭터의 점프 구현
    - 캐릭터의 공격 구현 및 physics 적용
    - 별도의 패키지를 제공하지 않아 직접 고민하며 각각의 동작을 구현함

- 맵 배치&로드
    - 스테이지 방식으로 변경됨에 따라 맵 배치 파일의 규격을 정의하고, 로드하는 방식 고민해 봄

</p>

## 아쉬운 점
<p align="justify">
- 깃허브 사용 미숙
    - 깃허브 사용에 익숙하지 않아서 문제가 생기거나, 큰 수정사항이 생기면 무조건 프로젝트를 새로 파서 소스코드를 붙여넣기 했음

- 코드 분리 및 가독성 부분
    - 기능에 따른 모듈 분리에 익숙하지 않았고, 시간 제한이 있어 한 파일에 모든 소스코드를 작성하였음
    - 가독성이 많이 떨어지고 디버깅에 어려움이 있었음

- 기능 구현과 최적화가 동시에 이루어진 부분
    - 기능 구현이 우선인 상황에서 코드 최적화 방안이 떠오르면 무조건 적용하는 바람에 전체적인 완성도가 떨어졌음.
</p>

## 후기
<p align="justify">

- 모든 구현을 혼자서, 소스코드 작성으로만 진행하다 보니 특히 UI 요소 배치하는 부분에서 시간을 많이 소모했다.

- 코로나SDK와 lua는 정말 기초적인 프로젝트(프로젝트 생성, 간단한 물리 적용) 외에는 영문 자료가 대부분이고, 그마저도 얻을 수 있는 자료의 양이 적어 새로운 기능을 찾아보거나 적용할 때에 어려움이 많았다.

- 당시의 유니티 엔진에 비해 불편함이 크기도 하였는데, 그만큼 혼자서 구현을 위해 많은 부분에 대해 생각해볼 수 있어서 도움이 되었다.

- 완성도가 높지 않았지만, 3일의 시간동안 집중에서 어느정도 돌아가는 게임을 개발했다는 사실에 뿌듯함을 많이 느꼈다.

</p>


<br>

## 라이센스

MIT &copy; [NoHack](mailto:lbjp114@gmail.com)
