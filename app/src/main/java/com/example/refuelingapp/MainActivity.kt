package com.example.refuelingapp

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.journeyapps.barcodescanner.BarcodeScannerView

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Start ScanQRCodeActivity
        val scanButton: Button = findViewById(R.id.scan_button)
        scanButton.setOnClickListener {
            val intent = Intent(this, ScanQRCodeActivity::class.java)
            startActivity(intent)
        }
    }
}
