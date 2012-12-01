/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class Context {
    int     roomId;
    int     participantId;
    int     id;
    int     accessControl;
    int     access;
    int     createdBy;
    String  createDate;
    String  config;

    public int getId() {
        return id;
    }

    public int getParticipantId() {
        return participantId;
    }

    public int getRoomId() {
        return roomId;
    }


    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setParticipantId(int participantId) {
        this.participantId = participantId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getAccessControl() {
        return accessControl;
    }

    public void setAccessControl(int accessControl) {
        this.accessControl = accessControl;
    }

    public int getAccess() {
        return access;
    }

    public void setAccess(int access) {
        this.access = access;
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
