<%-- 
    Document   : start-page
    Created on : Jan 9, 2011, 12:42:50 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<div style="text-align: center;background-color: #cfdce3" id="home-container">
    <div style="height:96px;background-image: url('img/banner.png');background-repeat: repeat-y">
        <h1 style="color: #3cb2ec;padding-top:25px"><span style="font-style:italic;color:#e04613">APPYnotebook</span> APP Development Environment</h1>
    </div>
    <table style="margin-left:auto;margin-right:auto">
        <tr>
            <td>
                <h1 style="color:#e04613;text-align: left">Learn & Explore</h1>
            </td>
            <td>
                <h1 style="color:#e04613;text-align: left">What's New?</h1>
            </td>
        </tr>
        <tr>
            <td>
                <div class="ui-corner-all ui-widget-content" style="border-style: solid;border-width: 2px">
                    <iframe src="<%= com.feezixlabs.util.ConfigUtil.explore_and_learn_url %>" width="400" height="400" style="border:none;" />
                </div>
            </td>
            <td>
                <div class="ui-corner-all ui-widget-content" style="border-style: solid;border-width: 2px">
                    <iframe src="<%= com.feezixlabs.util.ConfigUtil.whats_new_url %>" width="400" height="400" style="border:none;" />
                </div>
            </td>
        </tr>
    </table>
</div>
