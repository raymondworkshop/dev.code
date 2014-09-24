#include "masked_face_detection.h"

using namespace cv;
using namespace std;

int main( int argc, char* argv[] )
{
	//if( argc != 2)
    //{
    // cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
    // return -1;
    //}
	int num = 0;
	double k = 1.645;
    //double result[50];
	//normazation
	double max_mean = 0, min_mean = 1000, norm_measured_mean_pxl = 0;
	double value = 1;

	//store the result
	FILE* result_file;
	//char re[256];

	//the image dir
	string dir = "D:\\wenlong\\workspace\\proj\\MaskedfaceDetection\\MaskedfaceDetection\\forehead\\";
	//string dir_name = "D:\\wenlong\\workspace\\proj\\FaceLivenessDetection\\FaceLivenessDetection\\forehead\\";
	string files_name = dir + "*.jpg";

	//find the related image files
	struct _finddata_t file_info; 
	long handle = _findfirst(files_name.c_str(), &file_info);

	if(handle == -1) { 
		printf("Cannot read file info!\n"); 
		return -1; 
	}

	//printf("First image name: %s\n",file_info.name);

	//store the result
	result_file = fopen("result.txt", "a+");
	//fprintf(result_file, "Image_Name ");
	fprintf(result_file, "%s\t\t%s\n", "Image_Name", "Average_gray_value");

while(_findnext(handle, &file_info) == 0) {	
	string file_name = dir + file_info.name ;

	//string file = file_info.name;
    printf("The image name: %s \n", file_info.name );

	struct Image image;

    Mat gray_image;
	//get gray scale image
    gray_image = imread(file_name, CV_LOAD_IMAGE_GRAYSCALE); // Read the file

    if(! gray_image.data ) // Check for invalid input
    {
        printf("Could not open or find the image \n");
        return -1;
    }

    //namedWindow( "Display window", WINDOW_AUTOSIZE ); // Create a window for display.
   // imshow( "source image", image ); // Show our image inside it.
	//convert the image from BGR to Grayscale format
	//Mat gray_image;
	//cvtColor(image, gray_image, CV_BGR2GRAY);
	//imshow("gray image", gray_image);
	
	//get mean and standard deviation
	//Scalar is a four-double-type-element array
	Scalar mean, stddev; 
	meanStdDev(gray_image, mean, stddev);

	uchar mean_pxl = mean.val[0];
	uchar stddev_pxl = stddev.val[0];

	//cout << "mean value: " <<mean_pxl <<endl;
	//cout << "Standard deviation: " << stddev_pxl <<endl;
	printf("mean value: %u\n", mean_pxl);
	printf("Standard deviation: %u\n", stddev_pxl);

	int rows = gray_image.rows;
	int cols = gray_image.cols;
	//measured_image store the image which removes the outliers (about 10% of the radiance are outliers)
	//printf("gray_image.type: %s\n", gray_image.type());
	Mat measured_image(rows, cols, gray_image.type());
	measured_image.setTo(0);
	//
	/*Mat convert_image;
	gray_image.convertTo(convert_image, CV_32FC1);*/
	//

	//double std_dev = (double)stddev_pxl;
	//printf("std_dev: %f\n", std_dev);
	//printf("mean: %d\n", gray_image.at<uchar>(0,0));
	for(int i=0; i<rows; i++){
		for(int j=0; j<cols; j++)
		{
			//Mat::at returns a reference to the specified array element
			double outlier_value = fabs(gray_image.at<uchar>(i,j) - (double)mean_pxl);
//			printf("ri_value: %f", ri_value);
			if( outlier_value <= k * (double)stddev_pxl){
				//take the pixel
			    measured_image.at<uchar>(i,j) = gray_image.at<uchar>(i,j);
			} else{
				//outlier
			     measured_image.at<uchar>(i,j) = 0;
			}
		}
	}

	//imshow("forhead region", measured_image);

    Scalar measured_mean,measured_stddev; 
	meanStdDev(measured_image, measured_mean, measured_stddev);
	//Scalar measured_mean = mean(measured_image);
	//uchar measured_mean_pxl = measured_mean.val[0];

	printf("measured mean : %f \n", measured_mean.val[0] );

	strcpy(image.name, file_info.name);
	image.measured_mean = (double)measured_mean.val[0];

	fprintf(result_file, "%s\t\t%f\n", file_info.name, measured_mean.val[0]);
	//fprintf(result_file, "%f\n", measured_mean.val[0]);

	if((double)measured_mean.val[0] >= max_mean){
		max_mean = (double)measured_mean.val[0];

	}

	if((double)measured_mean.val[0] <= min_mean){
		min_mean = (double)measured_mean.val[0];
	}

	//free memory
	gray_image.release();
	measured_image.release(); 
}

    value = max_mean - min_mean;

    fprintf(result_file, "end.\n");

    _findclose(handle); // close

    waitKey(0); // Wait for a keystroke in the window

	fclose(result_file);

    return 0;
}