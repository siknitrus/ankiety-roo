// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.b2.ankiety.model;

import com.b2.ankiety.model.Dictionary;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect Dictionary_Roo_Json {
    
    public String Dictionary.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public String Dictionary.toJson(String[] fields) {
        return new JSONSerializer().include(fields).exclude("*.class").serialize(this);
    }
    
    public static Dictionary Dictionary.fromJsonToDictionary(String json) {
        return new JSONDeserializer<Dictionary>().use(null, Dictionary.class).deserialize(json);
    }
    
    public static String Dictionary.toJsonArray(Collection<Dictionary> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static String Dictionary.toJsonArray(Collection<Dictionary> collection, String[] fields) {
        return new JSONSerializer().include(fields).exclude("*.class").serialize(collection);
    }
    
    public static Collection<Dictionary> Dictionary.fromJsonArrayToDictionarys(String json) {
        return new JSONDeserializer<List<Dictionary>>().use(null, ArrayList.class).use("values", Dictionary.class).deserialize(json);
    }
    
}
