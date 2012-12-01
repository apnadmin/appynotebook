/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class WidgetInstanceFieldValidation {
    int widgetId;
    int instanceDefinitionId;
    int instanceFieldDefinitionId; 
    String regex;

    public int getInstanceDefinitionId() {
        return instanceDefinitionId;
    }

    public int getInstanceFieldDefinitionId() {
        return instanceFieldDefinitionId;
    }

    public String getRegex() {
        return regex;
    }

    public int getWidgetId() {
        return widgetId;
    }

    public void setInstanceDefinitionId(int instanceDefinitionId) {
        this.instanceDefinitionId = instanceDefinitionId;
    }

    public void setInstanceFieldDefinitionId(int instanceFieldDefinitionId) {
        this.instanceFieldDefinitionId = instanceFieldDefinitionId;
    }

    public void setRegex(String regex) {
        this.regex = regex;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }
    
}
