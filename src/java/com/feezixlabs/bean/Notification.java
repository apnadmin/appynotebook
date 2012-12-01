/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;


/**
 *
 * @author bitlooter
 */
public class Notification {
    String startTime;
    String endTime;
    String timeZone;
    long   repeatInterval;
    int    repeatIntervalCount;
    String variableDefinitions;
    String messageTemplate;
    String messagingMedium;
    String state;
    int    id;

    public String getEndTime() {
        return endTime;
    }

    public String getMessageTemplate() {
        return messageTemplate;
    }

    public String getMessagingMedium() {
        return messagingMedium;
    }

    public long getRepeatInterval() {
        return repeatInterval;
    }

    public int getRepeatIntervalCount() {
        return repeatIntervalCount;
    }

    public String getStartTime() {
        return startTime;
    }

    public String getState() {
        return state;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public String getVariableDefinitions() {
        return variableDefinitions;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public void setMessageTemplate(String messageTemplate) {
        this.messageTemplate = messageTemplate;
    }

    public void setMessagingMedium(String messagingMedium) {
        this.messagingMedium = messagingMedium;
    }

    public void setRepeatInterval(long repeatInterval) {
        this.repeatInterval = repeatInterval;
    }

    public void setRepeatIntervalCount(int repeatIntervalCount) {
        this.repeatIntervalCount = repeatIntervalCount;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    public void setVariableDefinitions(String variableDefinitions) {
        this.variableDefinitions = variableDefinitions;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

}
