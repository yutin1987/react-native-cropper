import { NativeModules } from 'react-native';

const { RNCropper } = NativeModules;

export default class Cropper {

  static defaultParams = {
    width: 512,
    height: 512,
  };

  static async getPhotoFromAlbum(params = {}) {
    return RNCropper.getPhotoFromAlbum({
      ...Cropper.defaultParams,
      ...params,
    });
  }

  static async getPhotoFromCamera(params = {}) {
    return RNCropper.getPhotoFromCamera({
      ...Cropper.defaultParams,
      ...params,
    });
  }
}
