pipeline {
    agent any

    environment {
        JMETER_VERSION = "5.6.3"
        JMETER_HOME = "/opt/jmeter/apache-jmeter-${JMETER_VERSION}"
        JTL_REPORT_FILE = "results/results.jtl" // 성능 플러그인이 분석할 결과 파일 경로
        PERFORMANCE_REPORT_DIR = 'performance-report' // 성능 보고서가 생성될 디렉토리
        HTML_REPORT_DIR = "results/report_output" // JMeter HTML 보고서 디렉토리

        WORKSPACE = "/var/jenkins_home/workspace/sds"

        APDEX_SATISFIED_THRESHOLD = "500"  // 예시: 만족 임계값 500ms
        APDEX_TOLERATED_THRESHOLD = "1500" // 예시: 허용 임계값 1500ms
    }

    stages {
        stage('Run Tests') {
            steps {
                script{    
                    sh "pwd"   
                    sh "rm -rf ${env.JMETER_HOME}/results" 
                    sh "rm -rf ${HTML_REPORT_DIR}"         
                    sh "mkdir ${env.JMETER_HOME}/results" 
                    sh "mkdir -p ${HTML_REPORT_DIR}"         
                    sh """
                        echo "시작"
                        ${env.JMETER_HOME}/bin/jmeter -n \\
                          -t MyTestPlan.jmx \\
                          -l ${env.JMETER_HOME}/results/results.jtl \\
                          -e -o ${env.JMETER_HOME}/results/report_output
                    """

                    sh "cp ${env.JMETER_HOME}/results/results.jtl ${env.WORKSPACE}/results/results.jtl"                }
            }
        }

        stage('Publish Performance Report') {
            steps {
                perfReport(
                           sourceDataFiles: '/var/jenkins_home/workspace/sds/results/results.jtl',
                           errorFailedThreshold: 1.0,
                           errorUnstableThreshold: 0.5
                    )
                }
            }
    
    }

    post {
        always {
            echo 'Build finished.'
            archiveArtifacts artifacts: "results/report_output", allowEmptyArchive: true
        }
    }
}