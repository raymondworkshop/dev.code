//db_connection.h
/*
 * @author Raymond
 *
 * History:
 *    Augustus-2014 Raymond creation
 */
#ifndef DB_CONNECTION_H
#define DB_CONNECTION_H

//std includes
#include <iostream>
#include <stdlib.h>
//#include <stdafx.h>
#include <cstdlib> //for std::system

//mysql c++
/*
#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include "mysql_connection.h"
*/

//mysql c
#include <my_global.h>
#include <mysql.h>

#define BUFFER_SIZE 516
#endif

//disable the warnings
/*
#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif
*/

//char* CatStr(char* buffer, char* str1, char* str2);

/* object  - (eyes, face, finger, iris) */
void DownloadFiles(const std::string& object);

void UploadFile(const std::string& subject);

/*
   object  - (eyes, face, finger, iris)
   suspect - the images in suspectsUpload/eyes/*
   subject - the images from the camera
*/
void UpdateData(const std::string&  object,const std::string& suspect, const std::string& subject, const std::string& camera, const std::string& gate);