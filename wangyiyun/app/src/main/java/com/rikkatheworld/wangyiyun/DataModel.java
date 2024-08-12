package com.rikkatheworld.wangyiyun;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.function.Predicate;


public class DataModel{
     private static DataModel dataModel;

    public static Map<?, ?> fromFlutter;

    public static DataModel getInstance(){
         if (dataModel==null) {
             return dataModel = new DataModel();
         }
             return dataModel;
     }
  private  List<WeakReference<DataModelObserver>> observers = new ArrayList<>();

    public  void set(Map<?, ?> value) {
        this.fromFlutter = value;
        for (WeakReference<DataModelObserver> observer : observers) {
            if (observer!=null) {
                observer.get().onCountUpdate(value);
            }

        }

    }

    public void addObserver( DataModelObserver observer) {
        observers.add(new WeakReference<> (observer));
    }

    public void removeObserver(DataModelObserver observer) {
        Predicate<WeakReference<DataModelObserver>> predicate = dataModelObserverWeakReference -> {
            DataModelObserver observerRef = dataModelObserverWeakReference.get();
            return observerRef != null && observerRef == observer;
        };
        observers.removeIf(predicate);
    }
  public   interface DataModelObserver {
        void onCountUpdate(Map<?, ?> newData);
    }
}