//#include "dbconnection.h"
#include "stdafx.h"
#include "dbconnection.h"

using namespace std;

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

int _tmain(int argc, _TCHAR* argv[])
{
	
	//about php in c++
    cout<< std::system("php -f autoload.php");
	
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

	if(mysql_query(conn, "select firstName, lastName, gender, Age from biometData where eyesPath = 'suspectsUpload/eyes/138216560533-88011_L_2_Eyelid.bmp';")){
		printf("Error %u: %s\n", mysql_errno(conn), mysql_error(conn));
        exit(1);
	} else {
	    result = mysql_store_result(conn);

		//retrieve the number of rows and fields
		num_fields = mysql_num_fields(result);
		fields = mysql_fetch_field(result);

		//string str;
		string separator = "; ";
		string matched_remark;
		while((row = mysql_fetch_row(result))){
		//each row
			//init the buffer, memset copies the '\0' to the first sizeof * buffer of buffer
			//memset(buffer, '\0', sizeof * buffer);

			for(i = 0; i < num_fields; i++){
			   /*if (i == 0) {
				   while(fields = mysql_fetch_field(result)){
				       printf("%s ", fields->name);

				   }
                   printf("\n");
				}*/

				//firstName
				if (fields[i].name == "firstName" ){
					  string firstname = "FirstName:";

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
				if (fields[i].name == "lastName"){
					  // printf("lastname: %s\n", fields[i].name);
                       string lastname = "LastName:";

					   matched_remark = matched_remark + lastname + row[1] + separator;
				}

				//gender
				if (fields[i].name == "gender"){
					  // printf("gender: %s\n", fields[i].name);
                       string gender = "gender:";
					   matched_remark = matched_remark + gender + row[2] + separator;
				}

				//Age
				if (fields[i].name == "Age"){
					  // printf("Age: %s\n", fields[i].name);
                       string age = "Age:";
					   matched_remark = matched_remark + age + row[3] + separator;
				}

			   }//for

			 string camera_serial = "06";
			 matched_remark = matched_remark + "Camera:" + camera_serial + separator;

			 string gate_num = "02";
			 matched_remark = matched_remark + "GateNum:" + gate_num + separator;

			}//while 

        cout<<"matched_remark:"<<matched_remark<<endl;

		//matched images
		string basename_image = "138156374231-113AD-080GE__1_00-0C-DF-04-A2-2D2222_F4_L4.jpg";
		string matched_dir = "suspectsUpload/matched/";
		string matched_image = matched_dir + basename_image;
        cout<<"matched_image:"<<matched_image<<endl;
		
		//marched_score
		string marched_score = "0.6";

		//update the db
		string sql_matched;

		sql_matched = "update eyesMatchResulted e, biometData b set e.matchedScored = " + marched_score + ", e.matchedPath ='" + matched_image + "', e.matchedRemark = '" + matched_remark + "' where e.idbiometData = b.idbiometData and b.eyesPath = 'suspectsUpload/eyes/" + basename_image + " '";
		//update eyesMatchResulted e, biometData b set e.matchedScored = 0.6, e.matchedPath ='$matched_image', e.matchedRemark = '$matched_remark' where e.idbiometData = b.idbiometData and b.eyesPath = 'suspectsUpload/eyes/$db_image';
		cout<<"sql_matched:"<<sql_matched<<endl;

		//convert string to char*
		char* cstr = new char[sql_matched.length() + 1];
		strcpy(cstr, sql_matched.c_str());

		mysql_query(conn,cstr);

		delete[] cstr;

		//free(buffer);
	}

	mysql_free_result(result);
	mysql_close(conn);
	
}