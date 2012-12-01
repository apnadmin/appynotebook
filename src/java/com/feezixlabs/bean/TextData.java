/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class TextData {
    String id;
    String description;
    String data;

    public String getData() {
        return data;
    }

    public String getDescription() {
        return description;
    }

    public String getId() {
        return id;
    }

    public void setData(String data) {
        this.data = data;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setId(String id) {
        this.id = id;
    }
}
