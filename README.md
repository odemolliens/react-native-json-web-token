
# react-native-json-web-token

Hard fork of https://www.npmjs.com/package/react-native-jwt-token

## Getting started

`$ npm install react-native-json-web-token --save`

### Mostly automatic installation

`$ react-native link react-native-json-web-token`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-json-web-token` and add `ODJsonWebToken.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libODJsonWebToken.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.odemolliens.rn.jwt.ODJsonWebTokenPackage;` to the imports at the top of the file
  - Add `new ODJsonWebTokenPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-json-web-token'
  	project(':react-native-json-web-token').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-json-web-token/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-json-web-token')
  	```


## Usage
```javascript
import ODJsonWebToken from 'react-native-json-web-token';

const payload = [
      {
        key: 'identity',
        value: [
          { key: 'first_name', value: '' },
          { key: 'last_name', value: '' },
        ],
      },
      {
        key: 'context',
        value: [
          { key: 'app_name', value: 'my_app' },
        ],
      },
    ];
    ODJsonWebToken.encodeArray(
      'HS256',
      payload,
      'MySecretToken'
    ).then(jwtData => {
		  console.warn('result:', jwtData)
      })
      .catch(err =>
        console.warn('error:', err)
      );
```
  
