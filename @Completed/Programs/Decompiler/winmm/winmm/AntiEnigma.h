#include <windows.h>

typedef int (__stdcall * ENIGMA_ProtectedStringByID)(int, WCHAR*, int); // function pointer to EN_ProtectedStringByID

LPWSTR ExtractEnigmaString(int id);

LPWSTR WR_EP_ProtectedStringByID(int id, ENIGMA_ProtectedStringByID pProtectedStringByID);