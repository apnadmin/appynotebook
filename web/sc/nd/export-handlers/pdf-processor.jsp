<%-- 
    Document   : svg-clb-poster
    Created on : Jun 28, 2009, 8:36:48 PM
    Author     : bitlooter
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="../../../js/safe-jquery-1.6.2.min.js"></script>
        <script type="text/javascript">
            function replaceAll(txt, replace, with_this) {
              return txt.replace(new RegExp(replace, 'g'),with_this);
            }

            function sendSVG(room_id,fileName,svg,pad){
                
                $('input[name=room_id]').val(room_id);
                $('input[name=file_name]').val(fileName);
                
                //$('#svg1').attr("value",svg)
                if(typeof(pad) != "undefined" && pad != null && typeof pad.texteditor != "undefined" && pad.texteditor != null){
                    $("#svg_dom").html(svg);
                    $("#svg_dom svg").attr("xmlns:xlink","http://www.w3.org/1999/xlink");
                    
                    //$("#svg_dom").find("[nodeName=foreignObject]").remove();
                    
                    //$("#svg_dom svg").find("div").remove();
                    $("#svg_dom").find("foreignObject").remove();
                    
                    //alert(svgNode.find("div").length);//.empty().remove();
                    //$("#svg_dom svg").removeChild(document.getElementsByTagName("foreignObject"));
                    //$("#svg_dom svg").removeAttr("xmlns");
                    
                    
                    $("#svg_dom path").each(function(){//alert($(this).attr("d")+"\n"+replaceAll($(this).attr("d"),","," "));
                        $(this).attr("d",replaceAll($(this).attr("d"),","," "));
                    });
                    
                    //break it up into pages
                    var pageCount = 1;
                    //pad.div_dom.find('svg .note-element')
                    //$("#svg_dom svg").attr("height",pad.texteditor.config.original_11inch_to_pixel_height+"px");//.attr("width","8.5in");
                    //alert($("#svg_dom svg").attr("height").baseVal);
                    $("#svg_dom svg").attr("height",pad.texteditor.config.original_11inch_to_pixel_height);//.baseVal.value = pad.texteditor.config.original_11inch_to_pixel_height;
                    $("#svg_dom .note-element")
                    .each(function(){


                        if(this.transform.baseVal.numberOfItems>1){
                            var bb = this.getBBox();
                            var ty = this.transform.baseVal.getItem(1).matrix.f;
                            var tx = this.transform.baseVal.getItem(1).matrix.e;
                            var sx = this.transform.baseVal.getItem(1).matrix.a;
                            var sy = this.transform.baseVal.getItem(1).matrix.d;
                            var config = this.config;

                            var y  = bb.y+ty;
                            var page = Math.ceil(y/pad.texteditor.config.original_11inch_to_pixel_height);
                            if(page>pageCount)
                                pageCount = page;

                                //alert(page);
                            var pageY = ty-( (page-1)*pad.texteditor.config.original_11inch_to_pixel_height);
                            //var normalizedTransform = 'rotate('+config.transforms.rotate.angle+','+config.transforms.rotate.cx+','+config.transforms.rotate.cy+') '+'translate('+config.transforms.trslt.x+','+pageY+') scale('+config.transforms.scale.x+','+config.transforms.scale.y+')';
                            //this.setAttribute("transform",normalizedTransform);
                            //this.transform.baseVal.getItem(1).matrix.translate(tx,ty);

                            //this.getAttribute("transform").indexOf("translate(")

                            var oldTranslate = "translate("+this.getAttribute("transform").split("translate(")[1].split(")")[0]+")";
                            var newTranslate = "translate("+tx+","+pageY+")";
                            var oldTransform = this.getAttribute("transform");
                            var newTransform = oldTransform.replace(oldTranslate,newTranslate);
                            this.setAttribute("transform",newTransform);
                            this.style.display = "none";
                            //alert(oldTransform+"\n"+newTransform);
                            //alert(this.getAttribute("transform").split("translate(")[1].split(")")[0].split(',')[0]);
                            //var normalizedTransform = 'rotate('+config.transforms.rotate.angle+','+config.transforms.rotate.cx+','+config.transforms.rotate.cy+') '+'translate('+config.transforms.trslt.x+','+pageY+') scale('+config.transforms.scale.x+','+config.transforms.scale.y+')';
                            //this.setAttribute("transform",normalizedTransform);

                            //alert(bb.height+' tx:'+ty);
                            //alert('y:'+y+' ty:'+ty);
                            //alert('note-element:'+this.transform.baseVal.getItem(1).matrix.f);
                            //alert($(this).html());
                            $(this).attr("page",page);
                        }
                    });
                    $("#pageCount").attr("value",pageCount);
                    $("#xhtml").attr("value",pad.texteditor.ckeditor.getData());

                    $("#page_pixel_width").attr("value",pad.texteditor.config.original_8_5inch_to_pixel_width);
                    $("#page_pixel_height").attr("value",pad.texteditor.config.original_11inch_to_pixel_height);

                    $("#content_pixel_width").attr("value",pad.texteditor.config.original_editorwidth_in_pixel);
                    $("#content_pixel_height").attr("value",pad.texteditor.config.original_editorheight_in_pixel);

                    $("#page_margin_left").attr("value",pad.texteditor.config.margin.left);
                    $("#page_margin_right").attr("value",pad.texteditor.config.margin.right);
                    $("#page_margin_top").attr("value",pad.texteditor.config.margin.top);
                    $("#page_margin_bottom").attr("value",pad.texteditor.config.margin.bottom);

                    $('#svg').attr("value",$("#svg_dom").html());
                    //alert($("#svg").val().length);
                    $("form[name=pdfposter]").attr("action","xhtml2pdf.jsp");
                    
                    //alert($("#svg_dom").find("foreignObject"))
                }else{
                    $("#svg_dom").html(svg);
                    $("#svg_dom").find("foreignObject").remove();
                    
                    $('#svg').attr("value",$("#svg_dom").html());
                    $("form[name=pdfposter]").attr("action","pdf.jsp")
                }
                //$('#imagedata').attr("value",imagedata);
                //$(document.pdfposter).attr("action","http://<%=request.getServerName() %>/colabopad/svg-to-pdf.php");
                document.pdfposter.submit();
                startProgressCheck();
            }
            function startProgressCheck(){
                var checkCount =0;
                var checkTimer = setInterval(function(){
                        if(checkCount > 60){
                            clearInterval(checkTimer);
                            top.ColabopadApplication.onExportComplete();
                            return;
                        }
                        $.ajax({
                            type:'POST',
                            data:{},
                            url:'export-status.jsp',
                            success:function(data){
                                if(data == "done" || data == "null"){
                                    clearInterval(checkTimer);
                                    top.ColabopadApplication.onExportComplete();
                                }
                            }
                        });
                    },1000);                
            }
            
            function sendSVGPage(svg,index){
                //$('#svg').attr("value",svg);
                //$('#index').attr("value",index);
                //$(document.pdfposter).attr("action","http://<%=request.getServerName() %>/apache/colabopad/svg-to-pdf-book.php?makebook=false");
                /*document.pdfposter.submit();*/

                $.ajax({
                        type:'POST',
                        data:{svg:svg,index:index},
                        url:'http://<%=request.getServerName() %>/colabopad/svg-to-pdf-book.php?makebook=false',
                        success:function(data){

                        }
                });
            }
            function makeBook(){
                $('#svg').attr("value",'');
                $('#index').attr("value",'');
                //$(document.pdfposter).attr("action","http://<%=request.getServerName() %>/colabopad/svg-to-pdf-book.php?makebook=true");
                document.pdfposter.submit();
            }

        </script>
    </head>
    <body>
        <form method="post" name="pdfposter" action="pdf.jsp">
            <input type="hidden" name="room_id"/>
            <input type="hidden" name="file_name"/>
            <input type="hidden" id="index" name="index"/>
            <input type="hidden" id="pageCount" name="pageCount"/>

            <input type="hidden" id="page_pixel_height" name="page_pixel_height"/>
            <input type="hidden" id="page_pixel_width" name="page_pixel_width"/>

            <input type="hidden" id="content_pixel_width" name="content_pixel_width"/>
            <input type="hidden" id="content_pixel_height" name="content_pixel_height"/>

            <input type="hidden" id="page_margin_left" name="page_margin_left"/>
            <input type="hidden" id="page_margin_right" name="page_margin_right"/>
            <input type="hidden" id="page_margin_top" name="page_margin_top"/>
            <input type="hidden" id="page_margin_bottom" name="page_margin_bottom"/>

            <input type="hidden" id="imagedata" name="imagedata"/>
            <input type="hidden" id="svg" name="svg"/>
            <input type="hidden" id="svg1" name="svg1"/>
            <input type="hidden" id="xhtml" name="xhtml"/>
        </form>
        <div id="svg_dom">

        </div>
    </body>
</html>
