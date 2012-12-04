-- MySQL dump 10.13  Distrib 5.5.28, for debian-linux-gnu (i686)
--
-- Host: appynotebook.com    Database: appynotebook
-- ------------------------------------------------------
-- Server version	5.1.49-1ubuntu8.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `text_data`
--

DROP TABLE IF EXISTS `text_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `text_data` (
  `id` varchar(64) NOT NULL,
  `descp` varchar(256) NOT NULL,
  `data` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `text_data`
--

LOCK TABLES `text_data` WRITE;
/*!40000 ALTER TABLE `text_data` DISABLE KEYS */;
INSERT INTO `text_data` VALUES ('WIDGET_CODE_TEMPLATE','starting point code for creating widgets','{\n    onInit:function(){\n        var _this = this;\n        //place this call somewhere in your code when you know your applet is ready to create instances\n        this.ready();\n    },\n    onInstantiate:function(pad,element,parent_grp){\n	if(typeof element != \'undefined\'){//create instance from config\n\n        }else{//initialize new instance using defaults\n\n        }\n    },\n    onMessage:function(pad,message){\n        switch(message.type){\n            case \'shuffle\':\n        }\n    },\n    onGainFocus:function(pad,app_instance){\n\n    },\n    onLossFocus:function(pad,app_instance){\n\n    },\n    onDeleteInstance:function(pad,app_instance){\n\n    },\n    onClosePad:function(pad,app_instance){\n\n    },\n    onTranslate:function(pad,app_instance,delta){      \n      //this.log(\'translate(\'+delta.x+\',\'+delta.y+\')\')\n    },\n    onScale:function(pad,app_instance,delta){\n      //this.log(\'scale(\'+delta.x+\',\'+delta.y+\')\')\n    },\n    onRotate:function(pad,app_instance,delta){\n       //this.log(\'rotate(\'+delta+\')\')\n    },\n    onScreenMouseEnter:function(pad,p,event){\n       //this.log(\'mouse entered: (\'+p.x+\',\'+p.y+\')\')\n    },\n    onScreenMouseOut:function(pad,p,event){\n       //this.log(\'mouse out: (\'+p.x+\',\'+p.y+\')\')         \n    },\n    onScreenMouseDown:function(pad,p,event){\n       //this.log(\'mouse down: (\'+p.x+\',\'+p.y+\')\')\n    },\n    onScreenMouseMove:function(pad,p,event){\n       //this.log(\'mouse move: (\'+p.x+\',\'+p.y+\')\')\n    },\n    onScreenMouseUp:function(pad,p,event){\n       //this.log(\'mouse up: (\'+p.x+\',\'+p.y+\')\')\n    }\n}'),('WIDGET_MENU_STRUCTURE','menu structure of widgets','<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ns1:Menu title=\"Please Select\" id=\"2f659fd0-12e8-11e0-a792-0019b958a435\" xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\'\n   xmlns:ns1=\'http://xml.netbeans.org/schema/widget-menu\'\n   xsi:schemaLocation=\'http://xml.netbeans.org/schema/widget-menu file:/home/bitlooter/development/java/collabopad/src/java/com/appynotebook/bean/widgetmenu/widget-menu.xsd\'>\n     <ns1:Menus title=\'Misc\' id=\"cea4d620-f69a-102c-96ab-0019b958a435\">       \n     </ns1:Menus>\n     <ns1:Menus title=\'Education\' id=\"d49f800c-f69a-102c-96ab-0019b958a435\">\n       <ns1:Menus title=\'Mathematics\' id=\"da07d3d2-f69a-102c-96ab-0019b958a435\">\n       </ns1:Menus>\n       <ns1:Menus title=\'Physics\' id=\"dfe29904-f69a-102c-96ab-0019b958a435\">               \n       </ns1:Menus> \n       <ns1:Menus title=\'Computer Science\' id=\"dfe29904-f69a-112c-96ab-0019b958a417\">               \n       </ns1:Menus>       \n     </ns1:Menus>\n     <ns1:Menus title=\'Games\' id=\"bc824706-219d-102d-b969-0019b958a435\">\n       \n     </ns1:Menus>     \n     <ns1:Menus title=\'Communication\' id=\"bxc824706-219d-102d-b969-0019b958a435\">\n       \n     </ns1:Menus>       \n     <ns1:Menus title=\'Diagramming\' id=\"a8459180-2751-102d-b1fa-0019b958a435\">\n       \n     </ns1:Menus>\n      <ns1:Menus title=\'Premium Catalog\' id=\"0\" premium=\"true\" pages=\"0\">\n         <ns1:Menus title=\'Physics\' id=\"1\">\n              <ns1:Menus title=\'Motion\' id=\"d125da2c-5827-102d-8fb9-0019b958a435\" pages=\"5\">       \n              </ns1:Menus>\n              <ns1:Menus title=\'Force\' id=\"da2e4492-5827-102d-8fb9-0019b958a435\" pages=\"5\">      \n              </ns1:Menus> \n              <ns1:Menus title=\'Acceleration\' id=\"df4c16c0-5827-102d-8fb9-0019b958a435\" pages=\"5\">      \n              </ns1:Menus>\n        </ns1:Menus>    \n         <ns1:Menus title=\'Electronics\' id=\"3\">\n              <ns1:Menus title=\'Resistors\' id=\"e57ebf2a-5827-102d-8fb9-0019b958a435\" pages=\"5\">      \n              </ns1:Menus>\n              <ns1:Menus title=\'Current\' id=\"eb2b934e-5827-102d-8fb9-0019b958a435\" pages=\"5\">      \n              </ns1:Menus>\n              <ns1:Menus title=\'Voltage\' id=\"f52f0722-5827-102d-8fb9-0019b958a435\" pages=\"5\">      \n              </ns1:Menus>\n        </ns1:Menus>              \n     </ns1:Menus>    \n</ns1:Menu>'),('WIDGET_MENU','current widget menu',''),('IMAGE_WIDGET_ID','id for image widget','21'),('SYSTEM-WIDGETS','','[{name:\'chess\',id:22},{name:\'checkers\',id:23}]'),('rich-text-editor','Applet for word processor','1c1767f21a6011e29fb01231381dd16f'),('welcome-context','This would be the default book that will be created for new users',''),('embeded-rich-text-editor-classid','rich editor page','1c1764641a6011e29fb01231381dd16f'),('embeded_web_page_classid','Web page editor','1c1766301a6011e29fb01231381dd16f');
/*!40000 ALTER TABLE `text_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-02 14:18:42
