package com.rikkatheworld.wangyiyun.util;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class GsonUtil {
    private static  GsonUtil gson ;
    public GsonUtil(){}
    public static GsonUtil getInstance(){
        if(gson==null){
            return new GsonUtil();
        }
        return gson;
    }
public <T>List<T> press(String str,Class<T> clazz){
    Gson gson = new Gson();


    List<T> bannerList =new ArrayList<>() ;
    JsonElement jsonElement = JsonParser.parseString(str);
    JsonObject asJsonObject = jsonElement.getAsJsonObject();
    for (Map.Entry<String, JsonElement> stringJsonElementEntry : asJsonObject.entrySet()) {

        JsonElement value = stringJsonElementEntry.getValue();


        if (value.isJsonArray()){
            JsonArray jsonArray = value.getAsJsonArray();
            for (JsonElement element : jsonArray) {
                bannerList.add(gson.fromJson(element, clazz));
            }
            return bannerList;
        }else if(value.isJsonObject()){
            JsonObject jsonObject = value.getAsJsonObject();
            bannerList.add(gson.fromJson(value, clazz));

            return bannerList;
        }


    }
return null;
}
}
