//db_connection.h
#ifndef DB_CONNECTION_H
#define DB_CONNECTION_H

//std includes
#include <iostream>
#include <stdlib.h>
//#include <stdafx.h>

//mysql
#include <my_global.h>
#include <mysql.h>

//string
#include <string>

#define BUFFER_SIZE 516
#endif

//disable the warnings
/*
#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif
*/

char* CatStr(char* buffer, char* str1, char* str2);
