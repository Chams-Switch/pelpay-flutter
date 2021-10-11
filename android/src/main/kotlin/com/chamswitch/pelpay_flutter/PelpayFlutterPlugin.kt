package com.chamswitch.pelpay_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import application.PelpaySdk
import application.PelpaySdkCallback
import enums.Environment

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import models.requests.Customer
import models.requests.Transaction
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.serialization.ExperimentalSerializationApi
import java.util.*
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.*
/** PelpayFlutterPlugin */
class PelpayFlutterPlugin : ActivityAware, FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private lateinit var context: Context
    private var resultCode = 1111
    private var pluginResult: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pelpay_flutter")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    @ExperimentalSerializationApi
    override  fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        pluginResult = result
        if (call.method == "makePayment") {
            val scope = CoroutineScope(Job() + Dispatchers.Main)
            scope.launch {
                makePayment(call = call, result = result)
            }
        } else {
            result.notImplemented()
        }
    }

    @ExperimentalSerializationApi
    private suspend fun makePayment(@NonNull call: MethodCall, @NonNull result: Result) {

        val clientId = call.argument("clientId") as String?
        val clientSecret = call.argument("clientSecret") as String?
        val isProduction = call.argument<Boolean>("isProduction")
        val brandPrimaryColorInHex =  call.argument("brandPrimaryColorInHex") as String?
        val shouldHidePelpaySecureLogo = call.argument<Boolean>("shouldHidePelpaySecureLogo")

        val transaction = call.argument<HashMap<String, Any>>("transaction")

//        val transaction = transactionData!!.split(",").associate {
//            val (left, right) = it.split("=")
//            left to right.toInt()
//        }
        val integrationKey = transaction?.get("integrationKey") as  String?
        val amount = transaction?.get("amount") as Int?
        val currency = transaction?.get("currency") as  String?
        val merchantReference = transaction?.get("merchantReference") as  String?
        val narration = transaction?.get("narration") as String?
        val splitCode = transaction?.get("splitCode") as String?
        val customer = transaction?.get("customer")!! as Map<*, *>

        //CUSTOMER PARSING
        val customerId = customer["customerId"].toString()
        val customerLastName = customer["customerLastName"].toString()
        val customerFirstName = customer["customerFirstName"].toString()
        val customerEmail = customer["customerEmail"].toString()
        val customerPhoneNumber = customer["customerPhoneNumber"].toString()
        val customerAddress = customer["customerAddress"].toString()
        val customerCity = customer["customerCity"].toString()
        val customerStateCode = customer["customerStateCode"].toString()
        val customerPostalCode = customer["customerPostalCode"].toString()
        val customerCountryCode = customer["customerCountryCode"].toString()

        var environment = Environment.Staging
        if (isProduction!!) {
            environment = Environment.Production
        }
            PelpaySdk.setTransaction(Transaction(
                    amount = amount!!.toLong(),
                    currency = currency,
                    merchantRef = merchantReference,
                    narration = narration,
                    splitCode = splitCode,
                    integrationKey = integrationKey,
                    customer = Customer(
                            customerID = customerId,
                            customerLastName = customerLastName,
                            customerFirstName = customerFirstName,
                            customerEmail = customerEmail,
                            customerPhoneNumber = customerPhoneNumber,
                            customerAddress = customerAddress,
                            customerCity = customerCity,
                            customerStateCode = customerStateCode,
                            customerPostalCode = customerPostalCode,
                            customerCountryCode = customerCountryCode
                    )
            )).setBrandPrimaryColor(Color.parseColor(brandPrimaryColorInHex)).setHidePelpayLogo(shouldHidePelpaySecureLogo!!).initialise(environment = environment, clientId = clientId!!,
                    clientSecret = clientSecret!!, context = (activity as FragmentActivity?)!!).withCallBack(callback = object : PelpaySdkCallback() {
                override fun onSuccess(adviceReference: String?) {
                    result.success("$adviceReference")
                }

                override fun onError(errorMessage: String?) {
                    result.error("ERROR", "$errorMessage", "$errorMessage")
                }
            })

    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
        channel.setMethodCallHandler(this)
    }
    override fun onDetachedFromActivity() {
        activity = null
        channel.setMethodCallHandler(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == resultCode) {
            if (resultCode == Activity.RESULT_OK) {
                if (data!!.hasExtra("success")){
                    val result = data.getStringExtra("success")
                    pluginResult!!.success(result)
                }
                else if (data.hasExtra("error")){
                    val result = data.getStringExtra("error")
                    pluginResult!!.error("ERROR", result,null )
                }
                else {
                    pluginResult!!.notImplemented()
                }
                return true
            }
        }
        return false
    }
}
