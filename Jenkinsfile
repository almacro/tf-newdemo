node("terraform") {
  stage('Clone') {
      // Clone the configuration repository
      cleanWs()
      git branch: 'main', 
          url: 'https://github.com/almacro/tf-newdemo.git'
  }
}