/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.bean;

/**
 *
 * @author bitlooter
 */
public class WidgetDependency {
    int widgetId;
    String dependencyId;
    String dependencyPath;

    public String getDependencyId() {
        return dependencyId;
    }

    public String getDependencyPath() {
        return dependencyPath;
    }

    public int getWidgetId() {
        return widgetId;
    }

    public void setDependencyId(String dependencyId) {
        this.dependencyId = dependencyId;
    }

    public void setDependencyPath(String dependencyPath) {
        this.dependencyPath = dependencyPath;
    }

    public void setWidgetId(int widgetId) {
        this.widgetId = widgetId;
    }
}
