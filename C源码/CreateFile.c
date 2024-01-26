#include <stdio.h>
#include <Windows.h>
BOOL SetPrivilege(HANDLE hToken,LPCTSTR lpszPrivilege,BOOL bEnablePrivilege)
{
	TOKEN_PRIVILEGES tp={0};
	LUID luid;
	if(!LookupPrivilegeValue(NULL,lpszPrivilege,&luid)){
		printf("�޷�����Ȩ��ֵ\n");
		return FALSE;
	}
	tp.PrivilegeCount=1;
	tp.Privileges[0].Luid=luid;
	tp.Privileges[0].Attributes=bEnablePrivilege?SE_PRIVILEGE_ENABLED:0;
	if(!AdjustTokenPrivileges(hToken,FALSE,&tp,sizeof(TOKEN_PRIVILEGES),NULL,NULL)){
		printf("�޷�����������Ȩ\n");
		return FALSE;
	}
	if(GetLastError()==ERROR_NOT_ALL_ASSIGNED){
		printf("�޷����������������Ȩ\n");
		return FALSE;
	}
	return TRUE;
}
int main(){
	printf("\n\t���Թ���ԱȨ�����У�\n�˳��������ڵ�ǰĿ¼�����򸲸�����Ϊ\"CreateFile.bin\"��ָ��Ԥ����ռ��С���ļ�\n��λ����KB��\n\t�ο�ֵ��\n\t1TB��1073741824\n\t1GB��1048576\n\t1MB��1024\n�����봴�����ļ���С��");
	LPCSTR fileName="CreateFile.bin";
	ULONGLONG fileSize;
	scanf("%d",&fileSize);
	fileSize*=1024;
	HANDLE hToken;
	if(!OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES|TOKEN_QUERY,&hToken)){
		printf("�޷��򿪽�������\n");
		system("pause");
		return 3;
	}
	if(!SetPrivilege(hToken,SE_MANAGE_VOLUME_NAME,TRUE)){
		printf("��ȡSE_MANAGE_VOLUME_NAMEȨ��ʧ��\n");
		CloseHandle(hToken);
		system("pause");
		return 2;
	}
	HANDLE hFile=CreateFileA(fileName,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
	if(hFile==INVALID_HANDLE_VALUE){
		printf("�޷������ļ�\n");
		CloseHandle(hToken);
		system("pause");
		return 1;
	}
	LARGE_INTEGER liDistanceToMove;
	liDistanceToMove.QuadPart=fileSize;
	SetFilePointerEx(hFile,liDistanceToMove,NULL,FILE_BEGIN);
	if(SetEndOfFile(hFile))
		if(SetFileValidData(hFile,fileSize))
			printf("��Ч���ݳ������óɹ�\n");
		else
			printf("�޷�������Ч���ݳ���\n");
	else
		printf("�޷���չ�ļ���С\n");
	CloseHandle(hFile);
	CloseHandle(hToken);
		system("pause");
	return 0;
}