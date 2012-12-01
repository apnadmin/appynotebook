<%-- 
    Document   : system-settings
    Created on : Jan 23, 2011, 2:53:26 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<table>
    <%if(request.isUserInRole("sysadmin")){%>
    <tr>
        <td class="signup-label">System Name:</td><td><input type="text" id="phyzixlabs-system-setting-installation_name" size="64" value="<%= com.feezixlabs.util.ConfigUtil.installation_name %>"/></td>
    </tr>
    <tr>
        <td class="signup-label">Allow Users To Create Accounts:</td><td><input type="checkbox" id="phyzixlabs-system-setting-allow_user_account_creation" <%= com.feezixlabs.util.ConfigUtil.allow_user_account_creation?"checked":"" %>/></td>
    </tr>
    <tr>
        <td class="signup-label">Allow Auto-Login after Signup:</td><td><input type="checkbox" id="phyzixlabs-system-setting-allow_auto_login_after_signup" <%= com.feezixlabs.util.ConfigUtil.allow_auto_login_after_signup?"checked":"" %>/></td>
    </tr>    
    <tr>
        <td class="signup-label">Allow Auto Signup:</td><td><input type="checkbox" id="phyzixlabs-system-setting-allow_auto_signup" <%= com.feezixlabs.util.ConfigUtil.allow_auto_signup?"checked":"" %>/></td>
    </tr>     
    <tr>
        <td class="signup-label">Default User Roles:</td>
        <td>
            <table>
                <%
                    String[] default_roles = com.feezixlabs.util.ConfigUtil.default_roles.split(",");
                    String developer = "";
                    String educator  = "";
                    String room_creator = "";
                    for(int i=0;i<default_roles.length;i++){
                        if(default_roles[i].compareToIgnoreCase("developer") == 0)
                            developer = "checked";
                        else
                        if(default_roles[i].compareToIgnoreCase("educator") == 0)
                            educator = "checked";
                        else
                        if(default_roles[i].compareToIgnoreCase("room_creator") == 0)
                            room_creator = "checked";
                    }
                %>
                <tr><td><input type="checkbox" id="phyzixlabs-system-setting-default_roles-developer" value="developer" <%=developer%>/></td> <td>developer</td></tr>
                <tr><td><input type="checkbox" id="phyzixlabs-system-setting-default_roles-educator" value="educator" <%=educator%>/></td> <td>educator</td></tr>
                <tr><td><input type="checkbox" id="phyzixlabs-system-setting-default_roles-room_creator" value="room_creator" <%=room_creator%>/></td> <td>room_creator</td></tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="signup-label">Restrict Access To E-mail Domains:</td><td><input type="text" size="64" id="phyzixlabs-system-setting-restrict_access_to_domains" value="<%= com.feezixlabs.util.ConfigUtil.restrict_access_to_domains %>"/></td>
    </tr>
    <tr>
        <td class="signup-label">Enable Http Proxy:</td><td><input type="checkbox" id="phyzixlabs-system-setting-enable_http_proxy" <%= com.feezixlabs.util.ConfigUtil.enable_http_proxy?"checked":"" %>/></td>
    </tr>
    <tr>
        <td class="signup-label">Enable Content Importing:</td><td><input type="checkbox" id="phyzixlabs-system-setting-enable_content_importing" <%= com.feezixlabs.util.ConfigUtil.enable_content_importing?"checked":"" %>/></td>
    </tr>

    <tr>
        <td class="signup-label">Help Url:</td><td><input type="text" id="phyzixlabs-system-setting-hadron_help_url" size="64" value="<%= com.feezixlabs.util.ConfigUtil.hadron_help_url %>"/></td>
    </tr>
    <tr>
        <td class="signup-label">Image Serving Url:</td><td><input type="text" id="phyzixlabs-system-setting-file_serving_url_prefix" size="64" value="<%= com.feezixlabs.util.ConfigUtil.file_serving_url_prefix %>"/></td>
    </tr>
    <tr>
        <td class="signup-label">MQ Rate:</td><td><input type="text" id="phyzixlabs-system-setting-mq-rate" size="8" value="<%= com.feezixlabs.util.ConfigUtil.active_mq_rate %>"/></td>
    </tr>
    <tr>
        <td class="signup-label">Pass-through App Deployment:</td><td><input type="checkbox" id="phyzixlabs-system-setting-applet_deployment_policy" <%= com.feezixlabs.util.ConfigUtil.applet_deployment_policy.compareTo("passthrough")==0?"checked":"" %>/></td>
    </tr>
    <tr>
        <td class="signup-label">Default Content Access:</td>
        <td>
            
            <table>
                <tr>
                    <td style="text-align:right">
                        Binder:
                    </td>
                    <td>
                        Read <input type="checkbox" id="phyzixlabs-system-setting-default_binder_access-read" <%= (com.feezixlabs.util.ConfigUtil.default_binder_access&com.feezixlabs.util.ConfigUtil.ACCESS_READ)>0?"checked":"" %>/>
                        Write <input type="checkbox" id="phyzixlabs-system-setting-default_binder_access-write" <%= (com.feezixlabs.util.ConfigUtil.default_binder_access&com.feezixlabs.util.ConfigUtil.ACCESS_WRITE)>0?"checked":"" %>/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Page:
                    </td>
                    <td>
                        Read <input type="checkbox" id="phyzixlabs-system-setting-default_page_access-read" <%= (com.feezixlabs.util.ConfigUtil.default_page_access&com.feezixlabs.util.ConfigUtil.ACCESS_READ)>0?"checked":"" %>/>
                        Write <input type="checkbox" id="phyzixlabs-system-setting-default_page_access-write" <%= (com.feezixlabs.util.ConfigUtil.default_page_access&com.feezixlabs.util.ConfigUtil.ACCESS_WRITE)>0?"checked":"" %>/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Element:
                    </td>
                    <td>
                        Read <input type="checkbox" id="phyzixlabs-system-setting-default_element_access-read" <%= (com.feezixlabs.util.ConfigUtil.default_element_access&com.feezixlabs.util.ConfigUtil.ACCESS_READ)>0?"checked":"" %>/>
                        Write <input type="checkbox" id="phyzixlabs-system-setting-default_element_access-write" <%= (com.feezixlabs.util.ConfigUtil.default_element_access&com.feezixlabs.util.ConfigUtil.ACCESS_WRITE)>0?"checked":"" %>/>
                    </td>
                </tr>
            </table>

        </td>
    </tr>

    <%if(request.isUserInRole("superuser")){%>
        <tr>
            <td class="signup-label">System URL:</td><td><input type="text" size="64" id="phyzixlabs-system-setting-baseUrl" value="<%= com.feezixlabs.util.ConfigUtil.baseUrl %>"/></td>
        </tr>
        <tr>
            <td class="signup-label">System Login URL:</td><td><input type="text" size="64" id="phyzixlabs-system-setting-installation_login_url" value="<%= com.feezixlabs.util.ConfigUtil.installation_login_url %>"/></td>
        </tr>
        <tr>
            <td class="signup-label">System User Limit:</td><td><input type="text" size="64" id="phyzixlabs-system-setting-system_user_limit" value="<%= com.feezixlabs.util.ConfigUtil.system_user_limit %>"/></td>
        </tr>
        <tr>
            <td class="signup-label">Explore & Learn URL:</td><td><input type="text" size="64" id="phyzixlabs-system-setting-explore_and_learn_url" value="<%= com.feezixlabs.util.ConfigUtil.explore_and_learn_url %>"/></td>
        </tr>
        <tr>
            <td class="signup-label">What's New URL:</td><td><input type="text" size="64" id="phyzixlabs-system-setting-whats_new_url" value="<%= com.feezixlabs.util.ConfigUtil.whats_new_url %>"/></td>
        </tr>
        <tr>
            <td class="signup-label">Enable Applet Import:</td><td><input type="checkbox" id="phyzixlabs-system-setting-enable_applet_import" <%= com.feezixlabs.util.ConfigUtil.enable_applet_import?"checked":"" %>/></td>
        </tr>
        <tr>
            <td class="signup-label">Enable Load Sample Applets:</td><td><input type="checkbox" id="phyzixlabs-system-setting-load_sample_applets" <%= com.feezixlabs.util.ConfigUtil.load_sample_applets?"checked":"" %>/></td>
        </tr>
        <tr>
            <td class="signup-label">Enable Applet Deployment:</td><td><input type="checkbox" id="phyzixlabs-system-setting-enable_applet_deployment" <%= com.feezixlabs.util.ConfigUtil.enable_applet_deployment?"checked":"" %>/></td>
        </tr>
        <tr>
            <td class="signup-label">Timezone List:</td><td><textarea cols="16" rows="16" id="phyzixlabs-system-setting-timezone_list"> <%= com.feezixlabs.util.ConfigUtil.timezone_list %></textarea></td>
        </tr>
        <tr>
            <td class="signup-label">Stripe Public Key:</td><td><input type="text" id="phyzixlabs-system-setting-stripe_public_key" value="<%= com.feezixlabs.util.ConfigUtil.stripe_public_key %>"/></td>
        </tr>
        <tr>
            <td class="signup-label">Stripe Secret Key:</td><td><input type="text" id="phyzixlabs-system-setting-stripe_secret_key" value="<%= com.feezixlabs.util.ConfigUtil.stripe_secret_key %>"/></td>
        </tr>
    <%}%>


    <tr>
        <td class="signup-label">Account Creation E-mail Confirmation Sender:</td>
        <td>
            <table>
                <tr>
                    <td style="text-align:right">
                        User Name:
                    </td>
                    <td>
                        <input type="text" id="phyzixlabs-system-setting-account_create_notifier" value="<%= com.feezixlabs.util.ConfigUtil.account_create_notifier %>"/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Password:
                    </td>
                    <td>
                        <input type="text" id="phyzixlabs-system-setting-account_create_notifier_password" value="<%= com.feezixlabs.util.ConfigUtil.account_create_notifier_password %>"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="signup-label">Room Invite E-mail Confirmation Sender:</td>
        <td>
            <table>
                <tr>
                    <td style="text-align:right">
                        User Name:
                    </td>
                    <td>
                        <input type="text" id="phyzixlabs-system-setting-invite_notifier" value="<%= com.feezixlabs.util.ConfigUtil.invite_notifier %>"/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Password:
                    </td>
                    <td>
                        <input type="text" id="phyzixlabs-system-setting-invite_notifier_password" value="<%= com.feezixlabs.util.ConfigUtil.invite_notifier_password %>"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td class="signup-label">App notification Sender:</td>
        <td>
            <table>
                <tr>
                    <td style="text-align:right">
                        User Name:
                    </td>
                    <td>
                        <input type="text" id="phyzixlabs-system-setting-app_notifier" value="<%= com.feezixlabs.util.ConfigUtil.app_notifier %>"/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Password:
                    </td>
                    <td>
                        <input type="text" id="phyzixlabs-system-setting-app_notifier_password" value="<%= com.feezixlabs.util.ConfigUtil.app_notifier_password %>"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
</table>
    <div style="text-align: center;font-size:16px;font-weight:bold">
        <button onclick="appletBuilder.saveSystemSettings()">Save</button>
    </div>