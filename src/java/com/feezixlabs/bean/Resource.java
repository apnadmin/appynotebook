/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.util.Date;
/**
 *
 * @author bitlooter
 */
public class Resource {
    int widgetId;
    String fileName;
    String label;
    String fsName;
    String type;
    String mime;
    Date   createDate;
    Date   lastModDate;
    int size;
    String isZipArchive;

    public void setSize(int size) {
        this.size = size;
    }

    public int getSize() {
        return size;
    }


    public String getFileName() {
        return fileName;
    }

    public String getFsName() {
        return fsName;
    }

    public String getLabel() {
        return label;
    }

    public String getMime() {
        return mime;
    }

    public String getType() {
        return type;
    }

    public int getWidgetId() {
        return widgetId;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public void setFsName(String fsName) {
        this.fsName = fsName;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public void setMime(String mime) {
        this.mime = mime;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
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

    public String getIsZipArchive() {
        return isZipArchive;
    }

    public void setIsZipArchive(String isZipArchive) {
        this.isZipArchive = isZipArchive;
    }
    
}
