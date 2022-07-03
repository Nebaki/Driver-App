package com.vintechplc.telebirr.model;

public class TeleBirrPack {
    private String message;
    private int code;

    private String entityId;
    private String bearerId;
    private double totalAmount;
    private double price_usd;
    private double price_etb;
    private String appId;
    private String receiverName;
    private String shortCode;
    private String subject;
    private String returnUrl;
    private String notifyUrl;
    private String timeoutExpress;
    private String appKey;
    private String publicKey;
    private String outTradeNo;
    private String productionClientId;
    private String inAppPaymentUrl;

    public String getInAppPaymentUrl() {
        return inAppPaymentUrl;
    }

    public void setInAppPaymentUrl(String inAppPaymentUrl) {
        this.inAppPaymentUrl = inAppPaymentUrl;
    }

    public String getMessage() {
        return message;
    }

    public double getPrice_etb() {
        return price_etb;
    }

    public void setPrice_etb(double price_etb) {
        this.price_etb = price_etb;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getShortCode() {
        return shortCode;
    }

    public void setShortCode(String shortCode) {
        this.shortCode = shortCode;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
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

    public String getTimeoutExpress() {
        return timeoutExpress;
    }

    public void setTimeoutExpress(String timeoutExpress) {
        this.timeoutExpress = timeoutExpress;
    }

    public String getAppKey() {
        return appKey;
    }

    public void setAppKey(String appKey) {
        this.appKey = appKey;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getProductionClientId() {
        return productionClientId;
    }

    public void setProductionClientId(String productionClientId) {
        this.productionClientId = productionClientId;
    }

    public String getEntityId() {
        return entityId;
    }

    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }

    public String getBearerId() {
        return bearerId;
    }

    public void setBearerId(String bearerId) {
        this.bearerId = bearerId;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getPrice_usd() {
        return price_usd;
    }

    public void setPrice_usd(double price_usd) {
        this.price_usd = price_usd;
    }

    public String getOutTradeNo() {
        return outTradeNo;
    }

    public void setOutTradeNo(String outTradeNo) {
        this.outTradeNo = outTradeNo;
    }
}
