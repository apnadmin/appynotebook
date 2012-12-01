/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.feezixlabs.util;

/**
 *
 * @author bitlooter
 */
//Java
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

//Batik
import org.apache.batik.transcoder.Transcoder;
import org.apache.batik.transcoder.TranscoderException;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;

//FOP
import org.apache.fop.svg.PDFTranscoder;

/**
 * This class demonstrates the conversion of an SVG file to PDF using FOP.
 */
public class SVG2PDF {

    /**
     * Converts an FO file to a PDF file using FOP
     * @param svg the SVG file
     * @param pdf the target PDF file
     * @throws IOException In case of an I/O problem
     * @throws TranscoderException In case of a transcoding problem
     */
    public void convertSVG2PDF(File svg, File pdf) throws IOException, TranscoderException {

        //Create transcoder
        Transcoder transcoder = new PDFTranscoder();
        //Transcoder transcoder = new org.apache.fop.render.ps.PSTranscoder();

        //Setup input
        InputStream in = new java.io.FileInputStream(svg);
        try {
            TranscoderInput input = new TranscoderInput(in);

            //Setup output
            OutputStream out = new java.io.FileOutputStream(pdf);
            out = new java.io.BufferedOutputStream(out);
            try {
                TranscoderOutput output = new TranscoderOutput(out);

                //Do the transformation
                transcoder.transcode(input, output);
            } finally {
                out.close();
            }
        } finally {
            in.close();
        }
    }



    public static TranscoderOutput convertSVG2PDF(String svg,OutputStream out) throws IOException, TranscoderException {

        //Create transcoder
        Transcoder transcoder = new PDFTranscoder();
        //Transcoder transcoder = new org.apache.fop.render.ps.PSTranscoder();

        //Setup input
        InputStream in = new java.io.ByteArrayInputStream(svg.getBytes("UTF-8"));
        try {
            TranscoderInput input = new TranscoderInput(in);
            System.out.println("document:"+input.getDocument());
            //((org.apache.batik.dom.svg.SVGOMDocument)input.getDocument()).setURLObject(new java.net.URL(com.feezixlabs.util.ConfigUtil.baseUrl));
            //Setup output
            //OutputStream out = new java.io.ByteArrayOutputStream(svg.length());
            out = new java.io.BufferedOutputStream(out);
            try {
                TranscoderOutput output = new TranscoderOutput(out);

                //Do the transformation
                transcoder.transcode(input, output);
                return output;
            } finally {
                out.close();
            }
        } finally {
            in.close();

        }
    }


    /**
     * Main method.
     * @param args command-line arguments
     */
    public static void main(String[] args) {
        try {
            System.out.println("FOP ExampleSVG2PDF\n");
            System.out.println("Preparing...");

            //Setup directories
            File baseDir = new File(".");
            File outDir = new File(baseDir, "out");
            outDir.mkdirs();

            //Setup input and output files
            File svgfile = new File(baseDir, "xml/svg/helloworld.svg");
            File pdffile = new File(outDir, "ResultSVG2PDF.pdf");

            System.out.println("Input: SVG (" + svgfile + ")");
            System.out.println("Output: PDF (" + pdffile + ")");
            System.out.println();
            System.out.println("Transforming...");

            SVG2PDF app = new SVG2PDF();
            app.convertSVG2PDF(svgfile, pdffile);

            System.out.println("Success!");
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(-1);
        }
    }
}
