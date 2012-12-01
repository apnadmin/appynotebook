/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.sql.Date;

/**
 *
 * @author bitlooter
 */
public class Widget {
    int id;
    int    creatorId;
    String name;
    String description;
    int iconId;
    String code;
    String status;
    String version;
    String authorName;
    String authorLink;
    String category;
    String tags;
    String showInMenu;
    String defaultInstance;
    String question;
    float  price;
    int    catalogPage;
    java.sql.Date createDate;
    java.sql.Date lastModDate;
    String devToxonomy;
    String uniqueKey;
    
    public String getCode() {
        return code;
    }

    public int getIconId() {
        return iconId;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getStatus() {
        return status;
    }

    public String getVersion() {
        return version;
    }


    public void setCode(String code) {
        this.code = code;
    }

    public void setIconId(int iconId) {
        this.iconId = iconId;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public int getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(int creatorId) {
        this.creatorId = creatorId;
    }

    public String getAuthorLink() {
        return authorLink;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorLink(String authorLink) {
        this.authorLink = authorLink;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getCategory() {
        return category;
    }

    public String getTags() {
        return tags;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getShowInMenu() {
        return showInMenu;
    }

    public void setShowInMenu(String showInMenu) {
        this.showInMenu = showInMenu;
    }

    public String getDefaultInstance() {
        return defaultInstance;
    }

    public float getPrice() {
        return price;
    }

    public String getQuestion() {
        return question;
    }

    public void setDefaultInstance(String defaultInstance) {
        this.defaultInstance = defaultInstance;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public int getCatalogPage() {
        return catalogPage;
    }

    public void setCatalogPage(int catalogPage) {
        this.catalogPage = catalogPage;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public Date getLastModDate() {
        return lastModDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public void setLastModDate(Date lastModDate) {
        this.lastModDate = lastModDate;
    }

    public String getDevToxonomy() {
        return devToxonomy;
    }

    public void setDevToxonomy(String devToxonomy) {
        this.devToxonomy = devToxonomy;
    }

    public String getUniqueKey() {
        return uniqueKey;
    }

    public void setUniqueKey(String uniqueKey) {
        this.uniqueKey = uniqueKey;
    }
    
}
