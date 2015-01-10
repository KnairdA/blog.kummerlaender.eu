# GraphStorage

…is a Graph storage and query library based on Google LevelDB and written in C++.

It currently supports integer indexed nodes with properties and directed edges with types. The integer IDs are serialized _by hand_, values are serialized using protocol buffers. Everything is stored in a single sorted [LevelDB] database.

Queries are possible trough a iterator like interface that handles single level queries quite fast. Additionally changes to edges can be monitored using a subscription mechanism.

The library is in development and while not intended for any kind of production usage the source code is available via both [Github] and [cgit].

[Github]: https://github.com/KnairdA/GraphStorage/
[cgit]: http://code.kummerlaender.eu/GraphStorage/
[LevelDB]: https://code.google.com/p/leveldb/
