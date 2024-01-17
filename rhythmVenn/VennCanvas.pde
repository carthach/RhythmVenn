/*
 * VennEuler -- A Venn and Euler Diagram program.
 *
 * Copyright 2009 by Leland Wilkinson.
 *
 * The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License")
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the License.
 */

//package edu.uic.ncdm.venn.display;

//import edu.uic.ncdm.venn.VennDiagram;

//import javax.swing.*;
//import java.awt.*;
//import java.awt.font.FontRenderContext;
//import java.awt.geom.Rectangle2D;
//import java.awt.image.BufferedImage;

public class VennCanvas {
  //private BufferedImage bi;
  public double[][] centers;
  public double[] diameters;
  //public double[] colors;
  public color[] colors = new color[4];
  public String[] labels;
  private int size;
  private double mins, maxs;
  //private FontRenderContext frc;

  PVector lastPos = new PVector(0, 0);
  PVector curentPos = new PVector(0, 0);  
  int lastSize = 0;  

  public VennCanvas(VennDiagram venn) {
    size = 700;
    //bi = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
    //frc = bi.createGraphics().getFontRenderContext();
    size *= .4;
    centers = venn.centers;
    diameters = venn.diameters;
    //colors = venn.colors;
    labels = venn.circleLabels;
    mins = Double.POSITIVE_INFINITY;
    maxs = Double.NEGATIVE_INFINITY;
    for (int i = 0; i < centers.length; i++) {
      double margin = diameters[i] / 2;
      mins = Math.min(centers[i][0] - margin, mins);
      mins = Math.min(centers[i][1] - margin, mins);
      maxs = Math.max(centers[i][0] + margin, maxs);
      maxs = Math.max(centers[i][1] + margin, maxs);

      //this.colors[i] = rainbow(venn.colors[i], .4f);
      this.colors[i] = rainbowRGB(i, venn.colors[i], .4f);
      //this.colors[i] = rainbowRGB(i, 0.0f, .4f);
    }
  }

  public void paintComponent() {
    //Graphics2D g2D = (Graphics2D) bi.getGraphics();
    //g2D.setColor(Color.WHITE);
    //g2D.fillRect(0, 0, bi.getHeight(), bi.getWidth());
    for (int i = 0; i < centers.length; i++) {
      double xi = (centers[i][0] - mins) / (maxs - mins);
      double yi = (centers[i][1] - mins) / (maxs - mins);
      double pi = diameters[i] / (maxs - mins);


      int pointSize = (int) (pi * size);
      int x = 50 + (int) (xi * size);
      int y = 50 + (int) (size - yi * size); 

      //color c = color(255, 0, 0);          

      fill(this.colors[i]);
      //g2D.setColor(color);
      //g2D.fillOval(x - pointSize / 2, y - pointSize / 2, pointSize, pointSize);
      //ellipse((float)x - pointSize / 2, (float)y - pointSize / 2, (float)pointSize, (float)pointSize);

      ellipse((float)x - pointSize / 2, (float)y - pointSize / 2, (float)pointSize, (float)pointSize);      
      //g2D.setColor(color.BLACK);
      //double[] wh = getWidthAndHeight(labels[i], g2D);
      //g2D.drawString(labels[i], x - (int) wh[0] / 2, y + (int) wh[1] / 2);
    }

    //Graphics2D gg = (Graphics2D) g;
    //gg.drawImage(bi, 2, 2, this);
  }

  private color rainbowRGB(int index, double value, float transparency) {
    /* blue to red, approximately by wavelength */
    float v = (float) value * 255.f;
    float vmin = 0;
    float vmax = 255;
    float range = vmax - vmin;


    //if (v < vmin + 0.25f * range)
    //  return color(0.f*255.0, (4.f * (v - vmin) / range) * 255.0, 1.f*255.0, transparency*255.0);
    //else if (v < vmin + 0.5 * range)
    //  return color(0.f*255.0, 1.f*255.0, (1.f + 4.f * (vmin + 0.25f * range - v) / range)*255.0, transparency*255.0);
    //else if (v < vmin + 0.75 * range)
    //  return color((4.f * (v - vmin - 0.5f * range) / range)*255.0, 1.f*255.0, 0, transparency*255.0);
    //else
    //  return color(1.f*255.0, (1.f + 4.f * (vmin + 0.75f * range - v) / range)*255.0, 0, transparency*255.0);

    color c = color(0, 0, 255);

    switch(index)
    {
    case 0:
      c = color((5.f * (v - vmin) / range) * 255.0, 0.15f*255.0f, 0.0f, transparency*255.0);
      break;
    case 1:
      c = color(0.0f, 0.15f*255.0f, (5.f * (v - vmin) / range) * 255.0, transparency*255.0);
      break;
    case 2:
      c = color(0.0f, (4.f * (v - vmin) / range) * 255.0, 0, transparency*255.0);
      break;
    case 3:
      c = color(0.0f, (4.f * (v - vmin) / range) * 255.0, 0.7f*255.0f, transparency*255.0);
      break;      
      //case 2:
      //  c = color(0.f*255.0, (2.f * (v - vmin) / range) * 255.0, 1.f*255.0, transparency*255.0);
      //  break;
      //case 3:

      //  break;
    }
    return c;
  }

  private color rainbow(double value, float transparency) {
    /* blue to red, approximately by wavelength */
    float v = (float) value * 255.f;
    float vmin = 0;
    float vmax = 255;
    float range = vmax - vmin;

    color c;
    if (v < vmin + 0.25f * range)
      return color(0.f*255.0, (4.f * (v - vmin) / range) * 255.0, 1.f*255.0, transparency*255.0);
    else if (v < vmin + 0.5 * range)
      return color(0.f*255.0, 1.f*255.0, (1.f + 4.f * (vmin + 0.25f * range - v) / range)*255.0, transparency*255.0);
    else if (v < vmin + 0.75 * range)
      return color((4.f * (v - vmin - 0.5f * range) / range)*255.0, 1.f*255.0, 0, transparency*255.0);
    else
      return color(1.f*255.0, (1.f + 4.f * (vmin + 0.75f * range - v) / range)*255.0, 0, transparency*255.0);
  }

  //public double[] getWidthAndHeight(String s, Graphics2D g2D) {
  //    Font font = g2D.getFont();
  //    Rectangle2D bounds = font.getStringBounds(s, frc);
  //    double[] wh = new double[2];
  //    wh[0] = bounds.getWicolordth();
  //    wh[1] = .7 * bounds.getHeight();
  //    return wh;
  //}
}