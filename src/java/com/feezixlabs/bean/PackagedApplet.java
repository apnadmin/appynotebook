/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class PackagedApplet {
    String packageId;
    int    id;
    String name;
    String description;
    String installed;
    int    appletId;
    String category;

    public int getAppletId() {
        return appletId;
    }

    public String getDescription() {
        return description;
    }

    public int getId() {
        return id;
    }

    public String getInstalled() {
        return installed;
    }

    public String getName() {
        return name;
    }

    public String getPackageId() {
        return packageId;
    }

    public String getCategory() {
        return category;
    }

    public void setAppletId(int appletId) {
        this.appletId = appletId;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setInstalled(String installed) {
        this.installed = installed;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }

    public void setCategory(String category) {
        this.category = category;
    }
    
}
