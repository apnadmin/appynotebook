/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class FeatureUsage {
    int userId;
    int featureId;
    String usage;

    public int getFeatureId() {
        return featureId;
    }

    public String getUsage() {
        return usage;
    }

    public int getUserId() {
        return userId;
    }

    public void setFeatureId(int featureId) {
        this.featureId = featureId;
    }

    public void setUsage(String usage) {
        this.usage = usage;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
