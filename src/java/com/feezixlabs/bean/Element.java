/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class Element {
    int     roomId;
    int     participantId;
    int     contextId;
    int     padId;
    int     id;
    String  config;
    int     accessControl;
    int     access;
    int     createdBy;
    String  createDate;
    
    
    public String getConfig() {
        return config;
    }

    public int getContextId() {
        return contextId;
    }

    public int getId() {
        return id;
    }

    public int getPadId() {
        return padId;
    }

    public int getParticipantId() {
        return participantId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    public void setContextId(int contextId) {
        this.contextId = contextId;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setPadId(int padId) {
        this.padId = padId;
    }

    public void setParticipantId(int participantId) {
        this.participantId = participantId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getAccess() {
        return access;
    }

    public int getAccessControl() {
        return accessControl;
    }

    public void setAccess(int access) {
        this.access = access;
    }

    public void setAccessControl(int accessControl) {
        this.accessControl = accessControl;
    }

    public String getCreateDate() {
        return createDate;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
    
}
