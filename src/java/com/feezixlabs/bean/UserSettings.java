/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class UserSettings {
    int userId;
    String devToxonomy;

    public String getDevToxonomy() {
        return devToxonomy;
    }

    public int getUserId() {
        return userId;
    }

    public void setDevToxonomy(String devToxonomy) {
        this.devToxonomy = devToxonomy;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
    
}
