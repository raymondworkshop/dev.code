//#include "dbconnection.h"
#include "stdafx.h"
#include "dbconnection.h"

//using namespace std;

/*
 * @author Raymond
 *
 * History:
 *    Augustus-2014 Raymond creation
 */

char* CatStr(char* buffer, char* str1, char* str2){
	//char* separator = "; ";

	#pragma warning(disable: 4996)
	//char *strncat(char *dest, const char *src, int n);
	strncat(buffer, str1, strlen(str1) + 1); //"FirstName: "
	strncat(buffer, str2, strlen(str2) + 1); // "wen"
	//strncat(buffer, separator, strlen(separator) + 1);
	#pragma warning(default: 4996)

	// printf("String = %s", buffer);
	return buffer;
}
  
int GetChar(char s[], int lim)  
{
    int c, i;

    for(i = 0; i<lim-1 && (c = getchar()) != EOF && c != '\n'; ++i)
      s[i] = c;

    if( c == '\n')
    {
      s[i] = c;
      ++i;
    }

    //'0' represents the null character, whose value is zero;
    // which marks the end of the string
    s[i] = '\0'; 
    
    return i;
}

/* Copy: copy 'from' to 'to'; */
void Copy(char to[], char from[])
{
    int i;
    
    i = 0;
    while((to[i] = from[i]) != '\0')
      ++i;
    
}

void DownloadFiles(std::string& object){
	std::string command = "php -f download.php " + object;

	char* php_command = new char[command.length() + 1];
	strcpy(php_command, command.c_str());
	printf("[DEBUG]php_command: %s", php_command);

	//about php in c++
    std::cout<<std::system(php_command);

	delete[] php_command;
}

void UploadFile(std::string& subject){
	std::string command = "php -f upload.php " + subject;
	//std::cout<<"php command:" <<command<< std::endl;

	char* php_command = new char[command.length() + 1];
	strcpy(php_command, command.c_str());
	printf("[DEBUG]php_command: %s", php_command);

	std::cout<<std::system(php_command);

	delete[] php_command;
}

/*
   object  - (eyes, face, finger, iris)
   suspect - the images in suspectsUpload/eyes/*
   subject - the images from the camera
*/
void UpdateData(std::string& object,std::string& suspect,std::string& subject, std::string& camera, std::string& gate){
	 std::cout<<"[DEBUG]object:"<<object <<std::endl;
	 std::cout<<"[DEBUG]suspect:"<<suspect<<std::endl;
	 std::cout<<"[DEBUG]subject:"<<subject<<std::endl;
	//printf("object: %s, suspect:%s, subject:%s:\n", object, suspect, subject);

	//about MYSQL
	//declare a MYSQL structure
	MYSQL *conn;

	// the structure is as a connection handler
	conn = mysql_init(NULL);

	if(conn == NULL){
		printf("Error %u: %s\n", mysql_errno(conn), mysql_error(conn));
        exit(1);
	}

	if(mysql_real_connect(conn, 
		                  "mysql.comp.polyu.edu.hk", 
						  "biomet", 
						  "qwkdjmxn", 
						  "biomet", 
						  3306, 
						  NULL, 
						  0) == NULL){
		printf("Error %u: %s\n", mysql_errno(conn), mysql_error(conn));
        exit(1);
	}

	MYSQL_RES *result;
	MYSQL_ROW row;
	MYSQL_FIELD *fields;
	int num_fields;
	int i;

	//char* buffer;
    //calloc allocates the requested memory and returns a pointer to it
	//buffer = (char*) calloc(BUFFER_SIZE, sizeof(char));
	std::string dir = object + "Path" ; //eyesPath
	std::string suspect_image = "'suspectsUpload/" + object + "/" + suspect + "';";  //'suspectsUpload/eyes/138216560533-88011_L_2_Eyelid.bmp';"
	//"select firstName, lastName, gender, Age from biometData where eyesPath = 'suspectsUpload/eyes/138216560533-88011_L_2_Eyelid.bmp';"
	std::string sql_matched_remark = "select firstName, lastName, gender, Age from biometData where " + dir + " = "  + suspect_image;
	//std::cout<<"sql_matched_remark:"<<sql_matched_remark <<std::endl;

	//convert string to char*
	char* cstr_sql_matched_remark = new char[sql_matched_remark.length() + 1];
	strcpy(cstr_sql_matched_remark, sql_matched_remark.c_str());
	
	printf("[DEBUG]cstr_sql_matched_remark: %s\n", cstr_sql_matched_remark);
	if(mysql_query(conn, cstr_sql_matched_remark)){
        printf("Error %u: %s\n", mysql_errno(conn), mysql_error(conn));

		delete[] cstr_sql_matched_remark;
        exit(1);
	} else {
		result = mysql_store_result(conn);

		//retrieve the number of rows and fields
		num_fields = mysql_num_fields(result);
		fields = mysql_fetch_field(result);

		//string str;
		std::string separator = "; ";
		std::string matched_remark;
		while((row = mysql_fetch_row(result))){
		//each row
			//init the buffer, memset copies the '\0' to the first sizeof * buffer of buffer
			//memset(buffer, '\0', sizeof * buffer);
			char* str;
			for(i = 0; i < num_fields; i++){
			   /*
				while(fields = mysql_fetch_field(result)){
				       printf("%s ", fields[i].name);

				}
                printf("\n");
				*/

				printf("[DEBUG]Fields: %s",fields[i].name);
                //firstName
				str = "firstName";
				if ( strcmp(str, fields[i].name) == 0 ){
					  std::string firstname = "FirstName:";
					  
                      matched_remark = firstname + row[0] + separator;
					  //strncat(buffer, separator, strlen(separator) + 1);
					  /*
					   #pragma warning(disable: 4996)
					   //char *strncat(char *dest, const char *src, int n);
					   strncat(buffer, firstname, strlen(firstname) + 1); //"FirstName: "
					   strncat(buffer, row[0], strlen(row[0]) + 1); // "wen"
					   strncat(buffer, separator, strlen(separator) + 1);
					   #pragma warning(default: 4996)
					  */
					 // printf("String = %s", buffer);
				}

				//lastname
				str= "lastName";
				if (strcmp(str, fields[i].name) == 0){
					  // printf("lastname: %s\n", fields[i].name);
                       std::string lastname = "LastName:";

					   matched_remark = matched_remark + lastname + row[1] + separator;
					   //std::cout<<"matched_remark:"<<matched_remark<<std::endl;

				}

				//gender
				str = "gender";
				if (strcmp(fields[i].name, str) == 0){
					  // printf("gender: %s\n", fields[i].name);
                       std::string gender = "gender:";
					   matched_remark = matched_remark + gender + row[2] + separator;
					   //std::cout<<"matched_remark:"<<matched_remark<<std::endl;

				}

				//Age
				str = "Age";
				if (strcmp (fields[i].name, str) == 0){
					  // printf("Age: %s\n", fields[i].name);
                       std::string age = "Age:";
					   matched_remark = matched_remark + age + row[3] + separator;
					   //std::cout<<"matched_remark:"<<matched_remark<<std::endl;

				}

			   }//for

			 //std::string camera_serial = "06";
			 matched_remark = matched_remark + "Camera:" + camera + separator;


			 //std::string gate_num = "02";
			 matched_remark = matched_remark + "GateNum:" + gate + separator;

			}//while 

        std::cout<<"matched_remark:"<<matched_remark<<std::endl;

		//matched images
		std::string basename_image = subject;
		//string basename_image = "138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg";
		std::string matched_dir = "suspectsUpload/matched/";
		std::string matched_image = matched_dir + basename_image;
		//printf("matched_image: %s", matched_image);
        std::cout<<"[DEBUG]matched_image:"<<matched_image<<std::endl;
		
		//marched_score
		std::string marched_score = "0.6";

		//update the db
		std::string sql_matched;

		sql_matched = "update " + object + "MatchResulted e, biometData b set e.matchedScored = " + marched_score + ", e.matchedPath ='" + matched_image + "', e.matchedRemark = '" + matched_remark + "' where e.idbiometData = b.idbiometData and b." + dir + "= " + suspect_image;
		//update eyesMatchResulted e, biometData b set e.matchedScored = 0.6, e.matchedPath ='$matched_image', e.matchedRemark = '$matched_remark' where e.idbiometData = b.idbiometData and b.eyesPath = 'suspectsUpload/eyes/$db_image';
		
		//std::cout<<"[DEBUG]sql_matched:"<<sql_matched<<std::endl;

		//convert string to char*
		char* cstr_sql_matched = new char[sql_matched.length() + 1];
		strcpy(cstr_sql_matched, sql_matched.c_str());
		printf("[DEBUG]sql_matched: %s", cstr_sql_matched);
		//update the data
		mysql_query(conn,cstr_sql_matched);

		delete[] cstr_sql_matched;

		delete[] cstr_sql_matched_remark;
		//free(buffer);
	}

	mysql_free_result(result);
	mysql_close(conn);
	
	exit(0);

}

int _tmain(int argc, _TCHAR* argv[])
{
	//to test
	std::string object = "eyes";
	std::string suspect = "138216560533-88011_L_2_Eyelid.bmp";
	std::string subject = "138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg";
	std::string camera = "06";
	std::string gate = "02";

	DownloadFiles(object);
	//UpdateData(object, suspect, subject, camera, gate);
	//UploadFile(subject);
}
