/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;


/**
 *
 * @author bitlooter
 */
public class Assignment {
    int roomId;
    int id;
    int userId;
    String openDate;
    String closeDate;
    String timeZone;
    String name;
    int notificationId;
    String status;
    String allowVersioning;
    int versioningLimit;
    String firstReminderDate;
    int reminderRepeatInterval;
    int reminderRepeatCount;

    public String getCloseDate() {
        return closeDate;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getOpenDate() {
        return openDate;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setCloseDate(String closeDate) {
        this.closeDate = closeDate;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setOpenDate(String openDate) {
        this.openDate = openDate;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getAllowVersioning() {
        return allowVersioning;
    }

    public int getVersioningLimit() {
        return versioningLimit;
    }

    public void setAllowVersioning(String allowVersioning) {
        this.allowVersioning = allowVersioning;
    }

    public void setVersioningLimit(int versioningLimit) {
        this.versioningLimit = versioningLimit;
    }

    public String getFirstReminderDate() {
        return firstReminderDate;
    }

    public int getReminderRepeatCount() {
        return reminderRepeatCount;
    }

    public int getReminderRepeatInterval() {
        return reminderRepeatInterval;
    }

    public void setFirstReminderDate(String firstReminderDate) {
        this.firstReminderDate = firstReminderDate;
    }

    public void setReminderRepeatCount(int reminderRepeatCount) {
        this.reminderRepeatCount = reminderRepeatCount;
    }

    public void setReminderRepeatInterval(int reminderRepeatInterval) {
        this.reminderRepeatInterval = reminderRepeatInterval;
    }
    
}
