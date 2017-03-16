const pkg = require('../package.json');

module.exports = {
  packageName: pkg.name,
  android: {
    activities: {
      'com.yalantis.ucrop.UCropActivity': {
        screenOrientation: 'portrait',
        theme: '@style/Theme.AppCompat.Light.NoActionBar'
      }
    },
    permissions: ['CAMERA']
  },
  ios: {
    params: [{
      message: 'What\'s your PhotoLibraryUsageDescription for ios?',
      name: 'NSPhotoLibraryUsageDescription',
      value: 'To crop images from photo library'
    }, {
      message: 'What\'s your CameraUsageDescription for ios?',
      name: 'NSCameraUsageDescription',
      value: 'To crop images from camera',
    }],
  },
};
