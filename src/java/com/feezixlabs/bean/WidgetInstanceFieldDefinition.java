/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class WidgetInstanceFieldDefinition {
    int widgetId;
    int instanceDefinitionId;
    int id;
    String fieldName;
    String fieldNameHash;
    String fieldType;
    String fieldRequired;
    String validationRegex;

    public String getFieldName() {
        return fieldName;
    }

    public String getFieldNameHash() {
        return fieldNameHash;
    }

    public String getFieldType() {
        return fieldType;
    }

    public int getId() {
        return id;
    }

    public int getInstanceDefinitionId() {
        return instanceDefinitionId;
    }

    public int getWidgetId() {
        return widgetId;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public void setFieldNameHash(String fieldNameHash) {
        this.fieldNameHash = fieldNameHash;
    }

    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setInstanceDefinitionId(int instanceDefinitionId) {
        this.instanceDefinitionId = instanceDefinitionId;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }

    public String getValidationRegex() {
        return validationRegex;
    }

    public void setValidationRegex(String validationRegex) {
        this.validationRegex = validationRegex;
    }

    public String getFieldRequired() {
        return fieldRequired;
    }

    public void setFieldRequired(String fieldRequired) {
        this.fieldRequired = fieldRequired;
    }    
}
