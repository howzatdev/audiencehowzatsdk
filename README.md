# Dev

# To register your name to cocospod org
pod trunk register devaccounts@howzat.com 'Dev' --description='macbook pro'

# Publish new version
1.cd to root project
2.pod lib lint AudienceHowzatSDK.podspec
This command will used to validate the app
3.pod trunk push AudienceHowzatSDK.podspec
This will push new version to cocospod org cloud