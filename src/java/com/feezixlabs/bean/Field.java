/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class Field {
    int     roomId;
    int     participantId;
    int     contextId;
    int     padId;
    int     elementId;
    int     id;
    String  value;
    String  type;
    String  propertyReference;
    String  propertyReferenceHash;
    int     accessControl;
    int     access;
    int     createdBy;
    String  createDate;

    public int getAccess() {
        return access;
    }

    public int getAccessControl() {
        return accessControl;
    }

    public int getContextId() {
        return contextId;
    }

    public String getCreateDate() {
        return createDate;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public int getElementId() {
        return elementId;
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

    public String getPropertyReference() {
        return propertyReference;
    }

    public String getPropertyReferenceHash() {
        return propertyReferenceHash;
    }

    public int getRoomId() {
        return roomId;
    }

    public String getType() {
        return type;
    }

    public String getValue() {
        return value;
    }

    public void setAccess(int access) {
        this.access = access;
    }

    public void setAccessControl(int accessControl) {
        this.accessControl = accessControl;
    }

    public void setContextId(int contextId) {
        this.contextId = contextId;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public void setElementId(int elementId) {
        this.elementId = elementId;
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

    public void setPropertyReference(String propertyReference) {
        this.propertyReference = propertyReference;
    }

    public void setPropertyReferenceHash(String propertyReferenceHash) {
        this.propertyReferenceHash = propertyReferenceHash;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setValue(String value) {
        this.value = value;
    }
    
}
