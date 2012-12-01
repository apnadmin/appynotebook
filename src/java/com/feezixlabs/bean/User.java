/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class User {
    int    id;
    String userName;
    String passWord;
    String name;
    String emailAddress;
    String role;
    String status;

    String plan;
    String planStatus;
    String stripeCustomerId;
    String planStartDate;
    String nextBillingCycleStartDate;
    String lastInvoiceDate;
    String lastInvoiceId;
    int    teamSize;

    public int getId() {
        return id;
    }

    public String getPassWord() {
        return passWord;
    }

    public String getUserName() {
        return userName;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getLastInvoiceDate() {
        return lastInvoiceDate;
    }

    public String getLastInvoiceId() {
        return lastInvoiceId;
    }

    public String getPlan() {
        return plan;
    }

    public String getPlanStartDate() {
        return planStartDate;
    }

    public String getPlanStatus() {
        return planStatus;
    }

    public String getStripeCustomerId() {
        return stripeCustomerId;
    }

    public String getNextBillingCycleStartDate() {
        return nextBillingCycleStartDate;
    }





    public void setLastInvoiceDate(String lastInvoiceDate) {
        this.lastInvoiceDate = lastInvoiceDate;
    }

    public void setLastInvoiceId(String lastInvoiceId) {
        this.lastInvoiceId = lastInvoiceId;
    }

    public void setPlan(String plan) {
        this.plan = plan;
    }

    public void setPlanStartDate(String planStartDate) {
        this.planStartDate = planStartDate;
    }

    public void setPlanStatus(String planStatus) {
        this.planStatus = planStatus;
    }

    public void setStripeCustomerId(String stripeCustomerId) {
        this.stripeCustomerId = stripeCustomerId;
    }

    public int getTeamSize() {
        return teamSize;
    }

    public void setTeamSize(int teamSize) {
        this.teamSize = teamSize;
    }

    public void setNextBillingCycleStartDate(String nextBillingCycleStartDate) {
        this.nextBillingCycleStartDate = nextBillingCycleStartDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
