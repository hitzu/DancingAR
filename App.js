/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { useState } from 'react';
import ReactNative, {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  TouchableOpacity,
  StatusBar,
  requireNativeComponent,
  NativeModules,
  UIManager
} from 'react-native';

const DanceView = requireNativeComponent("DanceView")


const App = () => {
  const [myCVInstance, setMyCVInstance] = useState(null)

  const addBox = (colorPickCount) => {

    for (i = 0; i < colorPickCount; i++) {
      UIManager.dispatchViewManagerCommand(
        ReactNative.findNodeHandle(myCVInstance),
        UIManager.DanceView.Commands.incrementBoxPickerViaManager,
        [])
    }

    UIManager.dispatchViewManagerCommand(
      ReactNative.findNodeHandle(myCVInstance),
      UIManager.DanceView.Commands.addNodeViaManager,
      [])
  }

  return (
    <SafeAreaView style={styles.container}>


      <DanceView ref={(component) => setMyCVInstance(component)} style={styles.wrapper} />

      <View style={{ padding: 32, flexDirection: 'row' }}>

        <TouchableOpacity
          style={[styles.wrapper, styles.border]}
          onPress={() => { addBox(0) }}>
          <Text style={styles.buttonText}>Miguel</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.wrapper, styles.border]}
          onPress={() => { addBox(1) }}>
          <Text style={styles.buttonText}>Es</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.wrapper, styles.border]}
          onPress={() => { addBox(2) }}>
          <Text style={styles.buttonText}>Puto</Text>
        </TouchableOpacity>

      </View>
    </SafeAreaView>

  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1, alignItems: "stretch"
  },
  wrapper: {
    flex: 1, alignItems: "center", justifyContent: "center"
  },
  border: {
    borderColor: "#eee",
    borderWidth: 2,
    borderRadius: 8,
    padding: 8,
    marginHorizontal: 8
  },
  buttonsContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around'
  }
});

export default App;