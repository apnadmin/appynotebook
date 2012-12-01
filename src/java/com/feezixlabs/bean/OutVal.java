/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.io.Serializable;
import java.sql.Types;

/**
 *
 * @author bitlooter
 */
public class OutVal implements Serializable {
    Object value = new Object();
    int          dataType;

    public OutVal(int dataType){
        this.dataType = dataType;
    }
    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public int getDataType() {
        return dataType;
    }

    public void setDataType(int dataType) {
        this.dataType = dataType;
    }
}
