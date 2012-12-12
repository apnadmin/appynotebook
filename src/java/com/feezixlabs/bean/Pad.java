/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author bitlooter
 */
public class Pad {
    int     roomId;
    int     participantId;
    int     contextId;
    int     parentId;
    int     preSibling;
    int     id;
    int     accessControl;
    int     access;
    String  embedKey;
    String  config;
    int     createdBy;
    String  createDate;
    List<Pad> children = new ArrayList<Pad>();
    Pad     parent;
    
    
    public int getContextId() {
        return contextId;
    }

    public int getId() {
        return id;
    }

    public int getParticipantId() {
        return participantId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setContextId(int contextId) {
        this.contextId = contextId;
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

    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
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

    public String getEmbedKey() {
        return embedKey;
    }

    public void setEmbedKey(String embedKey) {
        this.embedKey = embedKey;
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

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getPreSibling() {
        return preSibling;
    }

    public void setPreSibling(int preSibling) {
        this.preSibling = preSibling;
    }

    public List<Pad> getChildren() {
        return children;
    }

    public void setChildren(List<Pad> children) {
        this.children = children;
    }

    public Pad getParent() {
        return parent;
    }

    public void setParent(Pad parent) {
        this.parent = parent;
    }        
}
