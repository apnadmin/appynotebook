/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;

import java.io.InputStream;
import java.io.IOException;

import org.xml.sax.SAXException;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;
/**
 *
 * @author bitlooter
 */


public class ClassPathEntityResolver implements EntityResolver {

    public InputSource resolveEntity(String publicId, String systemId)
        throws SAXException, IOException {

        String resource = systemId.substring(systemId.lastIndexOf('/')+1);
        InputSource inputSource = null;
        //System.out.println("looking:"+systemId);
        try {
            InputStream inputStream = null;
            if(resource.compareToIgnoreCase("xhtml1-strict.dtd") == 0)
                inputStream = ClassPathEntityResolver.class.getClassLoader().getResourceAsStream("resources/schema/xhtml/xhtml-1/xhtml1-strict.dtd");
            else
            if(resource.compareToIgnoreCase("xhtml-lat1.ent") == 0)
                inputStream = ClassPathEntityResolver.class.getClassLoader().getResourceAsStream("resources/schema/xhtml/entity/xhtml-lat1.ent");
            else
            if(resource.compareToIgnoreCase("xhtml-symbol.ent") == 0)
                inputStream = ClassPathEntityResolver.class.getClassLoader().getResourceAsStream("resources/schema/xhtml/entity/xhtml-symbol.ent");
            else
            if(resource.compareToIgnoreCase("xhtml-special.ent") == 0)
                inputStream = ClassPathEntityResolver.class.getClassLoader().getResourceAsStream("resources/schema/xhtml/entity/xhtml-special.ent");



            inputSource = new InputSource(inputStream);
            
        } catch (Exception e) {
            // No action; just let the null InputSource pass through
            e.printStackTrace();
        }

        // If nothing found, null is returned, for normal processing
        return inputSource;
    }
}
