<%-- 
    Document   : user-settings
    Created on : Apr 20, 2012, 8:45:02 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="ui-widget-content ui-corner-top" style="background:url(../../img/bg_dotted-v1.png)">
    <div id="user-settings-tabcontrol">

        <ul id="user-settings-tabcontrol-headers">
            <li><a style="font-weight:bold" href="#content-access-control-tab"><span style="float:left" class="ui-icon ui-icon-key"></span>Manage Access</a></li>
            <li><a style="font-weight:bold" href="#user-profile-tab"><span style="float:left" class="ui-icon ui-icon-person"></span>Your Profile</a></li>
        </ul>

        <div id="content-access-control-tab" style="padding:0;margin: 0">

                
                <table style="border-style:none;border-spacing:0;margin-left: auto;margin-right: auto">
                    <tr>
                        <td colspan="2">
                            <div class="ui-corner-top ui-widget-header" style="margin-top:8px;margin-bottom:0px;padding:8px;border-bottom: 0">Group Access</div>
                            <div class="ui-corner-bottom ui-widget-content" style="padding: 5px">
                                <input type="radio" name="room-access-type" value="0"/>Private <input type="radio" name="room-access-type" value="1"/>Public <br/>
                                <div id="public-access-settings" style="display:none">
                                    <span>Public Access Code</span><br/>
                                    <input type="text" id="room-access-code"/> <button id="change-room-access-code-button">Change</button><br/>
                                    <span>Public Access URL</span><br/>
                                    <input type="text" size="64" id="room-public-access-url" /><br/><br/>
                                </div>                         
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="border-style:none; border-collapse: collapse;border-spacing: 0;padding-bottom: 0">
                            <div class="ui-corner-top ui-widget-header" style="margin-top:8px;margin-bottom:0px;padding:8px;border-bottom: 0">Grant Access to Users</div>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;padding-top: 0px">
                            <table id="user-access-control-list" style="border-top:0" class="scroll" cellpadding="0" cellspacing="0"></table>
                            <div id="user-access-control-list-pager" class="scroll" style="text-align:center;"></div>
                        </td>
                        <td style="padding-top: 0px">
                            <table id="content-access-control-list" style="border-top:0" class="scroll" cellpadding="0" cellspacing="0"></table>
                            <div id="content-access-control-list-pager" class="scroll" style="text-align:center;"></div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="ui-widget-content ui-corner-bottom" style="padding:5px;text-align: center">
                                <button id="save-access-control-settings-button" >Save Changes</button>
                            </div> 
                        </td>
                    </tr>
                </table>            
        </div>
        <div id="user-profile-tab">
            <div class="ui-corner-all ui-widget-content" style="padding:4px;background-color: white;width:150px;margin-bottom: 8px;">
                <img id="user-setting-profile-photo" src="ceo.png" width="140" height="140"/>
                <button id="update-profile-photo-btn" style="left:126px;top:-142px">change</button>
            </div>

            <div>
                <div class="ui-corner-all ui-widget-header" style="padding:8px;display:inline">
                    <span id="profile-user-fullname"></span> <input type="text" size="64" style="display:none" id="profile-user-fullname-textfield"/><button id="update-profile-fullname-edit-btn">Change</button><button id="update-profile-fullname-save-btn">Save</button><button id="update-profile-fullname-cancel-btn">Cancel</button>
                </div>
            </div>

            <%
                com.feezixlabs.bean.User user = com.feezixlabs.db.dao.UserDOA.getUser(request.getUserPrincipal().getName());

            %>
            <div class="ui-corner-top ui-widget-header" style="margin-top:8px;margin-bottom:0px;padding:8px"><span id="current-plan-info-display">You currently have the '<span id="current-plan-name-display"><%=user.getPlan() %></span>' plan.</span></div>

            
            <div class="ui-corner-bottom ui-widget-content" style="padding:4px;background-color: white;border-top: 0px">
                <button id="upgrade-plan-button" style="display:none">Upgrade</button>
                <button id="change-to-team-plan-button" style="display:none">Change to Team plan</button>

                <button id="change-team-plan-size-payment-info-button" style="display:none">Change Team size/Payment information</button>
                <button id="change-payment-info-button" style="display:none">Change payment information</button>


                <button id="change-to-individual-plan-button" style="display:none">Change to Individual plan</button>

                <button id="cancel-to-basic-plan-button" style="display:none"> Cancel current plan</button>
            </div>
            
            <div class="ui-corner-top ui-widget-header" style="margin-top:8px;margin-bottom:0px;padding:8px;">Change login email</div>
            <div class="ui-corner-bottom ui-widget-content" style="padding:4px;padding-left: 0;background-color: white;border-top: 0px">
                <div class="ui-corner-bottom ui-widget-header" style="padding:8px;display:inline">
                    <span id="profile-user-login-email"><%=user.getEmailAddress() %></span> <input type="text" size="64" style="display:none" id="profile-user-login-email-textfield"/><button id="update-profile-login-email-edit-btn">Change</button><button id="update-profile-login-email-save-btn">Save</button><button id="update-profile-login-email-cancel-btn">Cancel</button>
                </div>
            </div>            
            
            <div class="ui-corner-top ui-widget-header" style="margin-top:8px;margin-bottom:0px;padding:8px;">Change password</div>
            <div class="ui-corner-bottom ui-widget-content" style="padding:4px;background-color: white;border-top: 0px">
                <table>
                    <tr>
                        <td>
                            Current Password
                        </td>
                        <td>
                            <input type="password" id="profile-user-current-password-textfield"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        New Password
                        </td>
                        <td>
                            <input type="password" id="profile-user-new-password-textfield"/>
                        </td>
                    </tr>                
                    <tr>
                        <td>
                        Confirm New Password
                        </td>
                        <td>
                            <input type="password" id="profile-user-confirm-new-password-textfield"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align:right">
                            <button id="update-user-profile-password-btn">Change Password</button>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>

</div>