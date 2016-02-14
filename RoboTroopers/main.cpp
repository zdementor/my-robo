//|-------------------------------------------------------------------------
//| File:        main.cpp
//|
//| Descr:       This file is a part of the 'MyEngine'
//| Author:      Zhuk 'zdementor' Dmitry (aka ZDimitor)
//| Email:       zdimitor@pochta.ru, sibergames@nm.ru
//|
//|     Copyright (c) 2004-2009 by Zhuk Dmitry, Krasnoyarsk - Moscow
//|                      All Rights Reserved.
//|-------------------------------------------------------------------------

#include <my.h>

#if MY_DEBUG_MODE
#	define _CRTDBG_MAP_ALLOC
#	include <stdlib.h>
#	include <crtdbg.h>
#	include <time.h>
#	define MY_ALOC_HOOK 0
#endif

using namespace my;

#if MY_ALOC_HOOK

FILE *logAllocFile = NULL;

int __cdecl MyAllocHook(
	int						nAllocType,
	void					*pvData,
	size_t					nSize,
	int						nBlockUse,
	long					lRequest,
	const unsigned char		*szFileName,
	int						nLine)
{
   char *operation[] = { "", "Alloc", "Realloc", "Free" };
   char *blockType[] = { "FREE", "NORMAL", "CRT", "IGNORE", "CLIENT" };

   if (nBlockUse == _CRT_BLOCK)   // Ignore internal C runtime library allocations
      return( TRUE );

	if (pvData)
		fprintf(logAllocFile, "%s %d-byte '%s' block (#%ld) at 0x%p\n",
			operation[nAllocType], nSize, blockType[nBlockUse], lRequest, pvData);
	else
		fprintf(logAllocFile, "%s %d-byte '%s' block (#%ld)\n",
			operation[nAllocType], nSize, blockType[nBlockUse], lRequest);

	return (TRUE); // Allow the memory operation to proceed
}
#endif

//-------------------------------------------------------------------------
#if  MY_DEBUG_MODE
int main(int argc, char* argv[])
#else
int APIENTRY WinMain(
	HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPTSTR    lpCmdLine,
	int       nCmdShow)
#endif
{
#if MY_DEBUG_MODE
	{
		int tmpDbgFlag; 
		HANDLE hLogFile=CreateFile(
			"MyEngine_DebugLog_MemLeaks.txt",GENERIC_WRITE,FILE_SHARE_WRITE, 
			NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL); 
		_CrtSetReportMode(_CRT_ASSERT,
			_CRTDBG_MODE_FILE | _CRTDBG_MODE_WNDW | _CRTDBG_MODE_DEBUG); 
		_CrtSetReportMode(_CRT_WARN,
			_CRTDBG_MODE_FILE | _CRTDBG_MODE_DEBUG); 
		_CrtSetReportMode(_CRT_ERROR,
			_CRTDBG_MODE_FILE | _CRTDBG_MODE_WNDW | _CRTDBG_MODE_DEBUG); 
		_CrtSetReportFile(_CRT_ASSERT,hLogFile); 
		_CrtSetReportFile(_CRT_WARN,hLogFile); 
		_CrtSetReportFile(_CRT_ERROR,hLogFile); 
		tmpDbgFlag=_CrtSetDbgFlag(_CRTDBG_REPORT_FLAG); 
		tmpDbgFlag|=_CRTDBG_ALLOC_MEM_DF; 
		tmpDbgFlag|=_CRTDBG_DELAY_FREE_MEM_DF; 
		tmpDbgFlag|=_CRTDBG_LEAK_CHECK_DF; 
		_CrtSetDbgFlag(tmpDbgFlag);
		//_CrtSetBreakAlloc(132312);
	}
#endif // #if MY_DEBUG_MODE

#if MY_ALOC_HOOK
	{
		char timeStr[10], dateStr[10];         // Used to set up log file
		const char lineStr[] = { "--------------------------------------------------------\n"  };
		// Open a log file for the hook functions to use
		logAllocFile = fopen( "MyEngine_DebugLog_MemAlloc.txt", "w" );
		if (logAllocFile)
		{
			_strtime(timeStr);
			_strdate(dateStr);
			fprintf(logAllocFile, "Memory Allocation Log File, run at %s on %s.\n",
				timeStr, dateStr );
			fputs(lineStr, logAllocFile);

			_CrtSetAllocHook(MyAllocHook);
		}
	}
#endif

	scr::ICoreScriptManager *scrmgr = scr::createCoreScriptManager();
	scrmgr->runScript("../robo/robotroopers.lua");
	scrmgr->drop();

#if MY_ALOC_HOOK
	if (logAllocFile)
	{
		fclose(logAllocFile);
		logAllocFile = NULL;
	}
#endif

#if MY_DEBUG_MODE 
	// Memory audit
	printAllocNamesList("MyEngine_DebugLog_LeakObjects.txt");
#endif // #if MY_DEBUG_MODE 

	return 0;    
}


