# GYPHY Search App
GYPHY 검색 API를 활용한 iOS GIF 이미지 검색 어플리케이션.

## Description
+ 최소 타겟 : iOS 14.0
+ CleanArchitecture + MVVM-C 패턴 적용
+ CoreData 프레임워크 사용으로 즐겨찾기 목록 유지
+ Storyboard를 활용하지 않고 코드로만 UI 구성
+ Pagination 구현
+ [개발 공수]()

## Feature
+ 이미지 검색 뷰
  + 카테고리별 검색 기능
  + 페이지네이션 - prefetching 방식
+ 디테일 뷰
  + 즐겨찾기 추가/제거
  + 액티비티 인디케이터
  + Data
  + 기기 내부 파일 저장
+ 스크랩 뷰
  + 스크랩 목록 관리
  + 스크랩 데이터 제거

## Getting Start
> Swift, MVVM+C, CI/CD, Unit Test, CoreData, SnapKit, Alamofire, Toast-swift, RxCocoa, RxSwift, RxTest

## Issue & Reflection

### 1. Coordinator, Router 구성

기존 프로젝트에서는 코디네이터만 구성하여 활용을 하였으나, 이를 라우터도 분리하여 역할을 분담해보고 싶었습니다. 코디네이터는 ViewController 인스턴스를 구성하고 present 되는 순서(flow)를 결정, 라우터는 실질적인 present / dismiss 실행하면서 화면 전환의 구성을 모듈별로 분리하여 각자의 책임을 가능하도록 구성하고 싶었습니다.

구성하면서 느낀 점은 현재와 같이 UITabBar만으로 구성된 단일한 상황에서는 modal 등 부모 코디네이터와 자식 코디네이터의 관계 등은 구상하지 않아도 되었기에 비교적 단순한 모양으로 구성되게 되었지만, 만약 이를 확장해서 화면 전환 flow가 복잡해진다면 해당 디자인 패턴을 활용하는 것이 더욱 더 좋은 방식으로 유지보수 할 수 있는 방법이라 생각합니다.

### 2. GIF Data Cache

GIF의 움직이는 프레임 기능 구현을 위해 git repo에 공개된 샘플 소스코드를 기반으로 적용했습니다. 그러나, 해당 코드에서는 데이터 캐싱을 따로 해주지 않아서 GIF 데이터 로딩이 끝난 데이터도 나중에 다시 확인하면 로딩을 또 기다려야했습니다. 또한, 다시 데이터를 받아오는 과정에 있어서 메모리의 사용과 함께 스크롤 버벅임도 상당히 심했습니다. 문제해결을 위해 해당 소스코드에 이미지 캐싱 기능을 넣어줬습니다. 이미지 캐싱 덕분에 최초에 새로운 GIF데이터를 호출할 때만 스크롤이 딜레이되고 이후에는 딜레이 현상이 없어졌습니다. 추가적으로 cellConfig에서 멀티쓰레딩을 해줌으로써 스크롤 딜레이를 개선했습니다.

작업을 통해 사용자 입장에서 해당 gif 이미지를 디바이스에 저장하는 기능을 구현하면서, 해당 이미지 로딩과 저장하는 로직에 있어서 딜레이가 발생하는 경우가 있었습니다. 이를 해결하기 위해서 해당 쓰레드를 조절하여 해결할 수 있었습니다.

### 3. Rx In/Out 형식의 ViewModel 구성 및 메서드 분리


### 4. 코어 데이터의 immutable 한 객체

### 5. 클린 아키텍쳐

### 6. Test Driving

## ScreenShot
![]()

## Video
