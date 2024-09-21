pipeline {
    agent any

    environment {
        REGION = 'ap-northeast-2'
    }

    stages {
        stage('Check PATH') {
            steps {
                script {
                    bat 'echo %PATH%'  // Windows에서 PATH 확인
                }
            }
        }

        // Terraform을 사용해 클러스터 자원 관리
        stage('Terraform Apply') {
            steps {
                dir('E:/docker_dev/terraform-codes') {
                    script {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                            bat '''
                            set AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID%
                            set AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY%
                            terraform apply -auto-approve
                            '''
                        }
                    }
                }
            }
        }

        // AWS EKS 클러스터에 로그인
        stage('Update Kubeconfig') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                        bat '''
                        aws eks update-kubeconfig --region %REGION% --name your-cluster-name
                        '''
                    }
                }
            }
        }

        // 백엔드 서비스만 적용
        stage('Apply Backend Service') {
            steps {
                script {
                    bat 'kubectl apply -f E:/docker_Logi/logi-back-service.yaml'
                }
            }
        }

        // 프론트엔드 서비스 URL 가져오기
        stage('Get Frontend Service URL') {
            steps {
                script {
                    def frontend_service_url = bat(script: "kubectl get service frontend-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'", returnStdout: true).trim()
                    bat """
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
                        bat """
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
                    bat 'kubectl apply -f E:/docker_Logi/logi-back-deployment.yaml'
                }
            }
        }
    }
}
