import skif.core;

void main()
{
    import std.stdio : writeln;
    import std.format;

    writeln(format("Hello, %s!", skif.core.get_library_name()));
}
