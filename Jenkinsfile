def appName = "ex-http-microservice"

pipeline {
  agent {
    kubernetes {
      label "${appName}-${env.BRANCH_NAME}-tests"
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  restartPolicy: Never
  containers:
    - name: testbox
      image: elixir:1.7.4-alpine
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /cache
          name: cachepvc
      env:
        - name: HEX_API_KEY
          valueFrom:
            secretKeyRef:
              name: hex-key
              key: key
  volumes:
    - name: cachepvc
      persistentVolumeClaim:
        claimName: ${appName}-build-cache
"""
    }
  }
  stages {
    stage('Run Unit Tests') {
      steps {
        container('testbox') {
          sh "mix local.hex --force"
          sh "mix local.rebar --force"
          sh "if [ -d \"/cache\" ]; then cp -rf /cache/* .; fi"
          sh "ls -alt"
          sh "ls -alt _build"
          sh "ls -alt deps"
          sh "mix do deps.get, compile"
          sh "mix dialyzer"
          sh "mix test --cover"
          sh "rm -rf /cache/*"
          sh "cp -rf _build /cache"
          sh "cp -rf deps /cache"
          sh "cp -rf *.plt /cache"
          sh "ls -alt /cache"
          sh "ls -alt /cache/_build"
          sh "ls -alt /cache/deps"
        }
      }
      post {
        always {
          junit 'junit.xml'
          cobertura coberturaReportFile: "coverage.xml"
        }
      }
    }
    stage('Publish to Hex') {
      when {
        buildingTag()
      }
      steps {
        container('testbox') {
          sh "mix docs"
          sh "mix hex.publish --yes"
        }
      }
    }
  }
}