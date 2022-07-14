#include <windows.h>

#undef ERROR
#include "RSCommon.h"
#include "RError.h"

static HKEY resolveBuiltinKey(const char * const name);
static USER_OBJECT_ convertRegistryValueToS(BYTE *val, DWORD size, DWORD type);
static BYTE *convertToRegistry(USER_OBJECT_ val, DWORD *nsize, DWORD targetType, const char *keyName);
static HKEY getOpenRegKey(USER_OBJECT_ hkey, USER_OBJECT_ subKey);

SEXP createRKey(SEXP top, SEXP els, Rboolean isValue);



void
SWinRegistryError(LONG status, const char *msg)
{
    char errBuf[1000];
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, status, // GetLastError(), 
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
                     errBuf, sizeof(errBuf)/sizeof(errBuf[0]), NULL);

    SEXP expr, errMsg, uMsg;

    PROTECT(errMsg = Rf_allocVector(STRSXP, 1));
    SET_STRING_ELT(errMsg, 0, mkChar(errBuf));
    PROTECT(uMsg = Rf_allocVector(STRSXP, 1));
    SET_STRING_ELT(uMsg, 0, mkChar(msg));    
    PROTECT(expr = Rf_lang4(Rf_install(".WinRegistryError"),
			    ScalarInteger(status),
			    errMsg,
			    uMsg
			    ));
			    
    Rf_eval(expr, R_GlobalEnv);
    UNPROTECT(3);
}





__declspec(dllexport)
USER_OBJECT_
R_createRegistryKey(USER_OBJECT_ hkey, USER_OBJECT_ subKey)
{
  HKEY lkey, key;
  DWORD created;
  USER_OBJECT_ ans;
  const char *name;
  LONG status = ERROR_SUCCESS;

  lkey = getOpenRegKey(hkey, subKey);

  name = CHAR_DEREF(STRING_ELT(subKey, 1));
  status = RegCreateKeyEx(lkey, name, 0, (char *) NULL, 
			  REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &key, &created);
  if(status != ERROR_SUCCESS) {
    RegCloseKey(lkey);
    SWinRegistryError(status, "Cannot create key");
    return(R_NilValue);
  }

  ans = NEW_LOGICAL(1);
  if(created == REG_OPENED_EXISTING_KEY ) {
    RegCloseKey(key);
  } else {
    RegFlushKey(key);
    LOGICAL_DATA(ans)[0] = TRUE;
  }

  RegCloseKey(lkey);

  return(ans);
}

__declspec(dllexport)
USER_OBJECT_
R_getRegistryKey(USER_OBJECT_ hkey, USER_OBJECT_ subKey, USER_OBJECT_ isError)
{
  HKEY lkey;
  const char *name = NULL;
  BYTE *buf;
  LONG status;
  DWORD bufSize, type;
  USER_OBJECT_ ans = R_NilValue;

  lkey = getOpenRegKey(hkey, subKey);

  if(GET_LENGTH(subKey))
    name = CHAR_DEREF(STRING_ELT(subKey, 1));
  if(!name[0])
    name = NULL;

  if((status = RegQueryValueEx(lkey, name, NULL, NULL, NULL, &bufSize)) != ERROR_SUCCESS) {
    RegCloseKey(lkey);
    if(LOGICAL(isError)[0]) {
      PROBLEM "Can't get key %s", (name ? name : "Default")
      ERROR;
    } else {
      PROTECT(ans = allocVector(STRSXP, 1));
      SET_STRING_ELT(ans, 0, R_NaString);
      UNPROTECT(1);
      return(ans);
    }
  }

  buf = (BYTE *) S_alloc(bufSize, sizeof(BYTE));
  if((status = RegQueryValueEx(lkey, name, NULL, &type, buf, &bufSize)) != ERROR_SUCCESS) {
    RegCloseKey(lkey);
    PROBLEM "Can't get key %s (2nd time)", name
    ERROR;
  }
  ans = convertRegistryValueToS(buf, bufSize, type);
  RegCloseKey(lkey);
  return(ans);
}

__declspec(dllexport)
USER_OBJECT_
R_ExpandEnvironmentStrings(USER_OBJECT_ svalue)
{
  const char *tmp;
  USER_OBJECT_ ans;
  int n = GET_LENGTH(svalue), i, len;
  char buf[4000];
  PROTECT(ans = NEW_CHARACTER(n));
  for(i = 0; i < n; i++) {
     tmp = CHAR_DEREF(STRING_ELT(svalue, i));
     len = ExpandEnvironmentStrings(tmp, buf, sizeof(buf)/sizeof(buf[0]));
     if(len > sizeof(buf)/sizeof(buf[0])) {
       PROBLEM "String too long when expanded: %s", tmp
        WARN;
     }
     SET_STRING_ELT(ans, i, COPY_TO_USER_STRING(buf));
  }

  UNPROTECT(1);
  return(ans);
}

__declspec(dllexport)
USER_OBJECT_
R_flushRegKey(USER_OBJECT_ hkey, USER_OBJECT_ path, USER_OBJECT_ subKey)
{
  USER_OBJECT_ ans;
  HKEY lkey;
  DWORD status;

  lkey = getOpenRegKey(hkey, path);
  status = RegFlushKey(lkey);

  if(status != ERROR_SUCCESS) {
      char errBuf[1000];
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, status, // GetLastError(), 
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
                     errBuf, sizeof(errBuf)/sizeof(errBuf[0]), NULL);
      PROBLEM "Error flushing key: %s", errBuf
      ERROR;
  }

  ans = NEW_LOGICAL(1);
  LOGICAL_DATA(ans)[0] = TRUE;
  return(ans);
}

__declspec(dllexport)
USER_OBJECT_
R_deleteRegKey(USER_OBJECT_ hkey, USER_OBJECT_ path, USER_OBJECT_ subKey, 
                USER_OBJECT_ asKey, USER_OBJECT_ recursive)
{
  USER_OBJECT_ ans;
  HKEY lkey;
  const char *tmp;
  LONG status = ERROR_SUCCESS;

  lkey = getOpenRegKey(hkey, path);
  tmp = CHAR_DEREF(STRING_ELT(subKey, 0));
  if(!tmp[0])
    tmp = NULL;

  if(LOGICAL_DATA(asKey)[0]) {
    status = RegDeleteKey(lkey, tmp);
  } else
    status = RegDeleteValue(lkey, tmp);

  if(status != ERROR_SUCCESS) {
      char errBuf[1000];
      RegCloseKey(lkey);
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, status, // GetLastError(), 
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
                     errBuf, sizeof(errBuf)/sizeof(errBuf[0]), NULL);
      PROBLEM "Error deleting %s (%s): (%d) %s ", 
     	          (LOGICAL_DATA(asKey)[0] ? "key" : "value"),
                  (tmp ? tmp : ""), (int) status, errBuf
      ERROR;
  }

  RegFlushKey(lkey);
  RegCloseKey(lkey);

  ans = NEW_LOGICAL(1);
  LOGICAL_DATA(ans)[0] = TRUE;
  return(ans);
}


/*
  
*/
__declspec(dllexport)
USER_OBJECT_
R_getRegistryKeys(USER_OBJECT_ hkey, USER_OBJECT_ subKey, USER_OBJECT_ sgetInfo)
{
  LONG status;
  USER_OBJECT_ ans, names;

  int getInfo = LOGICAL_DATA(sgetInfo)[0];

  HKEY  lkey;
  DWORD i, maxSize, numKeys = 0, next = 0, count = 0; 

  char buf[1024], className[1024];
  DWORD classNameSize = 1024, bufSize = 1024;

  BYTE data[4000];
  DWORD dataSize = 4000, type;

  int numProtects = 2;

  lkey = getOpenRegKey(hkey, subKey);

  status = RegQueryInfoKey(lkey, className, &classNameSize, NULL, &maxSize,
                           NULL, NULL, &numKeys, NULL, NULL, NULL, NULL); 

  if(status != ERROR_SUCCESS) {
      char errBuf[1000];
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, status, //GetLastError(), 
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
                     errBuf, sizeof(errBuf)/sizeof(errBuf[0]), NULL);
      RegCloseKey(lkey);
      PROBLEM "Error in get keys: %s",  errBuf
      ERROR;
  }

  count = getInfo ? maxSize : numKeys;

  i = next = 0;
  if(getInfo)
    PROTECT(ans = NEW_CHARACTER(count));
  else
    PROTECT(ans = NEW_LIST(count));


  PROTECT(names = NEW_CHARACTER(count));

  while(1) {
     /* Need to reset these since the previous call will have set them to the actual values. */
    bufSize = 1024; classNameSize = 1024, dataSize = 4000;
    if(getInfo) {
      FILETIME ftime;
      status = RegEnumKeyEx(lkey, next, buf, &bufSize, (LPDWORD) NULL, className, &classNameSize, &ftime);
    } else
      status = RegEnumValue(lkey, next, buf, &bufSize, (LPDWORD) NULL, &type, data, &dataSize);


    if(status == ERROR_SUCCESS) {
      SET_STRING_ELT(names, i, COPY_TO_USER_STRING(buf));
      if(getInfo)
         SET_STRING_ELT(ans, i, COPY_TO_USER_STRING(className));
      else {
  	 USER_OBJECT_ tmpVal = convertRegistryValueToS(data, dataSize, type);
	 if(tmpVal != R_NilValue)
     	     SET_VECTOR_ELT(ans, i, tmpVal); 
      }
    } else if(status == ERROR_NO_MORE_ITEMS) {
      break;
    } else if(status == ERROR_MORE_DATA) {
      PROBLEM "More data error when fetching key value (%d) %s", (int) next, buf
	WARN;
    } else {
      char errBuf[1000];
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, status, //GetLastError(), 
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
                     errBuf, sizeof(errBuf)/sizeof(errBuf[0]), NULL);
      RegCloseKey(lkey);
      PROBLEM "Error in RegEnumKeyEx (%d): %s %s", (int) next, buf, errBuf
      ERROR;
    }

    next++;
    i++;
  }

  RegCloseKey(lkey);

  SET_NAMES(ans, names);

  UNPROTECT(numProtects);

  return(ans);
}


__declspec(dllexport)
USER_OBJECT_
R_setRegistryKey(USER_OBJECT_ hkey, USER_OBJECT_ path, USER_OBJECT_ skeyName, USER_OBJECT_ value, USER_OBJECT_ stype)
{
  HKEY lkey;
  const char *name = NULL;
  DWORD type = INTEGER_DATA(stype)[0];
  BYTE *data;
  DWORD ndata = 0;

     /* KEY_SET_VALUE */
  lkey = getOpenRegKey(hkey, path);

  if(Rf_length(skeyName)) {
    name = CHAR_DEREF(STRING_ELT(skeyName, 0));
    if(!name || !name[0])
      name = NULL;
  }
  data = convertToRegistry(value, &ndata, type, name);
  if(data)
    RegSetValueEx(lkey, name, 0, type, data, ndata);

  return(R_NilValue);
}

static HKEY
getOpenRegKey(USER_OBJECT_ hkey, USER_OBJECT_ subKey)
{
  HKEY key, lkey;
  const char *name;

  key = resolveBuiltinKey(CHAR_DEREF(STRING_ELT(hkey, 0)));
  if(key == NULL) {
   PROBLEM "Invalid top-level key!"
   ERROR;
  }
  name = CHAR_DEREF(STRING_ELT(subKey, 0));

  if(name && name[0]) {
    LSTATUS status = RegOpenKeyEx(key, name, 0, KEY_ALL_ACCESS, &lkey);
    if(status != ERROR_SUCCESS) {
      SWinRegistryError(status, "Can't open key");
      /*      
      char errBuf[1000];
      FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, status, //GetLastError(), 
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), 
                     errBuf, sizeof(errBuf)/sizeof(errBuf[0]), NULL);      
      PROBLEM "Can't open key %s (%ld) %s", name, status, errBuf
      ERROR;
      */
      return(NULL);
    }
  } else 
    lkey = key;

  return(lkey);
}

SEXP
R_registryKeyResolve(USER_OBJECT_ hkey, USER_OBJECT_ subKey, USER_OBJECT_ els)
{
  HKEY key, lkey;
  const char *name;
  HRESULT status;
  SEXP ans = R_NilValue;

  key = resolveBuiltinKey(CHAR_DEREF(STRING_ELT(hkey, 0)));
  if(key == NULL) {
   PROBLEM "Invalid top-level key!"
   ERROR;
  }
  if(Rf_length(subKey) > 0) {
    name = CHAR_DEREF(STRING_ELT(subKey, 0));
    if(!name[0]) 
      name = NULL;
  } else
    name = NULL;

  status = RegOpenKeyEx(key, name, 0, KEY_ALL_ACCESS, &lkey);
  if(status == ERROR_SUCCESS) {
    RegCloseKey(lkey);
    RegCloseKey(key);
    ans = createRKey(hkey, subKey, FALSE);
  } else {
    DWORD bufSize;
    status = RegOpenKeyEx(key, CHAR_DEREF(STRING_ELT(els,0)),  0, KEY_ALL_ACCESS, &lkey);
    if(status == ERROR_SUCCESS) {
      status = RegQueryValueEx(lkey, CHAR_DEREF(STRING_ELT(els, 1)), NULL, NULL, NULL, &bufSize);
      if(status == ERROR_SUCCESS) {
        RegCloseKey(lkey);
        ans = createRKey(hkey, els, TRUE);
      }
    }
    RegCloseKey(key);
  }

  return(ans);
}

SEXP
createRKey(SEXP top, SEXP els, Rboolean isValue)
{
  SEXP e, tmp, ans;
  PROTECT(e = allocVector(LANGSXP, 4));
  SETCAR(e, Rf_install("createRegistryPath"));
  SETCAR(CDR(e), els);
  SETCAR(CDR(CDR(e)), top);
  SETCAR(CDR(CDR(CDR(e))), tmp = allocVector(LGLSXP, 1));
  LOGICAL(tmp)[0] = isValue;
  ans = eval(e, R_GlobalEnv);
  UNPROTECT(1);
  return(ans);
}


static BYTE *
convertToRegistry(USER_OBJECT_ val, DWORD *nsize, DWORD targetType, const char *name)
{
  int nprotect = 0;
  
  if(targetType == REG_NONE) {
    PROTECT(val = AS_CHARACTER(val));
    nprotect++;
  }

  BYTE *ans = NULL;
  switch(targetType) {
    case REG_NONE:
    case REG_SZ:
    case REG_EXPAND_SZ:
      {
       const char *str; 
       str = CHAR_DEREF(STRING_ELT(val, 0));
       *nsize = strlen(str)+1;
       ans = (BYTE*) S_alloc(*nsize, sizeof(DWORD));
       strcpy((char *) ans, str);
      }
      break;
    case REG_DWORD:
      if(TYPEOF(val) == INTSXP) {
        *nsize = sizeof(int);
        ans = (BYTE*) S_alloc(1, sizeof(int));
        *ans = INTEGER(val)[0];
      } else if(TYPEOF(val) == REALSXP) {
        *nsize = 1;
        ans = (BYTE*) S_alloc(*nsize, sizeof(DWORD));
        *ans = REAL(val)[0];
      }
      break;
    default:
      PROBLEM "Unhandled case (%d) in converting R value (%d) to registry type (convertToRegistry) for key %s",
	(int) targetType, TYPEOF(val), name
      WARN;
  }
  if(nprotect)
    UNPROTECT(nprotect);

  return(ans);
}


static  HKEY
resolveBuiltinKey(const char * const name)
{
  HKEY BuiltinKeys[] = {HKEY_CLASSES_ROOT,
			HKEY_CURRENT_CONFIG,
			HKEY_CURRENT_USER,
			HKEY_LOCAL_MACHINE,
			HKEY_USERS};

  char *BuiltinNames[] = {
                        "HKEY_CLASSES_ROOT",
			"HKEY_CURRENT_CONFIG",
			"HKEY_CURRENT_USER",
			"HKEY_LOCAL_MACHINE",
			"HKEY_USERS"};
  int n, i;

  n = sizeof(BuiltinKeys)/sizeof(BuiltinKeys[0]);

  for(i = 0; i < n ; i++) {
    if(strcmp(BuiltinNames[i], name) == 0) {
      return(BuiltinKeys[i]);
    }
  }

  return(NULL);
}


static USER_OBJECT_ 
convertRegistryValueToS(BYTE *val, DWORD size, DWORD valType)
{
   USER_OBJECT_ ans = R_NilValue;;

   switch(valType) {
    case REG_DWORD:
       ans = NEW_INTEGER(1);
       INTEGER_DATA(ans)[0] = *((int *) val);
       break;
    case REG_SZ:
    case REG_EXPAND_SZ:
       PROTECT(ans = NEW_CHARACTER(1));
       SET_STRING_ELT(ans, 0, COPY_TO_USER_STRING((char *) val));
       UNPROTECT(1);
       break;
   case REG_MULTI_SZ:
     fprintf(stderr, "Muti_sz entry\n");
     break;
   case REG_BINARY:
     fprintf(stderr, "Binary entry\n");
     break;
    default:
      PROBLEM "No such type %d", (int) valType
     ERROR;
   }
  return(ans);
}
