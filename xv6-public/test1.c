#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main()
{
   int fd1 = open("text1.txt", O_SMALL);// Create a small file text1 
   fd1 = open("text1.txt", O_RDWR);//open the file as read and write mode
   write(fd1, "aaaaaaa", 7);// write data to the small file
   close(fd1);// when finish write, close the file
   char c;
   fd1 = open("text1.txt", O_RDONLY);
   read(fd1,&c,1);// read data from the small file
   printf(1, "%c\n", c);// print the data we read
   close(fd1);
   exit();
}
