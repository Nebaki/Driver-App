package com.vintechplc.telebirr.model;

import java.io.Serializable;
import java.util.UUID;

/**
 * Created by wgy on 2017/4/25.
 */

public class TradePayRequest implements Serializable {

    private String appId;

    private String returnUrl;

    private String notifyUrl;

    private String subject;

    private String outTradeNo;

    private String timeoutExpress;

    private String totalAmount;

    private String shortCode;

    private String receiveName;

    private String nonce;

    private  String timestamp;

    private String returnApp;

    public TradePayRequest(){
        nonce= UUID.randomUUID().toString().replaceAll("-", "");
        timestamp=String.valueOf(System.currentTimeMillis());
    }


    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }


    public String getNonce() {
        return nonce;
    }

    public void setNonce(String nonce) {
        this.nonce = nonce;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public String getNotifyUrl() {
        return notifyUrl;
    }

    public void setNotifyUrl(String notifyUrl) {
        this.notifyUrl = notifyUrl;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getOutTradeNo() {
        return outTradeNo;
    }

    public void setOutTradeNo(String outTradeNo) {
        this.outTradeNo = outTradeNo;
    }

    public String getTimeoutExpress() {
        return timeoutExpress;
    }

    public void setTimeoutExpress(String timeoutExpress) {
        this.timeoutExpress = timeoutExpress;
    }

    public String getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(String totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShortCode() {
        return shortCode;
    }

    public void setShortCode(String shortCode) {
        this.shortCode = shortCode;
    }

    public String getReceiveName() {
        return receiveName;
    }

    public void setReceiveName(String receiveName) {
        this.receiveName = receiveName;
    }

    public String getReturnApp() {
        return returnApp;
    }

    public void setReturnApp(String returnApp) {
        this.returnApp = returnApp;
    }
}
