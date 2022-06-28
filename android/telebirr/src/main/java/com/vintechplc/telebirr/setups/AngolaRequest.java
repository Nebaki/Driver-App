package com.vintechplc.telebirr.setups;



import io.reactivex.Observable;
import retrofit2.http.Body;
import retrofit2.http.POST;

interface AngolaRequest {

    String TEST_HOST = "http://196.188.120.3:10443/service-openup/";
    //String TEST_HOST = "http://196.188.120.3:11443/ammapi/service-openup/";

    //String PROD_HOST = "https://app.ethiomobilemoney.et:2121/ammapi/payment/service-openup/";

//    String HOST = "http://app.ethiomobilemoney.et:2121/";

    @POST("toTradeSDKPay")
    Observable<TradeWebPayResponse> toTradeWebPay(@Body TradeSDKPayRequest request);

}
