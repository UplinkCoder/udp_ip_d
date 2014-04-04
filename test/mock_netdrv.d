module test.mock_netdrv;
import std.exception;
extern (C):
	static immutable uint globalbuffer_size = 1024; 
	__gshared uint current_size;
	__gshared ubyte [globalbuffer_size] globalbuffer;
	__gshared bool globalBufferIsRecvBuffer = false;
	__gshared bool globalBufferIsSendBuffer = false;
ubyte[] getGlobalRecvBuffer() {return globalbuffer;}
ubyte[] getGlobalSendBuffer() {return globalbuffer;}

alias getRecvBuffer = getGlobalRecvBuffer;
alias getSendBuffer = getGlobalSendBuffer;

/*
extern (D):
struct Fakebuffer {
	shared align(64) ubyte[1024] buffer;
	@property extern (C) uint current_size() {return buffer.length;} 
	
	ubyte[] getRecvBuffer() {
		return buffer.ptr;
	}
	ubyte[] getSendBuffer() {
		return buffer.ptr;
	}
}
*/
extern (C) __gshared :
int net_start (uint i,uint m, uint g) {return 0;}

int net_receive(ubyte* recvbuffer) {
	enforce(recvbuffer==getRecvBuffer.ptr,"Are you mocking me ?\nWrong Buffer!");
	uint size = current_size;
	current_size = 0; // buffer is cleared :D
	return size;
}

int net_send(ubyte* sendbuffer, size_t len) {
	enforce(current_size>0,"You are overwriting an unread package");
	enforce(sendbuffer==getSendBuffer.ptr,"Are you mocking me ?\nWrong Buffer!");
	current_size = len; 
	return len;
}

