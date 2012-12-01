/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class AssignmentSubmission {
    int roomId;
    int userId;
    int assignmentId;
    int contextId;
    int srcContextId;
    int srcPadId;
    String srcType;
    String srcState;
    String submitTime;


    public int getAssignmentId() {
        return assignmentId;
    }

    public int getContextId() {
        return contextId;
    }

    public int getRoomId() {
        return roomId;
    }

    public int getSrcContextId() {
        return srcContextId;
    }

    public int getSrcPadId() {
        return srcPadId;
    }

    public String getSrcState() {
        return srcState;
    }

    public String getSrcType() {
        return srcType;
    }

    public int getUserId() {
        return userId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public void setContextId(int contextId) {
        this.contextId = contextId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public void setSrcContextId(int srcContextId) {
        this.srcContextId = srcContextId;
    }

    public void setSrcPadId(int srcPadId) {
        this.srcPadId = srcPadId;
    }

    public void setSrcState(String srcState) {
        this.srcState = srcState;
    }

    public void setSrcType(String srcType) {
        this.srcType = srcType;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(String submitTime) {
        this.submitTime = submitTime;
    }
}
