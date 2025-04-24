FROM jenkins/jenkins:lts 
# lts는 최신버전을 쓰겠다는 뜻
# 도커 파일을 써야 CI/CD 편해짐

USER root

# 리눅스 환경에서 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    curl unzip git wget gnupg2 \
    software-properties-common apt-transport-https \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 libxss1 \
    libappindicator1 libasound2 libatk-bridge2.0-0 libgtk-3-0 \
    xvfb chromium chromium-driver \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y wget unzip openjdk-11-jdk
RUN mkdir /opt/jmeter && \
    cd /opt/jmeter && \
    wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.6.3.tgz && \
    tar -xzf apache-jmeter-5.6.3.tgz
ENV PATH="/opt/jmeter/apache-jmeter-5.6.3/bin:${PATH}"


# Chrome & ChromeDriver 자동 설치
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d. -f1-3) && \
    DRIVER_VERSION="134.0.6998.90" && \
    wget -q "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip" -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf /tmp/chromedriver.zip

#pip까지 업그레이드
RUN python3 -m pip install --upgrade pip --break-system-packages
#셀레니움 사용하는지 모르도록 설정
RUN pip install selenium pytest selenium_stealth --break-system-packages

USER jenkins
