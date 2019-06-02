package fr.edouardmenayde.sleep_timer;

import android.content.Context;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "sleep_timer.edouardmenayde.fr/audio";
    private AudioManager audioManager;

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        Context context = this.getApplicationContext();

        audioManager = (AudioManager)getSystemService(Context.AUDIO_SERVICE);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("getAudioFocus")) {
                            int focus = getAudioFocus();

                            if (focus == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
                                result.success(focus);
                            } else {
                                result.error("Error", "Could not get audio focus.", null);
                            }
                        } else {
                            result.notImplemented();
                        }
                    }

                    public int getAudioFocus() {
                        AudioAttributes audioAttributes = new AudioAttributes.Builder()
                                .setUsage(AudioAttributes.USAGE_MEDIA)
                                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                .build();
                        AudioFocusRequest audioFocusRequest = new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                                .setAudioAttributes(audioAttributes)
                                .setWillPauseWhenDucked(false)
//                                .setOnAudioFocusChangeListener(this::onAudioFocusChange)
                                .build();

                        return audioManager.requestAudioFocus((AudioFocusRequest)audioFocusRequest);
                    }

//                    public void onAudioFocusChange(int focusChange) {
//                        switch (focusChange) {
//                            case AudioManager.AUDIOFOCUS_GAIN:
//                                listener.onAudioFocusGained();
//                                break;
//                            case AudioManager.AUDIOFOCUS_LOSS:
//                                listener.onAudioFocusLost();
//                                break;
//                            case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
//                                listener.onAudioFocusLostTransient();
//                                break;
//                            case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
//                                listener.onAudioFocusLostTransientCanDuck();
//                                break;
//                            default:
//                                break;
//                        }
//                    }
                });
    }
}
