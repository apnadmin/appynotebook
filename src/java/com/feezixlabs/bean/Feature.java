/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class Feature {
    int    id;
    String name;
    String basicPlanLimit;
    String individualPlanLimit;
    String teamPlanLimit;
    String displayText;
    String basicPlanLimitDisplayText;
    String individualPlanLimitDisplayText;
    String teamPlanLimitDisplayText;
    String display;


    public String getBasicPlanLimit() {
        return basicPlanLimit;
    }

    public int getId() {
        return id;
    }

    public String getIndividualPlanLimit() {
        return individualPlanLimit;
    }

    public String getName() {
        return name;
    }

    public String getTeamPlanLimit() {
        return teamPlanLimit;
    }

    public void setBasicPlanLimit(String basicPlanLimit) {
        this.basicPlanLimit = basicPlanLimit;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setIndividualPlanLimit(String individualPlanLimit) {
        this.individualPlanLimit = individualPlanLimit;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTeamPlanLimit(String teamPlanLimit) {
        this.teamPlanLimit = teamPlanLimit;
    }

    public String getBasicPlanLimitDisplayText() {
        return basicPlanLimitDisplayText;
    }

    public String getDisplayText() {
        return displayText;
    }

    public String getIndividualPlanLimitDisplayText() {
        return individualPlanLimitDisplayText;
    }

    public String getTeamPlanLimitDisplayText() {
        return teamPlanLimitDisplayText;
    }

    public void setBasicPlanLimitDisplayText(String basicPlanLimitDisplayText) {
        this.basicPlanLimitDisplayText = basicPlanLimitDisplayText;
    }

    public void setDisplayText(String displayText) {
        this.displayText = displayText;
    }

    public void setIndividualPlanLimitDisplayText(String individualPlanLimitDisplayText) {
        this.individualPlanLimitDisplayText = individualPlanLimitDisplayText;
    }

    public void setTeamPlanLimitDisplayText(String teamPlanLimitDisplayText) {
        this.teamPlanLimitDisplayText = teamPlanLimitDisplayText;
    }

    public String getDisplay() {
        return display;
    }

    public void setDisplay(String display) {
        this.display = display;
    }
 
}
