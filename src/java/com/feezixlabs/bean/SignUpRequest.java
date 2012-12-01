/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

import java.sql.Date;

/**
 *
 * @author bitlooter
 */
public class SignUpRequest {
    int    id;
    String firstName;
    String lastName;
    String email;
    String homePage;
    String course;
    java.sql.Date requestDate;
    String securityToken;

    public String getEmail() {
        return email;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getHomePage() {
        return homePage;
    }

    public String getCourse() {
        return course;
    }

    public int getId() {
        return id;
    }

    public String getLastName() {
        return lastName;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public String getSecurityToken() {
        return securityToken;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setHomePage(String homePage) {
        this.homePage = homePage;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public void setSecurityToken(String securityToken) {
        this.securityToken = securityToken;
    }

}
