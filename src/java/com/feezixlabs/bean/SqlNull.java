/*
 * SqlNull.java
 *
 * Created on June 2, 2007, 9:45 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.io.Serializable;
/**
 *
 * @author bitlooter
 */
public class SqlNull  implements Serializable {
    private int type;
    /** Creates a new instance of SqlNull */
    public SqlNull(int type) {
        this.type = type;
    }
    public void setType(int type){
        this.type = type;
    }
    public int getType(){
        return type;
    }
}
