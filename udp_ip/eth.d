module udp_ip.eth;
import core.stdc.stdio:sprintf;
import utils.endian;
import std.bitmanip;
import ctypes;

struct Eth {

	enum Type:ushort {
		arp=bigEndian!ushort(0x0806),
		ip=bigEndian!ushort(0x0800)
	}

	struct Addr 
	{
		static immutable AddrLen=6; 
		uint8_t		mac8[6];

		string toString()
		{
			char[6*3] str;
			
			sprintf(str.ptr,"%02X:%02X:%02X:%02X:%02X:%02X",
				mac8[0],
				mac8[1],
				mac8[2],
				mac8[3],
				mac8[4], 
				mac8[5],
				'\0'
			);
			return str.idup;
		} 
	}

	struct Hdr { //ethernet header (14 bytes)  
		Addr dstMac;		//0xFFFFFFFFFFFF=any (broadcast)
		Addr srcMac;
		Type type;
	}
	
}

deprecated alias Mac 	= Eth.Addr;