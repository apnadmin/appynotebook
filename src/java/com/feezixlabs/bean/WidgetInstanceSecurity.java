/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class WidgetInstanceSecurity {
    int widgetId;
    int instanceDefinitionId;
    int roleId;
    int roleType;
    String insertAccess;
    String updateAccess;
    String selectAccess;
    String deleteAccess;

    public String getDeleteAccess() {
        return deleteAccess;
    }

    public String getInsertAccess() {
        return insertAccess;
    }

    public int getInstanceDefinitionId() {
        return instanceDefinitionId;
    }

    public int getRoleId() {
        return roleId;
    }

    public int getRoleType() {
        return roleType;
    }

    public String getSelectAccess() {
        return selectAccess;
    }

    public String getUpdateAccess() {
        return updateAccess;
    }

    public int getWidgetId() {
        return widgetId;
    }

    public void setDeleteAccess(String deleteAccess) {
        this.deleteAccess = deleteAccess;
    }

    public void setInsertAccess(String insertAccess) {
        this.insertAccess = insertAccess;
    }

    public void setInstanceDefinitionId(int instanceDefinitionId) {
        this.instanceDefinitionId = instanceDefinitionId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public void setRoleType(int roleType) {
        this.roleType = roleType;
    }

    public void setSelectAccess(String selectAccess) {
        this.selectAccess = selectAccess;
    }

    public void setUpdateAccess(String updateAccess) {
        this.updateAccess = updateAccess;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }
    
}
