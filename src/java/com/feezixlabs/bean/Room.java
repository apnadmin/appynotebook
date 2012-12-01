/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author bitlooter
 */
public class Room {
    java.util.List<Participant> participants;
    Participant                 creator;
    int                         userId;
    String                      title;
    int                         page = 1;
    int                         id;
    java.util.Date              createDate;
    String                      accessCode;
    String                      topicUri;
    int                         requesterId;
    String                      requesterSecureToken;
    int                         accessControl;

    public Participant getCreator() {
        return creator;
    }

    public String getTitle() {
        return title;
    }

    public List<Participant> getParticipants() {
        return participants;
    }

    public void setCreator(Participant creator) {
        this.creator = creator;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setParticipants(List<Participant> participants) {
        this.participants = participants;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAccessCode() {
        return accessCode;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public int getUserId() {
        return userId;
    }

    public String getTopicUri() {
        return topicUri;
    }

    public void setAccessCode(String accessCode) {
        this.accessCode = accessCode;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public void setUserId(int creatorId) {
        this.userId = creatorId;
    }

    public void setTopicUri(String topicUri) {
        this.topicUri = topicUri;
    }

    public int getRequesterId() {
        return requesterId;
    }

    public void setRequesterId(int requesterId) {
        this.requesterId = requesterId;
    }

    public String getRequesterSecureToken() {
        return requesterSecureToken;
    }

    public void setRequesterSecureToken(String requesterSecureToken) {
        this.requesterSecureToken = requesterSecureToken;
    }

    public void setAccessControl(int accessControl) {
        this.accessControl = accessControl;
    }

    public int getAccessControl() {
        return accessControl;
    }
    
}
