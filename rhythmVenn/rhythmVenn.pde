import netP5.*;
import oscP5.*;
OscP5 oscP5;

import controlP5.*;
//import edu.uic.ncdm.venn.data.*;
//import edu.uic.ncdm.venn.*;
//import edu.uic.ncdm.venn.display.*;

ControlP5 cp5;

VennData vd;
VennAnalytic va;
VennDiagram d;

VennCanvas vc;

String labels[] = {"K", "S", "C", "O", "K&S", "K&C", "K&O", "S&C", "S&O", "C&O", 
  "K&S&C", "K&S&O", "K&C&O", "S&C&O", "K&S&O&C"};

double lastAreas[] = new double[labels.length];  
double currentAreas[] = new double[labels.length];

double[] averageAreas(double[] area1, double[] area2)
{
  double average[] = new double[area1.length];
  for (int i=0; i<average.length; i++)
    average[i] = (area1[i] + area2[i]) / 2.0;
  return average;
}

int stepCount = 0;

CustomMatrix m;


void setup()
{

  for (int i=0; i<labels.length; i++)
    currentAreas[i] = 0.0f;

  size(800, 600);

  oscP5 = new OscP5(this, 8000);  

  noStroke();

  frameRate(150);
  cp5 = new ControlP5(this);

  computeVenn();

  int x = 525;
  for (int i=0; i<4; i++) {
    cp5.addSlider(labels[i])
      .setPosition(x+=50, 50)
      .setSize(20, 100)
      .setRange(0.0, 1.0) 
      .setId(i)
      .setColorForeground(vc.colors[i])
      ;
  }

  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 


  //cp5.getController("sliderValue1").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  int y = 150;

  for (int i=4; i<labels.length; i++) {
    cp5.addSlider(labels[i])
      .setPosition(575, y+=50)
      .setSize(100, 20)
      .setRange(0.0, 1.0) 
      .setId(i)
      ;
  }

  x = 16;
  y = 4; 

  m = new CustomMatrix(cp5, "");
  // set parameters for our CustomMatrix
  m.setPosition(25, 425)
    .setSize(450, 150)
    .setInterval(1000)
    .setGrid(x, y)
    .setMode(ControlP5.MULTIPLES)
    .setColorBackground(color(120))
    .setBackground(color(40));

  //m.initPresets();
  m.stop();





  //VennFrame vennFrame = new VennFrame(d);    

  //    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  //    frame.pack();
  //    frame.setVisible(true);
  //    frame.setSize(800, 600);
}

void computeVenn()
{
  vd = new VennData(labels, currentAreas);     
  va = new VennAnalytic();  
  d = va.compute(vd);   
  vc = new VennCanvas(d);
}

void draw()
{
  background(20);
  pushMatrix();    
  translate(100, 100);
  vc.paintComponent();
  popMatrix();
}


void controlEvent
  (ControlEvent theEvent) {
  //for (int i=0; i< labels.length; i++) {
  //  if (theEvent.getController().getId() == i) {
  //    areas[i] = theEvent.getController().getValue() / 255.0;
  //  }
  //}
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  //if (theOscMessage.checkAddrPattern("/probData")==true) {
  //  /* check if the typetag is the right one. */
  //  if (theOscMessage.checkTypetag("ffffffffffffffff")) {
  //    for (int i=0; i< labels.length; i++) {
  //      currentAreas[i] = theOscMessage.get(i+1).floatValue();           
  //      cp5.getController(labels[i]).setValue((float)currentAreas[i]);
  //    }
  //    //if(stepCount++ > 16)
  //    //  stepCount = 0;
  //    //if(stepCount%2 == 0)         
  //    //  ;
  //  }
  //  computeVenn();
  //} else if (theOscMessage.checkAddrPattern("/drumData")==true) {
  //  /* check if the typetag is the right one. */
  //  if (theOscMessage.checkTypetag("iiiii")) {      
  //    for (int i=0; i<4; i++) {
  //    }
  //    //if(++stepCount == 16)
  //    //  stepCount=0;      
  //    //print("### received an osc message.");
  //    //print(" addrpattern: "+theOscMessage.addrPattern());
  //    //println(" typetag: "+theOscMessage.typetag());
  //    theOscMessage.print();
  //  }
    if (theOscMessage.checkAddrPattern("/probData")==true) {
      /* check if the typetag is the right one. */
      if (theOscMessage.checkTypetag("iiiiiffffffffffffffff")) {
              
        int step = theOscMessage.get(4).intValue()%16;
        
        if(step == 0)
          m.clear();
        
        for (int i=0; i<4; i++) {
          if(theOscMessage.get(i).intValue() == 1)
            m.set(step, 3-i, true);
        }
        
        m.trigger(step);
        m.update();
               
        //Process the probabilities - remember to ignore first entry which is silence
        for (int i=6; i < 21; i++) {
          currentAreas[i-6] = theOscMessage.get(i).floatValue();           
          cp5.getController(labels[i-6]).setValue((float)currentAreas[i-6]);         
        }
        
        computeVenn();
      }
    }
}