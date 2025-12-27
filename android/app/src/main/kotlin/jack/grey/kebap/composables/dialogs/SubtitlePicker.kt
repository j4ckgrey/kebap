package jack.grey.kebap.composables.dialogs

import androidx.annotation.OptIn
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.unit.dp
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.ExoPlayer
import jack.grey.kebap.objects.Localized
import jack.grey.kebap.objects.Translate
import jack.grey.kebap.objects.VideoPlayerObject
import jack.grey.kebap.utility.clearSubtitleTrack
import jack.grey.kebap.utility.setInternalSubtitleTrack

@OptIn(UnstableApi::class)
@Composable
fun SubtitlePicker(
    player: ExoPlayer,
    onDismissRequest: () -> Unit,
) {
    val selectedIndex by VideoPlayerObject.currentSubtitleTrackIndex.collectAsState()
    val subTitles by VideoPlayerObject.subtitleTracks.collectAsState(emptyList())
    val internalSubTracks by VideoPlayerObject.exoSubTracks.collectAsState(emptyList())

    if (subTitles.isEmpty()) return

    // Filter server subtitles to exclude any explicit "None" tracks to avoid duplication
    // We assume any track with a negative index or name "None"/"Off" is a dummy track
    val realSubTitles = remember(subTitles) {
        subTitles.filter { it.index >= 0 && !it.name.equals("None", ignoreCase = true) && !it.name.equals("Off", ignoreCase = true) }
    }

    val focusOffTrack = remember { FocusRequester() }
    val focusRequesters = remember(realSubTitles) {
        realSubTitles.associateWith { FocusRequester() }
    }

    val listState = rememberLazyListState()

    LaunchedEffect(selectedIndex, realSubTitles) {
        if (selectedIndex == -1) {
            listState.scrollToItem(0)
            focusOffTrack.requestFocus()
            return@LaunchedEffect
        }

        val selectedSubIndex = realSubTitles.indexOfFirst { it.index == selectedIndex.toLong() }

        if (selectedSubIndex in realSubTitles.indices) {
            // +1 for the Off button header
            listState.scrollToItem(selectedSubIndex + 1)
            focusRequesters[realSubTitles[selectedSubIndex]]?.requestFocus()
        }
    }

    CustomModalBottomSheet(
        onDismissRequest,
        maxWidth = 600.dp,
    ) {
        LazyColumn(
            state = listState,
            modifier = Modifier
                .wrapContentWidth()
                .padding(horizontal = 8.dp, vertical = 16.dp),
        ) {
            // Dedicated Off Button
            item {
                val isSelected = selectedIndex == -1
                TrackButton(
                    modifier = Modifier
                        .fillMaxWidth()
                        .focusRequester(focusOffTrack),
                    onClick = {
                        VideoPlayerObject.setSubtitleTrackIndex(-1)
                        player.clearSubtitleTrack()
                    },
                    selected = isSelected,
                ) {
                    Translate(Localized::off) {
                        Text(it)
                    }
                }
            }

            // Real Subtitle Tracks
            items(realSubTitles.size) { index ->
                val serverSub = realSubTitles[index]
                val selected = serverSub.index == selectedIndex.toLong()
                
                // We assume 1:1 mapping between filtered server tracks and internal tracks
                // If counts mismatch, we try to match by index, otherwise default to list position
                val internalSubTrack = internalSubTracks.elementAtOrNull(index)

                TrackButton(
                    modifier = Modifier
                        .fillMaxWidth()
                        .focusRequester(focusRequesters[serverSub]!!),
                    onClick = {
                        if (internalSubTrack != null) {
                            VideoPlayerObject.setSubtitleTrackIndex(serverSub.index.toInt())
                            player.setInternalSubtitleTrack(internalSubTrack)
                        }
                    },
                    selected = selected,
                ) {
                    Text(text = serverSub.name)
                }
            }
        }
    }
}