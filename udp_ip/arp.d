module udp_ip.arp;

import utils.endian;
import ctypes;
import udp_ip.eth,
	udp_ip.ip;

struct Arp {

	enum Operation:ushort {
		ArpRequest=htons(0x00_01),
		ArpResponse=htons(0x00_02)
	}
	enum HardwareType:ushort {
		Ethernet_10Mbps = htons(0x00_01),
	}
	enum ProtocolType:ushort {
		Ipv4 = htons(0x08_00)
	}

	alias Response=Operation.ArpResponse;
	alias Request=Operation.ArpRequest;

	static struct Packet {//arp header (2+2+1+1+2+6+4+6+4=28 bytes)
	    align(1) :
	    Eth.Hdr      ethHdr;
	    HardwareType    hardware;       //0x0100 (0x00 then 0x01)=Ethernet (10Mbps)
	    ProtocolType    protocol;       //0x0008 (0x08 then 0x00)=IP
	    uint8_t     hardwareAddrLen=Eth.Addr.AddrLen;    //6 (bytes)
	    uint8_t     protocolAddrLen=Ipv4.Addr.AddrLen;    //4 (bytes)
	    Operation    operation;      //0x0100 (0x00 then 0x01)=Request 0x0200=Answer
	    Eth.Addr     senderHardwareAddr; 
	    Ipv4.Addr    senderProtocolAddr; //Sender IP address
	    Eth.Addr    targetHardwareAddr; //0 if not known yet
	    Ipv4.Addr    targetProtocolAddr; //Target IP address
	}


	static struct Table {
		private static struct Entry {
			Ipv4.Addr ip;
			Eth.Addr mac;
		}

	    Entry[] entrys;
	    /**
	    just accepts bigEndian
	    */
	    Eth.Addr getHwAddr(Ipv4.Addr ip) nothrow @safe {
	        foreach(entry;entrys) {
	            if (entry.ip == ip) return entry.mac;
	        }
	            return cast(Eth.Addr)0;
	    }
	    
	    void insert(Ipv4.Addr ip,Eth.Addr mac) {
	        entrys~=Entry(ip,mac);
	    }
	    
	}

	Table getArpTable() {
	    static __gshared Table t;
	    return t;
	}
}