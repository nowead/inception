# Inception (42서울 프로젝트)

이 프로젝트는 42서울 커리큘럼의 일부로, **Docker** 와 **Docker Compose** 를 활용한 컨테이너 오케스트레이션의 기초를 배우는 것을 목표로 합니다. 여러 개의 서비스를 각각의 컨테이너로 구성하고, 이들이 유기적으로 연결되어 작동하도록 구성해야 합니다.

## 프로젝트 이름의 유래

이 프로젝트의 이름이 `Inception`인 이유는 다음과 같습니다:

- **VirtualBox**를 이용해 하나의 가상환경(Linux)을 생성하고,
- 그 안에서 다시 Docker를 통해 또 다른 가상환경(Container)을 구성합니다.

이는 영화 *Inception*에서 꿈 안의 꿈을 꾸는 구조와 유사하기 때문에, 중첩된 가상화 구조를 경험한다는 의미에서 이름이 붙었습니다.  
이러한 구조를 통해 우리는 **하이퍼바이저 기반 가상환경(Virtual Machine)** 과 **컨테이너 기반 가상환경(Docker)** 의 차이점을 학습할 수 있습니다.

## 프로젝트 구조

```
inception/
├── Makefile
├── docker-compose.yml
└── srcs/
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── conf/
        │       └── nginx.conf
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── tools/
        │   │   └── init_wordpress.sh
        │   └── conf/
        │       └── www.conf
        └── mariadb/
            ├── Dockerfile
            ├── .dockerignore
            └── tools/
                └── script.sh
```

## 서비스 구성

다음의 서비스를 각각 독립된 컨테이너로 구성합니다:

- **Nginx** – HTTPS를 지원하는 리버스 프록시 서버
- **WordPress** – PHP 기반의 웹 애플리케이션
- **MariaDB** – WordPress용 데이터베이스

각 서비스는 독립된 Dockerfile을 가지고 있어야 하며, `docker-compose`를 사용하여 전체 서비스를 실행합니다.

## 보안 및 요구사항

- **TLS (SSL)**: Nginx는 HTTPS를 지원하며, 자체 서명된 인증서를 사용합니다.
- **볼륨**: 데이터의 지속성을 위해 MariaDB와 WordPress는 Docker 볼륨을 사용합니다.

## 사용 방법

전체 서비스를 빌드하고 실행하려면:

```bash
make
```

모든 컨테이너, 볼륨, 네트워크를 중단 및 삭제하려면:

```bash
make down
```

## 프로젝트 체크리스트

- [x] 각 서비스가 독립된 컨테이너로 실행됨
- [x] NGINX가 유일한 진입점이며 SSL 지원
- [x] WordPress가 NGINX를 통해 접근 가능하고 설정 완료됨
- [x] MariaDB가 WordPress와 연결되고 데이터가 영구적으로 저장됨
- [x] 루트 권한으로 실행되는 컨테이너 없음

## 사용되는 볼륨

- `/var/lib/mysql` – MariaDB 데이터
- `/var/www/html` – WordPress 파일

## 추가 정보

- 설정 파일(`nginx.conf`, `www.conf` 등)은 직접 작성한 커스텀 설정입니다.
- 모든 Dockerfile은 직접 작성했으며, 최적의 보안과 관리가 반영되어 있습니다.
- 기본 이미지를 제외하고, 사전 빌드된 컨테이너 이미지를 사용하지 않습니다.

