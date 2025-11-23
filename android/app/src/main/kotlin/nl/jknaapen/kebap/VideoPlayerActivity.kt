package nl.jknaapen.kebap

import android.graphics.PixelFormat
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.annotation.OptIn
import androidx.annotation.RequiresApi
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.media3.common.util.UnstableApi
import nl.jknaapen.kebap.composables.controls.CustomVideoControls
import nl.jknaapen.kebap.composables.overlays.screensavers.ScreenSaver
import nl.jknaapen.kebap.objects.VideoPlayerObject
import nl.jknaapen.kebap.player.ExoPlayer
import nl.jknaapen.kebap.utility.ScaledContent
import nl.jknaapen.kebap.utility.leanBackEnabled

class VideoPlayerActivity : ComponentActivity() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        VideoPlayerObject.currentActivity = this

        window.setFlags(
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED
        )

        window.setFormat(PixelFormat.TRANSLUCENT)

        setContent {
            VideoPlayerTheme {
                VideoPlayerScreen()
            }
        }
    }

    override fun onPause() {
        super.onPause()
        VideoPlayerObject.implementation.pause()
    }
}

@RequiresApi(Build.VERSION_CODES.O)
@OptIn(UnstableApi::class)
@Composable
fun VideoPlayerScreen(
) {
    val leanBackEnabled = leanBackEnabled(LocalContext.current)
    ScreenSaver {
        ExoPlayer { player ->
            ScaledContent(if (leanBackEnabled) 0.6f else 1f) {
                CustomVideoControls(player)
            }
        }
    }
}