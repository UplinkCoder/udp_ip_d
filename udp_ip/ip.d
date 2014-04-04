module udp_ip.ip;
import core.stdc.stdio:sprintf;
import core.stdc.string:strlen;
import ctypes;

struct Ipv4 {

	enum Protocol:uint8_t {
	  udp=0x11,
	  tcp=0x09,
	  icmp=0x01
	}

	static struct Hdr  {//ip header (20 bytes)
	align (1):
		uint8_t     ipVersion = 0x45;
		uint8_t     differentiatedServices=0;
		uint16_t    totalLength;       
		uint16_t    identifier;     //Variant
		uint16_t    fragmentationFlagOffset=0; // assume no framentation
		uint8_t     timeToLive=64;
		Protocol    protocol;       
		uint16_t    headerChecksum;  
		Addr    srcAddr;      
		Addr    dstAddr;      
	}

	static struct Addr {
	align(1):
		static immutable ubyte AddrLen=4;
		private union UniIp {
	    	uint ip_32;
	    	ubyte[4] ip_8;
	    }

		private UniIp _ip;
		this (string ip_str) {
	   // _ip=itol(ip_str);
		}
		this (uint ip) {_ip.ip_32=ip;}
		this (ubyte[4] ip) {_ip.ip_8=ip;}

		string toString() 
		{
			static char[4*4] str;
			sprintf(str.ptr,"%d.%d.%d.%d",
				_ip.ip_8[0],
				_ip.ip_8[1],
				_ip.ip_8[2],
				_ip.ip_8[3]
			);
			return str[0 .. strlen(str.ptr)].idup;
	    } 
	}
}
deprecated alias Ipv4Addr = Ipv4.Addr;
deprecated alias Ipv4Hdr  = Ipv4.Hdr;