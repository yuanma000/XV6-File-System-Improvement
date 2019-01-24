#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main()
{
   int fd2 = open("text2.txt", O_SMALL);// Create a small file text2 
   fd2 = open("text2.txt", O_RDWR);//open the file as read and write mode
   int buf[14];
   for(int i=0; i<14; i++){
      buf[i] = i;
   }
   write(fd2, buf, 53);// write data longer than 52 bytes to the small file
   close(fd2);
   exit();
}
