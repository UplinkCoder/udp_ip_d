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

	struct Hdr {
	align(1):  
		Addr dstMac;
		Addr srcMac;
		Type type;
	}

	struct Addr 
	{
	align(1):
		static immutable AddrLen=6; 
		uint8_t		mac8[6];

		string toString()
		{
			static char[6*3-1] str;
			
			sprintf(str.ptr,"%02X:%02X:%02X:%02X:%02X:%02X",
				mac8[0],
				mac8[1],
				mac8[2],
				mac8[3],
				mac8[4], 
				mac8[5]
			);
			return str.idup;
		} 
	}

}

deprecated alias Mac 	= Eth.Addr;
