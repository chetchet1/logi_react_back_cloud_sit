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
                        aws eks update-kubeconfig --region %REGION% --name test-eks-cluster
                        '''
                    }
                }
            }
        }

        // 프론트엔드 및 백엔드 서비스 배포
        stage('Apply Services') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                        bat 'kubectl apply -f E:/docker_Logi/logi-front-service.yaml'
                        bat 'kubectl apply -f E:/docker_Logi/logi-back-service.yaml'
                    }
                }
            }
        }

        stage('Update Backend Properties with Frontend URL') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                        // 1. kubectl 명령어로 프론트엔드 서비스의 호스트 이름을 가져옴
                        def frontend_service_url = bat(script: 'kubectl get service frontend-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"', returnStdout: true).trim()

                        // 2. PowerShell을 사용하여 application.properties 파일 수정
                        bat """
                        powershell -Command "(Get-Content 'E:\\docker_dev\\logi_react_back_cloud\\src\\main\\resources\\application.properties') -replace 'FRONTEND_SERVICE_URL=.*', 'FRONTEND_SERVICE_URL=http://${frontend_service_url}:3000' | Set-Content 'E:\\docker_dev\\logi_react_back_cloud\\src\\main\\resources\\application.properties'"
                        """
                    }
                }
            }
        }

        // 백엔드 Docker 이미지 빌드 및 ECR 푸시
        stage('Build and Push Backend Docker Image') {
            steps {
                dir('E:/docker_dev/logi_react_back_cloud') {
                    script {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                            bat """
                            docker build -t 339713037008.dkr.ecr.ap-northeast-2.amazonaws.com/logi_back:latest .
                            docker push 339713037008.dkr.ecr.ap-northeast-2.amazonaws.com/logi_back:latest
                            """
                        }
                    }
                }
            }
        }

        // 백엔드 디플로이먼트 적용
        stage('Apply Backend Deployment') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-key']]) {
                        bat 'kubectl apply -f E:/docker_Logi/logi-back-deployment.yaml'
                    }
                }
            }
        }
    }
}