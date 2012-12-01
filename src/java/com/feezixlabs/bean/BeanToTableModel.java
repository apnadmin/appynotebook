/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class BeanToTableModel {
    String[][] colDefinitions = null;
    java.lang.Class beanType;

    public Class getBeanType() {
        return beanType;
    }

    public String[][] getColDefinitions() {
        return colDefinitions;
    }

    public void setBeanType(Class beanType) {
        this.beanType = beanType;
    }

    public void setColDefinitions(String[][] colDefinitions) {
        this.colDefinitions = colDefinitions;
    }
    
}
