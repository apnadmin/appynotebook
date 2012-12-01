/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class WidgetInstanceDefinition {
    int widgetId;
    int id;
    String name;
    String description;
    String json;
    String typeFieldId;
    String insertConstraintCode;
    String updateConstraintCode;
    String selectConstraintCode;
    String deleteConstraintCode;
    String insertConstraintEnabled;
    String updateConstraintEnabled;
    String selectConstraintEnabled;
    String deleteConstraintEnabled;

    public String getDeleteConstraintCode() {
        return deleteConstraintCode;
    }

    public String getDeleteConstraintEnabled() {
        return deleteConstraintEnabled;
    }

    public int getId() {
        return id;
    }

    public String getInsertConstraintCode() {
        return insertConstraintCode;
    }

    public String getInsertConstraintEnabled() {
        return insertConstraintEnabled;
    }

    public String getJson() {
        return json;
    }

    public String getSelectConstraintCode() {
        return selectConstraintCode;
    }

    public String getSelectConstraintEnabled() {
        return selectConstraintEnabled;
    }

    public String getTypeFieldId() {
        return typeFieldId;
    }

    public String getUpdateConstraintCode() {
        return updateConstraintCode;
    }

    public String getUpdateConstraintEnabled() {
        return updateConstraintEnabled;
    }

    public int getWidgetId() {
        return widgetId;
    }

    public void setDeleteConstraintCode(String deleteConstraintCode) {
        this.deleteConstraintCode = deleteConstraintCode;
    }

    public void setDeleteConstraintEnabled(String deleteConstraintEnabled) {
        this.deleteConstraintEnabled = deleteConstraintEnabled;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setInsertConstraintCode(String insertConstraintCode) {
        this.insertConstraintCode = insertConstraintCode;
    }

    public void setInsertConstraintEnabled(String insertConstraintEnabled) {
        this.insertConstraintEnabled = insertConstraintEnabled;
    }

    public void setJson(String json) {
        this.json = json;
    }

    public void setSelectConstraintCode(String selectConstraintCode) {
        this.selectConstraintCode = selectConstraintCode;
    }

    public void setSelectConstraintEnabled(String selectConstraintEnabled) {
        this.selectConstraintEnabled = selectConstraintEnabled;
    }

    public void setTypeFieldId(String typeFieldId) {
        this.typeFieldId = typeFieldId;
    }

    public void setUpdateConstraintCode(String updateConstraintCode) {
        this.updateConstraintCode = updateConstraintCode;
    }

    public void setUpdateConstraintEnabled(String updateConstraintEnabled) {
        this.updateConstraintEnabled = updateConstraintEnabled;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }

    public String getDescription() {
        return description;
    }

    public String getName() {
        return name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setName(String name) {
        this.name = name;
    }
    
}
