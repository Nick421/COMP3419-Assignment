import processing.video.*;
import processing.sound.*;
 
Movie originalMovie;
Movie backgroundMovie;

PImage binaryImg;
PImage improvedImg;
PImage backgroundImg;

SoundFile chomama;
SoundFile yari;

int framenumber = 0;
object rimi;
ArrayList<PImage> textures;
ArrayList<intelligentObjects> obj;
PImage explosion;

void setup(){
  
  size(1280, 720);
  
  originalMovie = new Movie(this, sketchPath("monkey.mov"));
  backgroundMovie = new Movie(this, "videoplayback.mov");
  //backgroundImg = loadImage("background.png");
  
  textures = new ArrayList<PImage>(7);
  textures.add(loadImage("data/rimiBody.png"));
  textures.add(loadImage("data/rimiLeftLeg.png"));
  textures.add(loadImage("data/rimiLeftHand.png"));
  textures.add(loadImage("data/rimiRightHand.png"));
  textures.add(loadImage("data/rimiRightLeg.png"));
  textures.add(loadImage("data/cornet.png"));
  textures.add(loadImage("data/yajuu.png"));
  
  explosion = loadImage("data/Stamp_003001_en.png");
  
  rimi = new object(textures);
  obj = new ArrayList<intelligentObjects>(1);
 
  chomama = new SoundFile(this, "data/choco.wav");
  yari = new SoundFile(this, "data/yarimasune.wav");
  //frameRate(30);
  originalMovie.play();
  originalMovie.volume(0);
  
  backgroundMovie.play();
  backgroundMovie.volume(0.2);
 
}
void draw(){
  float time = originalMovie.time();
  float duration = originalMovie.duration();

  if(time == duration){
    exit();
  }
  background(0);
  if (backgroundImg != null ){
    image(backgroundImg,640,360,1280,720);
    
  }
  if(improvedImg != null ) {
    replaceMonkey(improvedImg);
  }
  addObjects();
  //saveFrame("export/image-###.png");
}

//https://processing.org/reference/libraries/video/movieEvent_.html
void movieEvent(Movie m) {
  if(m == originalMovie){
    m.read();
    //make the image optimal for reading points
    binaryImg = segmentMarkers(m);
    improvedImg = improve(binaryImg);
    
    //binaryImg.save(sketchPath("") + "binary/image" + framenumber + ".png");
    //improvedImg.save(sketchPath("") + "seg/image" + framenumber + ".png");
    framenumber++;
  }else if(m == backgroundMovie){
    m.read();
    backgroundImg = m;
    //framenumber++;
  }
  
}

PImage segmentMarkers(PImage video){
  
  PImage blank = new PImage(video.width, video.height);
  
  //apply 3 filter in order to take out the non reds.
  boolean red = false;
  boolean face = true;
  boolean brown = true;
  
  //usual for loop to get pixel colour 
  for(int x = 0; x < video.width; x++){
    for(int y = 0; y < video.height; y++){
      int loc = x + y * video.width;
      color c = video.pixels[loc];
     
      //the pixel should be in range 150 < red < 255 , 130 < green < 200 and 45 < blue < 125 according to eyedrop
      red = red(c) > 150  && green(c) > 37 && green(c) < 200 && blue(c) > 30 && blue(c) < 125;
      face = red(c) > 190 && red(c) < 255 && green(c) > 130 && green(c) < 200 && blue(c) > 45 && blue(c) < 125;
      brown = red(c) > 150 && red(c) < 200 && green(c) > 80 && green(c) < 165 && blue(c) > 40 && blue(c) < 115;
      
      // if the pixel correct has color mark it white on the new image
      if(red && !face && !brown){
        
        blank.pixels[loc] = color(255,255,255);
      }
    }
  }
  // return the new image with the white markers on it
  return blank;
}

//don't think this is needed? it helps to get rid of noises
PImage improve(PImage bin){
  
  PImage improvement = new PImage(bin.width, bin.height);
  
  // erode to get rid of noises
  improvement = dilateErode2D(bin, 0);  
  for(int i = 0; i < 2; i++){
    improvement = dilateErode2D(improvement,0);
  } 
  
  // dilate image 8 times
  for(int i = 0; i < 8; i++){
    improvement = dilateErode2D(improvement,1);
  } 

  return improvement;
}

ArrayList<PVector> splitQUAD(PImage dilated){
  color white = color(255,255,255);
  
  ArrayList<PVector> markers = new ArrayList<PVector>(5);
  
  int maxX = 0;
  int minX = Integer.MAX_VALUE;
  int maxY = 0;
  int minY = Integer.MAX_VALUE;
  loadPixels();  
  for(int x = 0; x < dilated.width; x++){
    for(int y = 0; y < dilated.height; y++){
      int loc = x + y * dilated.width;
      color c = dilated.pixels[loc];
      if (c == white){
        //println("found a white pixel");
        if (x > maxX ){
            //println("maxX "+x);
            maxX = x;
        }else if ( x < minX ){
            //println("minX "+x);
            minX = x;
        }
        
        if(y > maxY ){
            maxY = y;
        }else if ( y < minY ){
            minY = y;
        }
      }
      
    }
  }
  
  int midx = (maxX + minX)/2;
  int midy = (minY + maxY)/2;
  /*println("midx= "+ midx);
  println("midy= "+ midy);
  println("maxX= "+ maxX);
  println("minX= "+ minX);
  println("minY= "+minY);
  println("maxY= "+maxY);*/
  
  boolean tl = false;
  boolean tr = false;
  boolean bl = false;
  boolean br = false;
  
  //top left 
  TopLeftLoop:
  for(int i = minX; i < midx; i++){
    for(int j = minY; j < midy; j++){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
      if(c == white){
        //println("top left found");
        markers.add(new PVector(i,j));
        tl = true;
        break TopLeftLoop;
      }
    }
  }
  if (!tl){
     //println("top left not found");
     markers.add(new PVector(minX, minY));
  }
  
  //top right 
  TopRightLoop:
  for(int i = maxX; i > midx; i--){
    for(int j = minY; j < midy; j++){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
      if(c == white){
        //println("top right found");
        markers.add(new PVector(i,j));
        tr = true;
        break  TopRightLoop;
        
      }
    }
  }
  if(!tr){
    markers.add(new PVector(maxX, minY));
  } 
  
  //bottom left 
  //a bit special here as sometimes it overlaps with top left 
  //so we hard code in a threshold value, 20 seems to produce the best result 
  BottomLeftLoop:
  for(int i = minX; i < midx-20; i++){
    for(int j = maxY; j > midy+20; j--){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
      
      if(c == white){
        //println("bottom left found");
        markers.add(new PVector(i,j));
        bl = true;
        break BottomLeftLoop;
        
      }
    }
  }
  if(!bl){ 
    markers.add(new PVector(minX, maxY));
  }
  
  //bottom right 
  BottomRightLoop:
  for(int i = maxX; i > midx+15; i--){
    for(int j = maxY; j > midy+15; j--){
      int loc = i + j * dilated.width;
      color c = dilated.pixels[loc];
     
      if(c == white){
        //println("bottom right found");
        br = true;
        markers.add(new PVector(i,j));
        break BottomRightLoop;
      }
    }
  }
  if(!br){
    markers.add(new PVector(maxX, maxY)); 
  } 
  
  //then we get the center marker
  markers.add(new PVector((maxX+minX)/2,(minY+maxY)/2));
  //println("return from quad method "+markers);
  return markers;
  
}

void replaceMonkey(PImage image){
  ArrayList<PVector> points = splitQUAD(image);
  //println(points);
  rimi.setPoints(points);
  rimi.show();
}

void addObjects(){
  int rand = (int)random(0, 4);
  int randy = (int)random(60, 700);
  boolean direction = Math.random() < 0.5;
  int randO = (int)random(0,2);
  
  int randCornerX = 0;
  int randCornerY = 0;
  
  //println(rand);
  if (rand == 1){
    randCornerX = 1280; 
  }else if (rand == 2){
    randCornerY = 720;
  }else if(rand == 3){
    randCornerX = 1280;
    randCornerY = 720;
  }
  
  
  //println(randy);
  PImage texture = null;
  intelligentObjects o = null;
  if((framenumber % 15) == 0){
    if(randO == 0){
      texture = textures.get(5);
      o = new intelligentObjects(texture,randy,direction);
      
    }
    if(randO == 1){
      texture = textures.get(6);
      
      o = new intelligentObjects(texture,randy,true);
      o.setCorner(randCornerX, randCornerY);
    }
  }
  if(o != null){
    obj.add(o);
  }
  
  ArrayList<intelligentObjects> delete = new ArrayList<intelligentObjects>();
  
  //collision between yajuu senpai and coronet
  for(intelligentObjects i : obj){
    for(intelligentObjects k : obj){
      
      if(i.collide(k) == true && k != i){
        //check if either of them is yajuu
        //yes then evolve
        if(i.isYajuu() == true){
          i.evolve(explosion);
          delete.add(k);
        }
        if(k.isYajuu() == true){
          delete.add(i);
          k.evolve(explosion);
        }
        
        yari.play();
        break;
      }
    }
    
  }
  
  obj.removeAll(delete);
  delete.clear();
  
  //any collision with rimi
  for(intelligentObjects i : obj){
    if(rimi.collide(i) == true && i.isYajuu() == false){
      delete.add(i);
      image(explosion,i.getx(),i.gety());
      chomama.play();
      break;
    }else if(rimi.collide(i) == true && i.isYajuu() == true){
      
      break;
    }
    
  }
  
  obj.removeAll(delete);
  delete.clear();
  
  //delete stuff out of screen
  for(intelligentObjects i : obj) {
      if(i.outScreen() == true){
        delete.add(i);
      }
  }
  obj.removeAll(delete);
  delete.clear();
  
  //update the new co-ordinates for alive stuff
  for(intelligentObjects i : obj) {
      i.update();
  }
  

}
