/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class PadAccess {
    int     roomId;
    int     participantId;
    int     contextId;
    int     id;
    int     access;
    int     grantedTo;

    public int getAccess() {
        return access;
    }

    public int getContextId() {
        return contextId;
    }

    public int getGrantedTo() {
        return grantedTo;
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

    public void setAccess(int access) {
        this.access = access;
    }

    public void setContextId(int contextId) {
        this.contextId = contextId;
    }

    public void setGrantedTo(int grantedTo) {
        this.grantedTo = grantedTo;
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
}
