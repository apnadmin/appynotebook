<%-- 
    Document   : dev-help
    Created on : Oct 5, 2009, 9:49:44 AM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf-8">
        <link rel="stylesheet" type="text/css" href="style.css" title="styles1"  media="screen" />
        <title>Colabopad Developer Help</title>
    </head>
    <body lang="en-US" dir="LTR">
        <h1><a href="#h1" name="h1">Colabopad Developer Help</a></h1>
        <div style="padding-left:60px;">
        Colabopad has a developer API for developing widgets that can be deployed into Colabopad. Using simple Javascript and HTML, a developer
        can create useful widgets that take advantage of the interactive and collaborative features of Colabopad. The developer need not concern themselves
        with any of the underlaying intricacies of Colabopad messaging.
        </div>

        <h1><a href="#h2" name="h2">A few things to keep in mind</a></h1>
        <ul>
            <li>This API is experimental. So in other words it will not have all the nice things you may be used to.</li>
            <li>Since Colabopad relies heavily on Javascript and in particular the <a href="http://jquery.com/" target="new window">JQuery</a> library, familiarity with JQuery is presumed.</li>
        </ul>

        <h1><a href="#h3" name="h3">Developing A Colabopad Widget</a></h1>
        <ul>
          <li>
              <a href="#a1">1. Sign up for a developer account</a>
              <ul style="margin-left: 0; padding-left: 2.5em;list-style-type:square">
                  <li><a href="#a1.1">1.1 Login as Developer</a></li>
              </ul>
          </li>
          <li>
              <a href="#a2">2. Launching the WIDE</a>
          </li>
          <li>
              <a href="#a3">3. The API</a>

              <ul style="margin-left: 0; padding-left: 2.5em;list-style-type:square">
                  <li>
                      <a href="#a3.1">3.1 Functions</a>
                      <ul style="margin-left: 0; padding-left: 2.5em;list-style-type:square">
                          <li>
                              <a href="#a3.1.1">3.1.1 getResourceURL</a>
                          </li>
                          <li>
                              <a href="#a3.1.2">3.1.2 getName</a>
                          </li>
                          <li>
                              <a href="#a3.1.3">3.1.3 appendHtml</a>
                          </li>
                          <li>
                              <a href="#a3.1.4">3.1.4 getClassId</a>
                          </li>
                          <li>
                              <a href="#a3.1.5">3.1.5 isReady</a>
                          </li>
                          <li>
                              <a href="#a3.1.6">3.1.6 registerNewInstance</a>
                          </li>
                          <li>
                              <a href="#a3.1.7">3.1.7 getSafeSelector</a>
                          </li>
                          <li>
                              <a href="#a3.1.8">3.1.8 sendMessage</a>
                          </li>
                          <li>
                              <a href="#a3.1.9">3.1.9 getActiveInstance</a>
                          </li>
                          <li>
                              <a href="#a3.1.10">3.1.10 registerControlPanel</a>
                          </li>
                          <li>
                              <a href="#a3.1.10">3.1.11 ready</a>
                          </li>
                      </ul>
                  </li>
                  <li>
                      <a href="#a3.2">3.2 Interface Methods</a>
                      <ul style="margin-left: 0; padding-left: 2.5em;list-style-type:square">
                          <li>
                              <a href="#a3.2.1">3.2.1 onInit</a>
                          </li>
                          <li>
                              <a href="#a3.2.2">3.2.2 onGainFocus</a>
                          </li>
                          <li>
                              <a href="#a3.2.3">3.2.3 onLossFocus</a>
                          </li>
                          <li>
                              <a href="#a3.2.4">3.2.4 onNewInstance</a>
                          </li>
                          <li>
                              <a href="#a3.2.5">3.2.5 onAddInstance</a>
                          </li>
                          <li>
                              <a href="#a3.2.6">3.2.6 onMessage</a>
                          </li>
                          <li>
                              <a href="#a3.2.7">3.2.7 onDeleteInstance</a>
                          </li>
                          <li>
                              <a href="#a3.2.8">3.2.8 onSerialize</a>
                          </li>
                      </ul>
                  </li>
              </ul>
          </li>
          <li>
              <a href="#a4">4. Developing a Widget</a>
              <ul style="margin-left: 0; padding-left: 2.5em;list-style-type:square">
                  <li>
                      <a href="#a4.1">4.1 Creating New Widget</a>
                  </li>
                  <li>
                      <a href="#a4.2">4.2 Adding Resources</a>
                  </li>
                  <li>
                      <a href="#a4.3">4.3 Testing Widget</a>
                  </li>
                  <li>
                      <a href="#a4.4">4.4 Submitting You Widget</a>
                      <ul style="margin-left: 0; padding-left: 2.5em;list-style-type:square">
                          <li><a href="#a4.4.1">4.4.1 Widget Submission Process Flow</a></li>
                      </ul>
                  </li>
                  <li>
                      <a href="#a4.5">4.5 Sample Widget Demo</a>
                  </li>
              </ul>
          </li>
          <li>
              <a href="#a5">5. Further Help</a>
          </li>
        </ul>

        <div style="margin-left:60px;">
            <h1 style="border-style:solid;border-width:1px;border-color:blue;background-color:#3cb2ec;color:white;font-weight:bold;padding:3px;"><a style="color:white" href="#a1" name="a1">1. Sign up for a developer account.</a></h1>
            <p>
                <p>
                    The sign-up process for a developer account is the same as that for a normal user. You create a room and a login link would be emailed to you. The main difference is that as a developer
                    you'll have access to the Widget Integrated Development Environment (WIDE). 
                </p>

                <h3><a href="#a1.1" name="a1.1">1.1 Login as Developer</a></h3>
                <p>
                    When you login as a developer you'll see the usual <span style="font-style:italic;font-weight:bold">Launch Room</span>
                    button and in addition you'll have a second button for launching the WIDE:<br/>
                    <img src="images/img.png"/><br/>
                </p>
            </p>


            <h1 style="border-style:solid;border-width:1px;border-color:blue;background-color:#3cb2ec;color:white;font-weight:bold;padding:3px;"><a style="color:white" href="#a2" name="a2">2. Launching the WIDE</a></h1>
            <p>
                After creating your developer account and logging in, the next step is to launch the WIDE by clicking on the <span style="font-style:italic;font-weight:bold">Widget IDE</span> button. This would launch the WIDE with
                interface similar to the following:<br/>
                <img src="images/img1.png"/><br/> On the left panel you have four folders, each represents the different states a widget
                can be in at any given time. All widgets start out in the <span style="font-style:italic;font-weight:bold">Widgets In Development</span> folder. On the right
                you have two tabs, the first is the <span style="font-style:italic;font-weight:bold">Code</span> tab. This tab contains the Javascript code editor for your widget code.
                When you click on a Widget in one of the folders on your left, the widget code is loaded into the code editor on the right.<br/><br/>

                The second tab is the <span style="font-style:italic;font-weight:bold">Resources</span> tab. This tab contains your resource manager that
                you'll use to upload your widget resources such static HTML,SVG, text, images...etc:<br/>
                <img src="images/img2.png"/>
            </p>

            <h1 style="border-style:solid;border-width:1px;border-color:blue;background-color:#3cb2ec;color:white;font-weight:bold;padding:3px;"><a style="color:white" href="#a3" name="a3">3. The API</a></h1>
            <p>
                The Colabopad API is simple to use and very straight forward. The API is broken down into two parts, the first is the set of
                functions available to each widget implementation and the second is a list of interface methods that each widget is
                expected to implement.
            </p>
            <h3><a href="#a3.1" name="a3.1">3.1 Functions</a></h3>

            
            <div style="margin-left:30px">
                <a href="#a3.1.1" name="a3.1.1">3.1.1 getResourceURL</a><br/>
                Use this function to obtain a url for resources you would have uploaded from the resource manager.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    getResourceURL(
                        file_name
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">file_name</span><br/>
                <p style="padding-left:20px">
                    This is the actual file name including any extensions, it is the same value as that displayed in the <span style="font-weight:bold;font-style:italic">File Name</span>
                    field of the resource manager. This should be a string value<br/>
                    <span style="font-weight:bold;color:red">Note:</span>This also implies that no two files for a specific widget can have the same name.
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>Returns a well-formed url that can be used to make a browser request for the given resource. This is a string value</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                    One thing to remember is that all resources requested are returned literally, in other words the user would never get
                    a prompt to download an attachment. This is obviously for security reasons.
                </p>
            </div>


            <div style="margin-left:30px">
                <a href="#a3.1.2" name="a3.1.2">3.1.2 getName</a><br/>
                Use this function to obtain the name of the widget at runtime<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    getName(

                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">NONE</span><br/>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>Returns the name of the widget at runtime</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                    This function is currently un-implemented so it will return an empty string until it is implemented.
                </p>
            </div>


            <div style="margin-left:30px">
                <a href="#a3.1.3" name="a3.1.3">3.1.3 appendHtml</a><br/>
                Use this function to append static html to the DOM tree.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    appendHtml(
                        html_text
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">html_text</span><br/>
                <p style="padding-left:20px">
                    This is a well-formed html text fragment.
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                   It is very important that you use this function for adding to the DOM tree so as not interfere with the whole application.
                   Another very important note is to prefix all element selectors (see JQuery for what this means) with <span style="font-weight:bold;"><span style="font-style:italic">widget-</span>{widget id}</span>.
                   Refusal to do this would result in rejection of your widget.
                </p>
            </div>



           <div style="margin-left:30px">
                    <a href="#a3.1.4" name="a3.1.4">3.1.4 getClassId</a><br/>
                    Use this function to obtain the unique identifier for your widget<br/>
                    <div style="background-color:silver;color:navy;padding:10px">
                        getClassId(

                        );
                    </div>
                    <span style="font-weight:bold">Parameters</span><br/>
                    <span style="font-style:italic">NONE</span><br/>

                    <span style="font-weight:bold">Return Value</span><br/>
                    <p>Returns an integer identifier for the widget</p>
                    <span style="font-weight:bold">Remarks</span>
                    <p>
                    Use this value for all instances where you need to uniquely identify your widget.
                    </p>
                </div>


            <div style="margin-left:30px">
                <a href="#a3.1.5" name="a3.1.5">3.1.5 isReady</a><br/>
                Use this function to determine if a given widget is ready for use.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    isReady(
                        
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">NONE</span><br/>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>Returns a BOOLEAN value</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                   For the time being this is included here only for completeness but is unlikely to be of any use to a developer.
                </p>
            </div>



            <div style="margin-left:30px">
                <a href="#a3.1.6" name="a3.1.6">3.1.6 registerNewInstance</a><br/>
                Use this function to register a new instance of your widget.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    registerNewInstance(
                        widget_instance,
                        pad
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">widget_instance</span><br/>
                <div style="padding-left:20px">
                    This is a configuration object that completely and correctly describes a widget instance. From this object your widget implementation
                    should be able to reload a previously created instance. The structure of this object is as follows:<br/>
                    <div style="background-color:silver;color:navy;padding:10px;margin-left:20px;width:300px">
                        {svg_node,config}
                    </div><br/>
                    The <span style="font-style:italic">svg_node</span> attribute represents the root svg node of the widget instance, this would be inserted into the
                    Colabopad DOM.<br/>

                    The actual configuration information would be held in the <span style="font-style:italic">config</span> attribute, this object should be a clean javascript object. It should
                    not contain any reference to a function or to a DOM object.
                </div><br/>
                <span style="font-style:italic">pad</span><br/>
                <p style="padding-left:20px">
                    The pad object is an object that represents the current pad on which the user is working, that is the pad on which this
                    widget instance would be hosted. That object would be discussed later.
                </p><br/>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                    When this function returns, the <span style="font-style:italic">widget_instance</span> object passed to it would have an <span style="font-style:italic">id</span> attribute that uniquely
                    identifies that instance over its entire lifespan. Use this id.<br/>
                    <span style="font-weight:bold;color:red">Note:</span>This also implies that you should not use the identifier <span style="font-style:italic">id</span> in either <span style="font-style:italic">widget_instance</span> or <span style="font-style:italic">widget_instance.config</span>
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.1.7" name="a3.1.7">3.1.7 getSafeSelector</a><br/>
                Use this function to obtain a DOM safe selector.
                <div style="background-color:silver;color:navy;padding:10px">
                    getSafeSelector(
                        selector
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">selector</span><br/>
                <p style="padding-left:20px">
                    JQuery DOM selector
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>Returns a DOM selector that would prevent DOM tree curruption. This is a string value</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                This function isn't implemented yet, but it is recommended that you use it when doing JQuery DOM selection. Usage:
                <div style="background-color:silver;color:navy;padding:10px;margin-left:20px;width:300px">$(this.getSafeSlector(selector))</div>
                In the future when we implement more DOM sandboxing you'll need it to access your HTML
                content. For now it returns the selector unmodified.
                </p>
            </div>


            <div style="margin-left:30px">
                <a href="#a3.1.8" name="a3.1.8">3.1.8 sendMessage</a><br/>
                Use this function to send messages to remote instances.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    sendMessage(
                        message
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">message</span><br/>
                <p style="padding-left:20px">
                    A message object.
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                Use this function for remote communication between widget instances. In the future this function would be extended to support inter-widget communication.
                This means two widgets on the same pad will be able to use it to communicate with each other.
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.1.9" name="a3.1.9">3.1.9 getActiveInstance</a><br/>
                Use this function to obtain the current active widget instance.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                   getActiveInstance(

                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">NONE</span><br/>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>Returns the current widget instance. </p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                   You will use this function if your widget implementation wants to know which widget instance on a page has focus. This
                   would most likely not be useful since there's an interface method that can be implemented to know when an instance becomes
                   active and is supplied with the active instance. This is included for completeness for now.
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.1.10" name="a3.1.10">3.1.10 registerControlPanel</a><br/>
                Use this function to register a control panel for your widget, this can be anything from a simple button to more surphicated controls.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    registerControlPanel(
                        control_panel
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">control_panel</span><br/>
                <p style="padding-left:20px">
                    An object with the following structure
                    <div style="background-color:silver;color:navy;padding:10px;margin-left:20px;width:300px">
                        {panel,size:{height,width}}
                    </div><br/>
                    <div style="margin-left:20px;">
                        <span style="font-style:italic">panel</span> should be an HTML DOM object representing a DOM fragment that was previously
                        added to the DOM. This must be an HTML <span style="font-style:italic">div</span> element containing all your controls
                        you wish to expose.<br/><br/>

                        <span style="font-style:italic">size</span> represents the dimensions of the div element, this is required for your panel to be properly displayed.
                    </div>
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                  Widgets inherit a simple control panel with controls for move,resize,rotate,help, delete operations. You can add other controls
                  such as for edit to this panel through this function.
                </p>
            </div>


            <div style="margin-left:30px">
                <a href="#a3.1.11" name="a3.1.11">3.1.11 ready</a><br/>
                Use this function to notify Colabopad that your widget has finished initialization.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    ready(
                        
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">NONE</span><br/>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                If you don't call this function, your widget would never be loaded. You call this method when you know your widget is ready
                for creating instances.
                </p>
            </div>



            <h3><a href="#a3.2" name="a3.2">3.2 Interface Methods</a></h3>
            
            <div style="margin-left:30px">
                <a href="#a3.2.1" name="a3.2.1">3.2.1 onInit <sup style="font-size:.8em;color:red">required</sup></a><br/>
                Implement this method to receive notification for when a widget needs to be initialized. <br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onInit(

                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">NONE</span><br/>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                    This is where you'll load and initialize all UI elements that users would need to use your widget. Basically this method
                    would be called the first time an instance needs to be created for your widget implementation for a specific user.
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.2.2" name="a3.2.2">3.2.2 onGainFocus</a><br/>
                Use this method to receive notification for when a widget's instance gain focus.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onGainFocus(
                        widget_instance
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">widget_instance</span><br/>
                <p style="padding-left:20px">
                    An object as described <a href="#a3.1.6">here</a>
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                Focus is defined as a mouse over the widget
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.2.3" name="a3.2.3">3.2.3 onLossFocus</a><br/>
                Use this method to receive notification for when a widget's instance looses focus.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onLossFocus(
                        widget_instance
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">widget_instance</span><br/>
                <p style="padding-left:20px">
                    An object as described <a href="#a3.1.6">here</a>
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                Loss focus is defined as when a mouse leaves the widget
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.2.4" name="a3.2.4">3.2.4 onNewInstance</a><br/>
                Use this method to receive notification for when a new widget instance is requested by user.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onNewInstance(
                        pad
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">pad</span><br/>
                <p style="padding-left:20px">
                    An object with the following structure
                    <div style="background-color:silver;color:navy;padding:10px;margin-left:20px;width:300px">
                        {svg_doc}
                    </div>
                    <span style="font-style:italic">svg_doc</span> attribute represents an object that is key to Colabopad,
                    it is a JQuery wrapper around the svg implementation of you web browser. You'll need to become familiar with this object in order to create widgets. You can access the full documentation for this object
                    by clicking <a href="http://keith-wood.name/svg.html" target="new window">here</a>.
                </p><br/>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                All svg drawings in Colabopad are expected to be done using <span style="font-style:italic">svg_doc</span>.
                </p>
            </div>


            <div style="margin-left:30px">
                <a href="#a3.2.5" name="a3.2.5">3.2.5 onAddInstance</a><br/>
                This method is called when a new instance needs to be added to a user's pad.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onAddInstance(config,pad
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">config</span><br/>
                <div style="padding-left:20px">
                    <span style="font-style:italic">config</span> object as described <a href="#a3.1.6">here</a>
                </div>
                <span style="font-style:italic">pad</span><br/>
                <div style="padding-left:20px">
                    <span style="font-style:italic">pad</span> object as described <a href="#a3.2.4">here</a>
                </div>

                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                This method is mainly used to replicate widget creation from remote users. So if a remote user is editing your pad
                then when they add a widget, this method would be called with the configuration object they sent you.
                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.2.6" name="a3.2.6">3.2.6 onMessage</a><br/>
                This method would receive message notifications from remote widgets.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onMessage(
                        message
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">message</span><br/>
                <p style="padding-left:20px">
                    An object as described <a href="#a3.1.8">here</a>
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>

                </p>
            </div>

            <div style="margin-left:30px">
                <a href="#a3.2.7" name="a3.2.7">3.2.7 onDeleteInstance</a><br/>
                This method would receive message notifications when a widget instance is deleted from a user's pad.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onDeleteInstance(
                        widget_instance
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">widget_instance</span><br/>
                <p style="padding-left:20px">
                    An object as described <a href="#a3.1.6">here</a>
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                Typically you'll call this for any cleanup tasks.
                </p>
            </div>


            <div style="margin-left:30px">
                <a href="#a3.2.8" name="a3.2.8">3.2.8 onSerialize</a><br/>
                This method would receive message notifications when a widget instance is being saved to a Colabopad File.<br/>
                <div style="background-color:silver;color:navy;padding:10px">
                    onSerialize(
                        widget_instance
                    );
                </div>
                <span style="font-weight:bold">Parameters</span><br/>
                <span style="font-style:italic">widget_instance</span><br/>
                <p style="padding-left:20px">
                    An object as described <a href="#a3.1.6">here</a>
                </p>
                <span style="font-weight:bold">Return Value</span><br/>
                <p>NONE</p>
                <span style="font-weight:bold">Remarks</span>
                <p>
                <span style="font-weight:bold;color:red">Note:</span> only the <span style="font-style:italic">config</span> object gets saved, the <span style="font-style:italic">widget_instance</span> is a transient wrapper object that only last during runtime. You can use this
                method to add additional attributes to the <span style="font-style:italic">config</span> object before it is saved, example current state of widget.
                </p>
            </div>

            <h1 style="border-style:solid;border-width:1px;border-color:blue;background-color:#3cb2ec;color:white;font-weight:bold;padding:3px;"><a style="color:white" href="#a4" name="a4">4. Developing a Widget.</a></h1>
            The first step in creating a widget is to login and launch the Widget IDE.
            <h3><a href="#a4.1" name="a4.1">4.1 Creating New Widget</a></h3>
            <p>
                On the left panel click the <span style="font-style:italic;font-weight:bold">New Widget</span>. You'll now have screen similar to the following:
                <img src="images/img3.png"/><br/>
                Fill in the form and hit the <span style="font-style:italic;font-weight:bold">Ok</span> button. You should now have your widget listed
                under the folder <span style="font-style:italic;font-weight:bold">Widgets In Development</span> and on the right you'll have a template code for starting
                your widget development as illustrated below:<br/>
                <img src="images/img4.png"/><br/> This completes the steps required to create a simple widget.<br/>

                To change information about the widget, such as the widget name or author information, right click on the widget and select <span style="font-style:italic;font-weight:bold">Edit Info</span>:<br/>
                <img src="images/img4.1.png"/>
            </p>

            <h3><a href="#a4.2" name="a4.2">4.2 Adding Resources</a></h3>
            <p>
                Next we want to add some resources for our widget to use, clicking the <span style="font-style:italic;font-weight:bold">Resources</span> tab reveals the following
                screen:<br/>
                 <img src="images/img5.png"/><br/>
                To add a resource click on the <span style="font-style:italic;font-weight:bold">Add Resource</span> button to reveal the following screen:<br/>
                <img src="images/img6.png"/><br/>
                At this point you need fill out all the fields, <span style="font-style:italic;font-weight:bold">Data Type</span> has only two possible values
                , BINARY or ASCII. Image files for instance would be binary files, static html would be an ascii file...etc.
                Hit the <span style="font-style:italic;font-weight:bold">Ok</span> button. You should now see the file listed in your
                resource table:<br/><img src="images/img7.png"/><br/> You can add as many resources as you need. You can also delete a resource
                by clicking on the red x button in the list.
            </p>



            <h3><a href="#a4.3" name="a4.3">4.3 Testing Widget</a></h3>
            <p>
                Testing a widget is very simple. You have to launch your normal pad just as any regular user. However since you're a developer
                you'll have an extra menu labeled <span style="font-style:italic;font-weight:bold">Developer</span>. This menu is mirror image of your
                widget folders from the WIDE, you can invoke widgets in various states of development. The following screen reveal the developer menu:<br/>
                <img src="images/img8.png"/><br/> As you can see, we have a widget in development so it is listed, clicking on <span style="font-style:italic;font-weight:bold">Test Widget</span>
                would launch this widget. <br/><br/><br/>

                <h4>Let's run an actual test...</h4>

                Copy the following code fragment into the <span style="font-style:italic;font-weight:bold">onNewInstance</span> method of the <span style="font-style:italic;font-weight:bold">Test Widget</span> we created in steps earlier. :
                <div style="background-color:silver;color:navy;padding:10px">
                    <pre>
var root = pad.svg_doc.group();
pad.svg_doc.circle(root,60,60,50, {fill: 'red',stroke: 'blue', strokeWidth: 1,"fill-opacity":0.8});
var widget_instance = {svg_node:root,config:{dim:{x:0,y:0,w:120,h:120}}};
this.registerNewInstance(widget_instance,pad);
                    </pre>
                </div>
                Now copy this line of code into the <span style="font-style:italic;font-weight:bold">onInit</span> method:
                <div style="background-color:silver;color:navy;padding:10px">
                    <pre>
this.ready();//tell Colabopad this widget is ready
                    </pre>
                </div>

                Click <span style="font-style:italic;font-weight:bold">Save</span>


                You should now have something like this:<br/>
                <img src="images/img9.png"/><br/>

                Now go back to your pad and click on <span style="font-style:italic;font-weight:bold">Developer->Widgets In Development->Test Widget</span>, you should now see a red circle on your pad.
                Mouse over this circle to reveal the widget control panel as shown below:<br/>
                <img src="images/img10.png"/><br/>
                <h3>Play with it and have fun!</h3>
            </p>


            <h3><a href="#a4.4" name="a4.4">4.4 Submitting Your Widget</a></h3>
            <p>
              Now that you have done all that work, you obviously want to publish your widget so people can use it. A few things to keep in mind:<br/>
              <ul>
                  <li>
                      Don't do anything stupid, you know the kind of stuff that'll get your widget automatically rejected?
                   </li>
                  <li>
                  Do you have a <span style="font-style:italic;font-weight:bold">help.html</span> file? All widgets are required to have this file and it should contain detailed usage
                  instructions for your widget.
                  </li>
                  <li>
                      Do you have an icon file? It is recommended that you create a 16x16 pixel icon for your widget, this icon would
                      be displayed on the menu and other places where an icon may be appropriate. This file must be called <span style="font-style:italic;font-weight:bold">favicon.png</span>
                  </li>
              </ul>
              To submit your widget, right click on the widget name and select <span style="font-style:italic;font-weight:bold">Submit</span> as shown below:<br/>
              <img src="images/img11.png"/><br/>
              A copy of this widget would now be listed under the folder <span style="font-style:italic;font-weight:bold">Widgets Pending Approval</span> as shown below:<br/>
              <img src="images/img12.png"/><br/>
              Once the widget is Approved it will move to the <span style="font-style:italic;font-weight:bold">Widgets In Production</span> folder as shown below:<br/>
              <img src="images/img13.png"/><br/>

              Your original widget in development
              remains there so you can always improve on it and resumbit, new submissions (versions) would replace existing ones.<br/>
              You and everyone else can now access your approved widget from the main <span style="font-style:italic;font-weight:bold">Widgets</span> menu:<br/>
              <img src="images/img14.png"/><br/>
              
             <h3><a href="#a4.4.1" name="a4.4.1">4.4.1 Widget Submission Process Flow</a></h3>   
             <div>
                 <img src="images/img2x.png"/><br/>
             </div>
            </p>
            <h3><a href="#a4.5" name="a4.5">4.5 Sample Widget Demo</a></h3>
            <p>
                COMING SOON.
            </p>

            <h1 style="border-style:solid;border-width:1px;border-color:blue;background-color:#3cb2ec;color:white;font-weight:bold;padding:3px;"><a href="#a5" name="a5" style="color:white">5. Further Help</a></h1>
            <p>
                If you have other questions or concerns that are not addressed in this document, please visit the <a href="http://groups.google.com/group/colabopad_developer_help" target="new window">Colabopad developer help group</a> on Google.
                You can post questions and see answers to other questions.
            </p>

        </div>
        <div style="text-align:center;margin:3px">2009 &copy; Colabopad</div>
    </body>
</html>