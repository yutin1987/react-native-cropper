import React, { Component } from 'react';
import { AppRegistry, StyleSheet, Text, TouchableOpacity, View, Image } from 'react-native';
import Cropper from 'react-native-cropper';

const styles = StyleSheet.create({
  viewport: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#F5FCFF',
  },
  button: {
    margin: 20,
    padding: 10,
    borderWidth: 1,
  },
  buttonText: {
    fontSize: 20,
    textAlign: 'center',
  },
  image: {
    alignSelf: 'center',
    width: 320,
    height: 320,
  },
});

export default class example extends Component {

  state = {
    image: 'data:image/jpeg;base64,',
  }

  onAlbumPress = async () => {
    const image = await Cropper.getPhotoFromAlbum();
    this.setState({ image: `data:image/jpeg;base64,${image}` });
  }

  onCameraPress = async () => {
    const image = await Cropper.getPhotoFromCamera();
    this.setState({ image: `data:image/jpeg;base64,${image}` });
  }

  onBase64Press = async () => {
    const image = await Cropper.getPhotoFromCamera({}, this.state.image);
    this.setState({ image: `data:image/jpeg;base64,${image}` });
  }

  render() {
    return (
      <View style={styles.viewport}>
        <TouchableOpacity onPress={this.onBase64Press} style={styles.button}>
          <Image style={styles.image} source={{ uri: this.state.image }} />
        </TouchableOpacity>
        <TouchableOpacity onPress={this.onAlbumPress} style={styles.button}>
          <Text style={styles.buttonText}>get photo from album</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={this.onCameraPress} style={styles.button}>
          <Text style={styles.buttonText}>get photo from camera</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

AppRegistry.registerComponent('example', () => example);