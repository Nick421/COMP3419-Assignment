public class object{
  parts body;
  parts leftLeg;
  parts leftHand;
  parts rightHand;
  parts rightLeg;
  
  public object(ArrayList<PImage> textures){
    body = new parts(textures.get(0));
    leftLeg = new parts(textures.get(1));
    leftHand = new parts(textures.get(2));
    rightHand = new parts(textures.get(3));
    rightLeg = new parts(textures.get(4));
  }
  
  public void setPoints(ArrayList<PVector> points){
     if(points.get(0) != null ){
        //ellipseMode(CENTER); 
        //ellipse(points.get(0).x+400, points.get(0).y+200, 20, 20);
        leftHand.setXY(points.get(0).x+300, points.get(0).y+200);
      }
       
    if(points.get(1) != null){
          //ellipseMode(CENTER); 
          //ellipse(points.get(1).x+400, points.get(1).y+200, 20, 20);
          rightHand.setXY(points.get(1).x+500, points.get(1).y+200);
       }
    if(points.get(2) != null){
          //ellipseMode(CENTER); 
          //ellipse(points.get(2).x+400, points.get(2).y+200, 20, 20);
          leftLeg.setXY( points.get(2).x+400, points.get(2).y+200);
       }
    if(points.get(3) != null){
          //ellipseMode(CENTER); 
          //ellipse(points.get(3).x+400, points.get(3).y+200, 20, 20);
          rightLeg.setXY( points.get(3).x+400, points.get(3).y+200);
       }
    if(points.get(4) != null){
          //ellipseMode(CENTER); 
          //ellipse(points.get(4).x+400, points.get(4).y+200, 20, 20);
          body.setXY( points.get(4).x+400, points.get(4).y+100);
      }
  }
  public void show(){
    body.show();
    leftLeg.show();
    leftHand.show();
    rightHand.show();
    rightLeg.show();
  }
  public boolean collide(intelligentObjects i){
    
    //check left hand
    if(leftHand.getx() < i.textureLengthX() && leftHand.textureLengthX() > i.getx()
      && leftHand.gety() < i.textureLengthY() && leftHand.textureLengthY() > i.gety() ){
      return true;
    }
    
    //check left leg
    if(leftLeg.getx() < i.textureLengthX() && leftLeg.textureLengthX() > i.getx()
      && leftLeg.gety() < i.textureLengthY() && leftLeg.textureLengthY() > i.gety()){
      return true;
    }
    
    //check right hand
    if(rightHand.getx() < i.textureLengthX() && rightHand.textureLengthX() > i.getx()
     && rightHand.gety() < i.textureLengthY() && rightHand.textureLengthY() > i.gety()){
      return true;
    }
    
    //check right leg
    if(rightLeg.getx() < i.textureLengthX() && rightLeg.textureLengthX() > i.getx()
     && rightLeg.gety() < i.textureLengthY() && rightLeg.textureLengthY() > i.gety()){
      return true;
    }
    
    //check body/head
    if(body.getx() < i.textureLengthX() && body.textureLengthX() > i.getx()
     && body.gety() < i.textureLengthY() && body.textureLengthY() > i.gety()){
      return true;
    }
    
    return false;
  }
}
