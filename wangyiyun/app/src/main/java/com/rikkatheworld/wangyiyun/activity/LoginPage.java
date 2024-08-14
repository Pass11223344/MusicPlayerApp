package com.rikkatheworld.wangyiyun.activity;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Message;
import android.text.Editable;
import android.text.Html;
import android.text.Spanned;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.fragment.MsgFragment;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;
import com.rikkatheworld.wangyiyun.util.NetworkUtils;
import com.rikkatheworld.wangyiyun.view.CustomToast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class LoginPage extends AppCompatActivity implements View.OnClickListener {

    private EditText ed_account;
    private EditText ed_password;
    private Button btn_login;
    private final int RES_ID = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_login_page);
        initView();
//        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
//            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
//            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
//            initView();
//            return insets;
//        });
    }

    private void initView() {


        ed_account = findViewById(R.id.ed_account);
        ed_password = findViewById(R.id.ed_password);
        btn_login = findViewById(R.id.btn_login);

        btn_login.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        String password = ed_password.getText().toString().trim();
        String account = ed_account.getText().toString().trim();
        if (!account.equals("") && !password.equals("")) {

            OkHttpClient okHttpClient = new OkHttpClient();


            Request request = new Request.Builder()
                    .url(NetworkInfo.URL + "/login/cellphone?phone=" + account + "&password=" + password)
                    .get()
                    .build();

            Call call = okHttpClient.newCall(request);
            call.enqueue(new Callback() {

                private String token;

                @Override
                public void onFailure(Call call, IOException e) {
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    if (response.body() != null) {
                        String string = response.body().string();

                        try {
                            JSONObject jsonObject = new JSONObject(string);
                            int code = Integer.parseInt(String.valueOf(jsonObject.get("code")));

                            if (code == 502 || code == 400) {

                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        CustomToast.showToast(v.getContext(), "账号或密码错误");
                                    }
                                });
                            } else if (code == -460 || code == 1004) {


                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        CustomToast.showToast(v.getContext(), "网络拥挤或存在风险，稍后再试");
                                    }
                                });
                            } else {

                                if (jsonObject.has("token")) {
                                    token = String.valueOf(jsonObject.get("token"));
                                    // Spanned spanned = Html.fromHtml(token, Html.FROM_HTML_MODE_LEGACY);

                                }
                                SharedPreferences share = getSharedPreferences("UserInfoData", MODE_PRIVATE);

                                SharedPreferences.Editor edit = share.edit();//编辑文件

                                edit.putString("token", String.valueOf(token));
                                edit.putString("UserInfo", String.valueOf(jsonObject));
                                Log.d("TAddddG", "code: " + code);
                                edit.commit();

                                runOnUiThread(() -> {
                                    if (token != null) {
                                        onBackPressed();
                                    }
                                });
                                //  finish();
                            }


                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }


                    }
                }
            });
            // NetworkUtils.makeRequest(NetworkInfo.URL + "/login/cellphone?phone="+account+"&password="+password, handler, STATUS);

        } else {
            CustomToast.showToast(this, "请填写完整");
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }
}