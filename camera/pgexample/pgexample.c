/*
* 2022-01-06  William A. Hudson
*
* Initial try at using Netpbm library.
*/

#include <iostream>     // std::cerr
#include <iomanip>

#include <stdio.h>
#include <netpbm/pgm.h>

using namespace std;

int
main()
{

    FILE	*fp;
    gray**	img;		// pointer to image array img[row][col]
    int		Ncol;
    int		Nrow;
    unsigned	MaxVal;

    fp = fopen( "my_file.pgm", "r" );

    if ( fp == NULL ) {
	cerr << "Error:  file not found:  my_file.pgm" <<endl;
	return( 1 );
    }

    pm_init( "MyProg", 0 );

    img = pgm_readpgm(
	fp,
	&Ncol,
	&Nrow,
	&MaxVal		// maximum gray value
    );

    cout << "Ncol   =" << Ncol   <<endl;
    cout << "Nrow   =" << Nrow   <<endl;
    cout << "MaxVal =" << MaxVal <<endl;

    cout << "im[0,0]= " << **img <<endl;
    cout << "im[1]= " << img[1] <<endl;
    cout << "*im[1]= " << *img[1] <<endl;
    cout << "*im[2]= " << *img[2] <<endl;
    cout << "im[3,8]= " << img[3][8] <<endl;
    cout <<endl;

    // Works as an array of pointers to array:  img[row][col]
    // img[row] = pointer to an array of length Ncol

    cout << "show pointers:" <<endl;
    for ( int i=0;  i<Nrow;  i++ )
    {
	cout << "ip[" << i << "]= " << img[i] <<endl;
    }

    cout <<endl;

    cout << "show pixel values:" <<endl;
    for ( int i=0;  i<Nrow;  i++ )
    {
	for ( int j=0;  j<Ncol;  j++ )
	{
	    cout << "im[" << i << "," << j << "]= " << img[i][j] <<endl;
	}
    }

}

