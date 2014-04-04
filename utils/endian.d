module utils.endian;
import std.traits:isIntegral;
import std.bitmanip:swapEndian;

alias htons = bigEndian!ushort;

private struct byteArray(T)
{
	Unqual!T value;
	ubyte[T.sizeof] array;
}

T bigEndian (T)(T v) 
if (isIntegral!(T))
{	
	version(LittleEndian)
		return swapEndian(v);
	version(BigEndian)
		return v;
}