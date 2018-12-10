import java.util.Arrays;

/* This class is a modification of tutorial 2
 * the use of augmented matrix instead of usual [0,1,0
                                                 1,1,1
                                                 0,1,0]
 * we will just make an array of boolean with false as we only scan for
 * things in the kernel that have 1 in it.
 * this mean for each pixel we just need to see middle,left,right,up and down.
 * if white we we set the array to true and later we check if all 5 of them is true
 * add a white pixel on the new image.
 * dilation is simialar but with out the need of kernel
 * as we are dilating the eroded image, we just need to see if white pixel add it.
*/
PImage dilateErode2D(PImage oimg, int mode) {
  //mode 0 = erode, 1 = dilate 
  PImage newImg = new PImage(oimg.width, oimg.height);
  color white = color(255,255,255);
  color black = color(0,0,0);
  boolean add = false;
  if(mode == 0){
      boolean[] augMatrix = new boolean[5];
  
      for(int y = 1; y < oimg.height - 1; y++) {
        for(int x = 1; x < oimg.width - 1; x++) {
          
          add = true;
          Arrays.fill(augMatrix ,false);
           
         // Check the pixels up,left,center,right and down
         if(oimg.pixels[x + ((y-1)*oimg.width)] == white){
           augMatrix[0] = true;
         }
         if(oimg.pixels[(x-1) + y*oimg.width] == white){
           augMatrix[1] = true;
         }
         if(oimg.pixels[x + y*oimg.width] == white){
           augMatrix[2] = true;
         } 
         if(oimg.pixels[(x+1) + y*oimg.width] == white){
           augMatrix[3] = true;
         } 
         if(oimg.pixels[x + ((y+1)*oimg.width)] == white){
           augMatrix[4] = true;
         }
         
         //check if all matrix all true
         for(int i = 0; i < 5; i++){
          if(augMatrix[i] == true){
            add = true;
          }else{
            add = false;
            break;
          }
         }
         
         if(add){
           newImg.pixels[x + y*oimg.width] = white;
         }else{
           newImg.pixels[x + y*oimg.width] = black;
         }   
        }
      }
  
   
    return newImg;
  }
  if(mode == 1){
      for(int y = 1; y < oimg.height - 1; y++) {
        for(int x = 1; x < oimg.width - 1; x++) {
          
          add = false;
           
         if(oimg.pixels[(x+0) + ((y-1)*oimg.width)] == white){
           add = true;
         }
         if(oimg.pixels[(x-1) + ((y+0)*oimg.width)] == white){
           add = true;
         }
         if(oimg.pixels[(x+0) + ((y+0)*oimg.width)] == white){
           add = true;
         } 
         if(oimg.pixels[(x+1) + ((y+0)*oimg.width)] == white){
           add = true;
         } 
         if(oimg.pixels[(x+0) + ((y+1)*oimg.width)] == white){
           add = true;
         }
         
         if(add){
           newImg.pixels[x + y*oimg.width] = white;
         }else{
           newImg.pixels[x + y*oimg.width] = black;
         }   
        }
      }
  
    return newImg;
  }
  
  
  return newImg;
}
