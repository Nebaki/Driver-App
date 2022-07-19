package com.ravenio.hiver.utils

import org.json.JSONArray
import org.json.JSONObject

class JsonBuilder(vararg pairs: Pair<String, *>) {
    private var json = JSONObject()

    init {
        add(*pairs)
    }

    private fun add(vararg pairs: Pair<String, *>) {
        for ((key, value) in pairs) {
            when (value) {
                is Boolean -> json.put(key, value)
                is Number -> add(key, value)
                is String -> json.put(key, value)
                is JsonBuilder -> json.put(key, value.json)
                is Array<*> -> add(key, value)
                is JSONObject -> json.put(key, value)
                is JSONArray -> json.put(key, value)
                else -> json.put(key, null) // Or whatever, on illegal input
            }
        }
    }

    private fun add(key: String, value: Number): JsonBuilder {
        when (value) {
            is Int -> json.put(key, value)
            is Long -> json.put(key, value)
            is Float -> json.put(key, value)
            is Double -> json.put(key, value)
            else -> {} // Do what you do on error
        }

        return this
    }

    private fun <T> add(key: String, items: Array<T>): JsonBuilder {
        val jsonArray = JSONArray()
        items.forEach {
            when (it) {
                is String,is Long,is Int, is Boolean -> jsonArray.put(it)
                is JsonBuilder -> jsonArray.put(it.json)
                else -> try {jsonArray.put(it)} catch (ignored:Exception) {/*handle the error*/}
            }
        }

        json.put(key, jsonArray)

        return this
    }

    override fun toString() = json.toString()
}