package com.vintechplc.telebirr.setups;

import java.util.HashMap;
import java.util.UUID;

/**
 * appId = 'ce83aaa3dedd42ab88bd017ce1ca2dd8',
 * returnUrl = '',
 * notifyUrl = '',
 * subject = '测试商品',
 * outTradeNo = '20210610',
 * timeoutExpress = '30',
 * totalAmount = '30',
 * shortCode = '10011',
 * receiveName = '测试收款',
 * nonce = 'd0f27cab70a6406cba55fd8a5ac2659b',
 * timestamp = '1634195036085',
 * returnApp = 'cn.easier.testswitch'
 */
public class TradePayMapRequest extends HashMap<String, String> {
    private static final String APP_ID = "appId";
    private static final String RETURN_URL = "returnUrl";
    private static final String NOTIFY_URL = "notifyUrl";
    private static final String SUBJECT = "subject";
    private static final String OUT_TRADE_NO = "outTradeNo";
    private static final String TIMEOUT_EXPRESS = "timeoutExpress";
    private static final String TOTAL_AMOUNT = "totalAmount";
    private static final String SHORT_CODE = "shortCode";
    private static final String RECEIVE_NAME = "receiveName";
    private static final String NONCE = "nonce";
    private static final String TIMESTAMP = "timestamp";
    private static final String RETURN_APP = "returnApp";

    public TradePayMapRequest() {
        setNonce(UUID.randomUUID().toString().replaceAll("-", ""));
        setTimestamp(String.valueOf(System.currentTimeMillis()));
    }

    public TradePayMapRequest setAppId(String v) {
        checkValue(APP_ID, v);
        return this;
    }

    public String getAppId(){
        return get(APP_ID);
    }

    public TradePayMapRequest setNotifyUrl(String v) {
        checkValue(NOTIFY_URL, v);
        return this;
    }

    public TradePayMapRequest setOutTradeNo(String v) {
        checkValue(OUT_TRADE_NO, v);
        return this;
    }

    public String getOutTradeNo() {
        return get(OUT_TRADE_NO);
    }

    public TradePayMapRequest setReceiveName(String v) {
        checkValue(RECEIVE_NAME, v);
        return this;
    }

    public TradePayMapRequest setReturnUrl(String v) {
        checkValue(RETURN_URL, v);
        return this;
    }

    public TradePayMapRequest setShortCode(String v) {
        checkValue(SHORT_CODE, v);
        return this;
    }

    public TradePayMapRequest setSubject(String v) {
        checkValue(SUBJECT, v);
        return this;
    }

    public TradePayMapRequest setTimeoutExpress(String v) {
        checkValue(TIMEOUT_EXPRESS, v);
        return this;
    }

    public TradePayMapRequest setTotalAmount(String v) {
        checkValue(TOTAL_AMOUNT, v);
        return this;
    }

    public TradePayMapRequest setNonce(String v) {
        checkValue(NONCE, v);
        return this;
    }

    public TradePayMapRequest setTimestamp(String v) {
        checkValue(TIMESTAMP, v);
        return this;
    }

    public TradePayMapRequest setReturnApp(String v) {
        checkValue(RETURN_APP, v);
        return this;
    }

    private void checkValue(String key, String v) {
        if (v == null) {
            remove(key);
        } else {
            put(key, v);
        }
    }

}
