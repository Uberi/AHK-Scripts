#include "Utils.h"


LPWSTR NumberToLPWSTR(int num){
	WCHAR buffer[65];
	_itow_s(num,buffer,sizeof(buffer),10);
	return buffer;
}


LPWSTR EscapeName(LPWSTR src){
	const int FORBIDDEN_CHARS_COUNT = 7;
	const WCHAR FORBIDDEN_CHARS[FORBIDDEN_CHARS_COUNT]  = {'<', '>', '/','\\',':', '?', '*'};  //L"<>/\:?*";
	const WCHAR replacement = '_';

	WCHAR escapedStr[MAX_PATH+50];
	wcscpy(escapedStr, src);

	int len = wcslen(src);

	//
	// replace all forbidden chars
	//
	for(int i=0;i<len;i++){

		for(int j=0;j<FORBIDDEN_CHARS_COUNT;j++)
		{
			if(FORBIDDEN_CHARS[j] == escapedStr[i])
			{
				escapedStr[i] = replacement;
			}
		}
	}

	return escapedStr;
}