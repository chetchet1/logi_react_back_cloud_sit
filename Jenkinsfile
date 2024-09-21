pipeline {
    agent any

    stages {
        stage('Check PATH') {
            steps {
                script {
                    sh 'echo $PATH'  // Linux/Mac
                }
            }
        }
    }

    stages {
        // Terraform을 사용해 클러스터 자원 관리
        stage('Terraform Apply') {
            steps {
                dir('E:/docker_dev/terraform-codes') {
                    script {
                        sh '''
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        // 백엔드 서비스만 적용
        stage('Apply Backend Service') {
            steps {
                script {
                    sh 'kubectl apply -f E:/docker_Logi/logi-back-service.yaml'
                }
            }
        }

        // 프론트엔드 서비스 URL 가져오기
        stage('Get Frontend Service URL') {
            steps {
                script {
                    // 프론트엔드 서비스의 URL 가져오기
                    def frontend_service_url = sh(script: "kubectl get service frontend-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'", returnStdout: true).trim()
                    
                    // application.properties에 프론트엔드 서비스 URL 업데이트
                    sh """
                    sed -i 's|^FRONTEND_SERVICE_URL=.*|FRONTEND_SERVICE_URL=http://${frontend_service_url}:3000|' E:/docker_dev/logi_react_back_cloud/src/main/resources/application.properties
                    """
                }
            }
        }

        // 백엔드 Docker 이미지 빌드 및 ECR 푸시
        stage('Build and Push Backend Docker Image') {
            steps {
                dir('E:/docker_dev/logi_react_back_cloud') {
                    script {
                        sh """
                        docker build -t 339713037008.dkr.ecr.ap-northeast-2.amazonaws.com/logi_back:latest .
                        docker push 339713037008.dkr.ecr.ap-northeast-2.amazonaws.com/logi_back:latest
                        """
                    }
                }
            }
        }

        // 백엔드 디플로이먼트 적용
        stage('Apply Backend Deployment') {
            steps {
                script {
                    sh 'kubectl apply -f E:/docker_Logi/logi-back-deployment.yaml'
                }
            }
        }
    }
}
