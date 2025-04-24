pipeline {
    agent any

    environment {
        JMETER_VERSION = "5.6.3" //본인버전
        JMETER_HOME = "/opt/jmeter/apache-jmeter-${JMETER_VERSION}" //기본값

        JTL_REPORT_FILE = "results/results.jtl" // 성능 플러그인이 분석할 결과 파일 경로
        HTML_REPORT_DIR = "results/report_output" // JMeter HTML 보고서 디렉토리
    }

    stages {
        stage('Run Tests') { //단계
            steps { //실행내용
                script{ //sh = 리눅스 명령어 쓰겠다                   
                    sh 'rm -rf results' //results 파일을 지움
                    sh 'rm -f results.jtl' //rm = romove 약자 f=파일, rf=폴더까지 삭제
                    sh 'rm -rf report_output' //폴더를 지움

                    // 폴더 생성
                    sh 'mkdir -p results'       // 결과 파일 저장 디렉토리 생성
                    sh 'mkdir -p report_output' // 보고서 출력 디렉토리 생성
                    sh 'mkdir -p results/report_output'


                    sh """
                        echo "시작"
                        ${env.JMETER_HOME}/bin/jmeter -n \\
                          -t Test Plan_0424.jmx \\
                          -l ./results/results.jtl \\ 
                          -e -o ./results/report_output
                    """
                }
            }
        }

        stage('Publish Performance Report') {
            steps {
                perfReport(
                           sourceDataFiles: "${env.JTL_REPORT_FILE}",
                           errorFailedThreshold: 1.0,
                           errorUnstableThreshold: 0.5
                    )
                }
            }
        

        stage('Publish HTML Report') {
            steps {
                publishHTML(
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: false,
                    reportDir: "${env.HTML_REPORT_DIR}",
                    reportFiles: 'index.html',
                    reportName: 'JMeter Performance Report'
                )
            }
        }
    }

    post {
        always {
            echo 'Build finished.'
            archiveArtifacts artifacts: "${env.HTML_REPORT_DIR}/**/*", allowEmptyArchive: true
        }
    }
}