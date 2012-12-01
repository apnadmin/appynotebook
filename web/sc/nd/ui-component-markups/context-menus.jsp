       <!-- Definition of context menu -->

       <!--online and this participant is room creator-->
       <ul id="creator-controlpanel-online-menu" class="contextMenu">
         <!--
         <li class="subscribe"><a href="#subscribe">Subscribe</a></li>
         <li class="checkout"><a href="#checkout">Check-out</a></li>
         <li class="security"><a href="#security">Grant Access</a></li>
         -->
         <li class="student_mode"><a href="#student_mode">Follow</a></li>
         <li class="invite"><a href="#invite">Send Invite</a></li>
         <li class="delete"><a href="#delete">Remove</a></li>
         <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
       </ul>


       <ul id="creator-controlpanel-online-menu-nf" class="contextMenu">
         <!--
         <li class="subscribe"><a href="#subscribe">Subscribe</a></li>
         <li class="checkout"><a href="#checkout">Check-out</a></li>
         <li class="security"><a href="#security">Grant Access</a></li>
         -->
         <li class="leave_student_mode"><a href="#leave_student_mode">Stop Following</a></li>
         <li class="invite"><a href="#invite">Send Invite</a></li>
         <li class="delete"><a href="#delete">Remove</a></li>
         <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
       </ul>

       <ul id="creator-controlpanel-offline-menu" class="contextMenu">
         <li class="invite"><a href="#invite">Send Invite</a></li>
         <li class="delete"><a href="#delete">Remove</a></li>
         <!--
         <li class="security"><a href="#security">Grant Access</a></li>
         -->
       </ul>


       <ul id="participantMenuOnline" class="contextMenu">
         <!--
         <li class="subscribe"><a href="#subscribe">Subscribe</a></li>
         <li class="checkout"><a href="#checkout">Check-out</a></li>
         <li class="security"><a href="#security">Grant Access</a></li>
         -->
         <li class="student_mode"><a href="#student_mode">Follow</a></li>
         
       </ul>

       <ul id="participantMenuOnline-nf" class="contextMenu">
         <!--
         <li class="subscribe"><a href="#subscribe">Subscribe</a></li>
         <li class="checkout"><a href="#checkout">Check-out</a></li>
         <li class="security"><a href="#security">Grant Access</a></li>
         -->
         <li class="leave_student_mode"><a href="#leave_student_mode">Stop Following</a></li>
         
       </ul>


       <ul id="participantMenuOnlineCreator" class="contextMenu">
             <li class="new_book"><a href="#new-book">New Binder</a></li>
             <li class="invite"><a href="#invite">Send Invite</a></li>
             <!--
             <li class="security"><a href="#security">Edit Access Control</a></li>
             -->
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
       </ul>


       <ul id="participantMenuOnlineSelf" class="contextMenu">
             <li class="new_book"><a href="#new-book">New Binder</a></li>
             <li class="invite"><a href="#invite">Send Invite</a></li>
             <!--
             <li class="delete"><a href="#delete">Remove</a></li>
             
             <li class="security"><a href="#security">Edit Access Control</a></li>
             -->
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
       </ul>

       <ul id="participantMenuOffline" class="contextMenu">
           <!--
             <li class="security"><a href="#security">Grant Access</a></li>
           -->
       </ul>


       <ul id="workbookMenu" class="contextMenu">
           <%if(request.isUserInRole("sysadmin")||request.isUserInRole("educator")){%>
                <li class="distribute"><a href="#distribute">Distribute</a></li>
                <!--
                <li class="distribute"><a href="#distribute_as_assignment">Distribute As Assignment</a></li>
                -->
            <%}%>
            <%if(request.isUserInRole("sysadmin")){%>
                <li class="distribute"><a href="#auto-distribute">Make System Welcome</a></li>
            <%}%>
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
             <li class="rename"><a href="#rename">Rename...</a></li>
             <!--
             <li class="savetodisk"><a href="#savetodisk">Save to SVG File</a></li>
             -->
             <li class="delete"><a href="#delete">Remove</a></li>
             <li class="submit_assignment"><a href="#submit_assignment">Submit</a></li>

             <!--
             <li class="security"><a href="#security">Request Access</a></li>
             -->
       </ul>
       <ul id="workbookMenu-default" class="contextMenu">
           <%if(request.isUserInRole("sysadmin")||request.isUserInRole("educator")){%>
                <li class="distribute"><a href="#distribute">Distribute</a></li>
                <!--
                <li class="distribute"><a href="#distribute_as_assignment">Distribute As Assignment</a></li>
                -->
            <%}%>
            <%if(request.isUserInRole("sysadmin")){%>
                <li class="distribute"><a href="#auto-distribute">Make System Welcome</a></li>
            <%}%>
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
             <li class="rename"><a href="#rename">Rename...</a></li>
             <li class="submit_assignment"><a href="#submit_assignment">Submit</a></li>
             <li class="savetodisk"><a href="#savetodisk">Export e-Book</a></li>
             <!--
             <li class="savetodisk"><a href="#savetodisk">Save to SVG File</a></li>
             
             <li class="security"><a href="#security">Request Access</a></li>
             -->
       </ul>


       <ul id="workbookMenu-me" class="contextMenu">
           <%if(request.isUserInRole("sysadmin")||request.isUserInRole("educator")){%>
                <li class="distribute"><a href="#distribute">Distribute</a>
                    <!--<ul>
                        <li class="distribute"><a href="#distribute">To All</a></li>
                        <li class="distribute"><a href="#distribute">To Some</a></li>
                    </ul>-->
                </li>
                <!--
                <li class="distribute"><a href="#distribute_as_assignment">Distribute As Assignment</a></li>
                -->
            <%}%>
            <%if(request.isUserInRole("sysadmin")){%>
                <li class="distribute"><a href="#auto-distribute">Make System Welcome</a></li>
            <%}%>
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
             <li class="rename"><a href="#rename">Rename...</a></li>
             <!--
             <li class="savetodisk"><a href="#savetodisk">Save to SVG File</a></li>
             -->
             <li class="delete"><a href="#delete">Remove</a></li>
             <li class="submit_assignment"><a href="#submit_assignment">Submit</a></li>
             <li class="savetodisk"><a href="#savetodisk">Export e-Book</a></li>
       </ul>
       <ul id="workbookMenu-me-default" class="contextMenu">
           <%if(request.isUserInRole("sysadmin")||request.isUserInRole("educator")){%>
                <li class="distribute"><a href="#distribute">Distribute</a></li>
                <!--
                <li class="distribute"><a href="#distribute_as_assignment">Distribute As Assignment</a></li>
                -->
            <%}%>
            <%if(request.isUserInRole("sysadmin")){%>
                <li class="distribute"><a href="#auto-distribute">Make System Welcome</a></li>
            <%}%>
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
             <li class="rename"><a href="#rename">Rename...</a></li>
             <li class="submit_assignment"><a href="#submit_assignment">Submit</a></li>
             <li class="savetodisk"><a href="#savetodisk">Export e-Book</a></li>
             <!--
             <li class="savetodisk"><a href="#savetodisk">Save to SVG File</a></li>
             
             <li class="security"><a href="#security">Edit Access Control</a></li>
             -->
       </ul>

       <ul id="workbookPageMenu" class="contextMenu">
             <li class="rename"><a href="#rename">Rename...</a></li>
             <li class="delete"><a href="#delete">Remove</a></li>
             <li class="embed_code"><a href="#embed_code">Embed Code</a></li>
             <li class="page_url"><a href="#page_url">Get Page URL</a></li>
             <li class="submit_assignment"><a href="#submit_assignment">Submit</a></li>
       </ul>
       <ul id="workbookPageMenu-default" class="contextMenu">
             <li class="rename"><a href="#rename">Rename...</a></li>
             <li class="submit_assignment"><a href="#submit_assignment">Submit</a></li>
       </ul>
       <!--
       <ul id="padContextMenu" class="contextMenu">
           <li class="cut"><a href="#cut">Cut</a></li>
           <li class="copy"><a href="#copy">Copy</a></li>
           <li class="paste"><a href="#paste">Paste</a></li>
       </ul>
       -->
       <div class="contextMenu" id="padContextMenu">
          <ul>
           <li id="cut"><img src="../../js/jquery-plugins/jquery.contextMenu/images/cut.png" />Cut</li>
           <li id="copy"><img src="../../js/jquery-plugins/jquery.contextMenu/images/page_white_copy.png" />Copy</li>
           <li id="paste"><img src="../../js/jquery-plugins/jquery.contextMenu/images/page_white_paste.png" />Paste</li>
          </ul>
       </div>

       <%--
       <ul id="phyzixlabs-room-menu" class="contextMenu">
             <li class="new"><a href="#new">New Participant</a></li>
           <%if(request.isUserInRole("educator") || request.isUserInRole("sysadmin")){%>
                <li class="load_users"><a href="#load_users">Load Users</a></li>
            <%}%>
       </ul>
       --%>
       
       <%--if(request.isUserInRole("sysadmin")||request.isUserInRole("educator")||request.isUserInRole("room_creator")){%>
           <ul id="phyzixlabs-room-root-menu" class="contextMenu">
                 <li class="new"><a href="#new">New Room</a></li>
           </ul>
       <%}--%>
       <ul id="phyzixlabs-room-root-menu" class="contextMenu">
             <li class="new"><a href="#new">New Participant</a></li>
             <%if(request.isUserInRole("educator") || request.isUserInRole("sysadmin")){%>
                <li class="load_users"><a href="#load_users">Load Participants from file</a></li>
            <%}%>
            <li class="rename"><a href="#rename">Rename</a></li>
       </ul>

       <div  id="phyzixlabs-add-participant-menu" style="display:none">
           <ul>
                 <li class="new"><a  href="#" onclick="ColabopadApplication.createParticipant('new')">New Participant</a></li>
               <%if(request.isUserInRole("educator") || request.isUserInRole("sysadmin")){%>
                    <li class="load_users"><a  href="#" onclick="ColabopadApplication.createParticipant('load_users')">Load Participants from file</a></li>
                <%}%>
           </ul>
       </div>

       <ul id="phyzixlabs-room-teamspace-menu" class="contextMenu">
             <li class="new_book"><a href="#new-book">New Binder</a></li>
             <li class="import-office"><a href="#import-office">Import Office/PDF Document</a></li>
       </ul>

       <ul id="phyzixlabs-room-assignment-root-menu" class="contextMenu">
             <li class="new_assignment"><a href="#new-assignment">New Task</a></li>
       </ul>

       <ul id="phyzixlabs-room-assignment-menu" class="contextMenu">
             <li class="edit_assignment"><a href="#edit-assignment">Edit</a></li>
             <li class="archive_assignment"><a href="#archive-assignment">Archive</a></li>
       </ul>

       <ul id="phyzixlabs-room-assignment-submission-menu" class="contextMenu">
             <li class="mark_as_graded_assignment"><a href="#mark-as-graded-assignment">Mark as graded</a></li>
       </ul>