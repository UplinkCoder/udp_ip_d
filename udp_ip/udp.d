module udp_ip.udp;

import ctypes;
import core.stdc.string:memcpy;
import arch.netdrv;
import	udp_ip.eth,
		udp_ip.ip;

struct Udp {

	static struct Hdr {
	align (1) :
	    uint16_t srcPort;
	    uint16_t dstPort;
	    uint16_t length;
	    uint16_t checksum; 
	}

	static struct Packet {
	align(1) :
		Eth.Hdr  ethHdr;
		Ipv4.Hdr   ipHdr;
		Udp.Hdr  udpHdr;
	}


	//auto BuffMgr = getDefaultBuffMgr(); 
	struct UDPConnection {
		Udp.Packet conn;
		alias conn this;

	    void connect(Ipv4.Addr dstIp,ushort dstPort) {
			import 	udp_ip.arp;
	 //       dstIp  =  nativeToBigEndian(dstIp)
	//        dstPort = nativeToBigEndian(dstPort);
	        
	        //ethHdr.srcMac = cached!dstIp(getArpTable.getHwAddr(dstIp)); // TODO: impl cached-template
	        ipHdr.dstAddr = dstIp;
	        udpHdr.dstPort = dstPort;
	        
	    }
	    this(Ipv4.Addr srcIp, ushort srcPort=0) {
	        //ethHdr.srcMac = getArpTable.getHwAddr(srcIp); // TODO: impl cached-template
			ethHdr.type = Eth.Type.ip;
	        
	        ipHdr.srcAddr = srcIp;
	        ipHdr.protocol = Ipv4.Protocol.udp;
	       	udpHdr.srcPort = srcPort;
	   }     

	    @property ubyte[] recvbuffer() {
			return getGlobalRecvBuffer;  
	    }

	    @property ubyte[] sendbuffer() {
			return getGlobalSendBuffer;
	    }
		extern (C) :
		
	    uint recv() {
	       return net_receive(recvbuffer.ptr);
	    }
	    
	    uint send(ubyte[] data) {
	         version (no_zerocopy) 
	              memcpy(sendbuffer.ptr+UDPConnection.sizeof,data.ptr,data.length);
	         return net_send(recvbuffer.ptr,data.length+UDPConnection.sizeof );
	    }
	}

}