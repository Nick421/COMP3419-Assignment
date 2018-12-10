public class parts{
  float x,y;
  PImage image;
  
  public parts(PImage im){
    image = im;
  }
  public void setXY(float x , float y){
    this.x = x;
    this.y = y;
  }
  public void show(){
    imageMode(CENTER);
    image(image, x, y);
  }
  public float getx(){
    return this.x;
  }
  public float gety(){
    return this.y;
  }
  public float textureLengthX(){
    return x + image.width;
  }
  
  public float textureLengthY(){
    return y + image.height;
  }
}
