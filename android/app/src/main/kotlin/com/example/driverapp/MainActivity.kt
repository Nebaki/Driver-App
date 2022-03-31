package com.example.driverapp

import android.util.Log
import androidx.annotation.NonNull
import com.vintechplc.telebirr.model.PaymentResult
import com.vintechplc.telebirr.model.TeleBirrPack
import com.vintechplc.telebirr.setups.AngolaPayUtil
import com.vintechplc.telebirr.setups.PaymentResultListener
import com.vintechplc.telebirr.setups.TradePayMapRequest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity: FlutterActivity(),PaymentResultListener {
    companion object {
        const val CHANNEL = "telebirr_channel"
    }
    var listner: MethodChannel.Result? = null
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AngolaPayUtil.getInstance().setPaymentResultListener(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                // manage method calls here
                this.listner = result
                if (call.method == "initTeleBirr" && call.hasArgument("data")){
                    var data = call.argument<Map<String,Any>>("data")
                    if(data != null){
                        /*val name = data["message"]
                        listner!!.success(
                            "{\"CODE\":\"200\"," +
                                    "\"MSG\":\"$name\"}")*/
                        initTeleBirr(buildTelePack(data))
                    }else{
                        val result = PaymentResult()
                        result.code = -2
                        result.msg = "Payment process failed, Required Data Not Found"
                        paymentResult(result)
                    }
                } else {
                    val result = PaymentResult()
                    result.code = -2
                    result.msg = "Payment process failed, Not Implemented"
                    paymentResult(result)
                }
            }
    }
    fun buildTelePack(data: Map<String, Any>?): TeleBirrPack {
        var tBirr = TeleBirrPack()
        tBirr.appId = data?.get("appId") as String
        tBirr.notifyUrl = data["notifyUrl"] as String
        tBirr.outTradeNo = data["outTradeNumber"] as String?
        tBirr.receiverName = data["receiverName"] as String?
        tBirr.returnUrl = data["returnUrl"] as String?
        tBirr.shortCode = data["shortCode"] as String?
        tBirr.subject = data["subject"] as String?
        tBirr.timeoutExpress = data["timeoutExpress"] as String?
        tBirr.appKey = data["appKey"] as String
        tBirr.publicKey = data["publicKey"] as String?
        tBirr.message = data["message"] as String?
        tBirr.entityId = data["totalAmount"] as String?
        return tBirr
    }
    fun initTeleBirr(payData: TeleBirrPack?) {
        if (payData != null) {
            val request = TradePayMapRequest()
            request.appId = payData.appId
            request.setNotifyUrl(payData.notifyUrl)
            request.outTradeNo = payData.outTradeNo
            request.setReceiveName(payData.receiverName)
            request.setReturnUrl(payData.returnUrl)
            request.setShortCode(payData.shortCode)
            request.setSubject(payData.subject)
            request.setTimeoutExpress(payData.timeoutExpress)
            request.setTotalAmount(payData.entityId)
            if (payData.appKey != null && payData.publicKey != null) {
                AngolaPayUtil.getInstance().startPayment(
                    request, this, payData.appKey, payData.publicKey
                )
            } else {
                val result = PaymentResult()
                result.code = -1
                result.msg = "Payment process failed, Keys not valid"
                paymentResult(result)
            }
        } else {
            val result = PaymentResult()
            result.code = -1
            result.msg = "Payment process failed, Please Try again"
            paymentResult(result)
        }
    }

    override fun paymentResult(result: PaymentResult) {
        if(listner != null){
            try {
                listner!!.success(
                    "{\"CODE\":\"${result.code}\"," +
                            "\"MSG\":\"${result.msg}\"}")
            }catch (e:Exception){

            }
            //listner!!.error(result.msg, result.code.toString(),"test")
            //finish()
        }
    }
}
