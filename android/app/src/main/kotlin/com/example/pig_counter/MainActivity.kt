package com.example.pig_counter

import android.os.Build
import android.os.Bundle
import android.view.Display
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        scheduleHighRefreshRateRequest()
    }

    override fun onResume() {
        super.onResume()
        scheduleHighRefreshRateRequest()
    }

    override fun onPostResume() {
        super.onPostResume()
        scheduleHighRefreshRateRequest()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        scheduleHighRefreshRateRequest()
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            scheduleHighRefreshRateRequest()
        }
    }

    private fun scheduleHighRefreshRateRequest() {
        requestHighRefreshRate()
        window.decorView.post {
            requestHighRefreshRate()
        }
    }

    private fun requestHighRefreshRate() {
        val activeDisplay = currentDisplay() ?: return
        val attributes = window.attributes
        val bestMode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val sameSizeModes = activeDisplay.supportedModes
                .filter { mode ->
                    mode.physicalWidth == activeDisplay.mode.physicalWidth &&
                        mode.physicalHeight == activeDisplay.mode.physicalHeight
                }
            (if (sameSizeModes.isNotEmpty()) sameSizeModes else activeDisplay.supportedModes.toList())
                .maxByOrNull { it.refreshRate }
        } else {
            null
        }
        val preferredRefreshRate = bestMode?.refreshRate ?: activeDisplay.refreshRate.coerceAtLeast(60f)

        if (Build.VERSION.SDK_INT >= 34) {
            bestMode?.let { attributes.preferredDisplayModeId = it.modeId }
            attributes.preferredRefreshRate = preferredRefreshRate
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            bestMode?.let { attributes.preferredDisplayModeId = it.modeId }
            attributes.preferredRefreshRate = preferredRefreshRate
        } else {
            @Suppress("DEPRECATION")
            attributes.preferredRefreshRate = preferredRefreshRate
        }

        window.attributes = attributes
    }

    private fun currentDisplay(): Display? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            display
        } else {
            @Suppress("DEPRECATION")
            windowManager.defaultDisplay
        }
    }
}
