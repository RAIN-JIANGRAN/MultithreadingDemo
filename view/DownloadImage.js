import {
  NativeModules,
  View,
  NativeEventEmitter,
  Button,
  FlatList,
  Text,
  Image,
} from 'react-native';
import React from 'react';
import {ProgressView} from '@react-native-community/progress-view';

const {DownloadImg} = NativeModules;

const DownlaodEmitter = new NativeEventEmitter(DownloadImg);

export const DownloadImage = () => {
  const [loadingInfo, setLoadingInfo] = React.useState([]);
  const [isDone, setIsDone] = React.useState(false);

  let imgUrl = [
    'https://images.unsplash.com/photo-1588956950505-3c8d99dac5d1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1588961615931-5a6e7b3a5b7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
    'https://images.unsplash.com/photo-1587614202632-f529704e0656?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  ];

  const subscription = DownlaodEmitter.addListener('EventDownload', (data) => {
    // console.log('downloading info:' + JSON.stringify(data));
    setLoadingInfo(data);
    if (data.filter((item) => item.base64Data).length == imgUrl.length) {
      setIsDone(true);
    }
  });

  return (
    <View>
      <Button
        title={'download'}
        onPress={() => {
          setLoadingInfo([]);
          DownloadImg.download(imgUrl);
        }}
      />
      {isDone ? <Text>WE GOT ALL IMAGES LOADED!</Text> : null}
      <FlatList
        data={loadingInfo}
        renderItem={({item, index, separator}) => {
          let progress = (item.receivedLength / item.totalLength) * 100 + '%';
          return (
            <View>
              {item.base64Data ? (
                <View style={{flex: 1, height: 300}}>
                  <Image
                    style={{width: '100%', height: '100%'}}
                    source={{uri: 'data:image/png;base64,' + item.base64Data}}
                  />
                </View>
              ) : (
                <View>
                  <Text>DownLoading:</Text>
                  <View style={{flex: 1, borderColor: 'black', borderWidth: 2}}>
                    <View
                      style={{
                        width: progress,
                        borderColor: 'green',
                        borderWidth: 2,
                      }}
                    />
                  </View>
                </View>
              )}
            </View>
          );
        }}
      />
    </View>
  );
};
