<%-- 
    Document   : manage-users
    Created on : Jan 9, 2011, 8:17:19 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<table style="width:100%">
    <tr>
        <td style="width:40%" valign="top">
            <input type="hidden" id="phyzixlabs-user-id">
            <table>
                <tr>
                    <td class="signup-label">Name*:</td><td><input type="text" id="phyzixlabs-user-fullname"></td>
                </tr>
                <tr>
                    <td class="signup-label">E-mail*:</td><td><input type="text" id="phyzixlabs-user-email"></td>
                </tr>
                <tr>
                    <td class="signup-label">Roles:</td>
                    <td>
                            <table>
                            <%--
                                for(String role:com.feezixlabs.db.dao.UserDOA.getRoles()){
                                    if(role.compareTo("participant") == 0 || role.compareTo("superuser") == 0)continue;
                            %>
                            <tr><td><input type="checkbox" id="phyzixlabs-user-role-<%=role%>" value="<%=role%>"/></td> <td><%=role%></td></tr>
                            <%}--%>
                                <tr><td><input type="checkbox" id="phyzixlabs-user-role-developer" value="developer"/></td> <td>developer</td></tr>
                                <tr><td><input type="checkbox" id="phyzixlabs-user-role-educator" value="educator"/></td> <td>educator</td></tr>
                                <tr><td><input type="checkbox" id="phyzixlabs-user-role-sysadmin" value="sysadmin"/></td> <td>sysadmin</td></tr>
                                <tr><td><input type="checkbox" id="phyzixlabs-user-role-room_creator" value="room_creator"/></td> <td>room_creator</td></tr>
                            </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:left">
                        <button id="phyzixlabs-user-add-btn" onclick="appletBuilder.addNewUser()" >Add</button> <button onclick="appletBuilder.cancelUserAction()" id="phyzixlabs-user-cancel-btn">Cancel</button>
                    </td>
                    <td style="text-align:right">
                        -OR-<button id="phyzixlabs-user-bulkload-btn" onclick="appletBuilder.bulkLoadUsers()" >Bulk Load Users</button>
                    </td>
                </tr>
            </table>
        </td>
        <td style="width:100%" valign="top">
            <table id="user-table" class="scroll" cellpadding="0" cellspacing="0"></table>
            <div id="user-table-pager" class="scroll" style="text-align:center;"></div>
        </td>
    </tr>
</table>

