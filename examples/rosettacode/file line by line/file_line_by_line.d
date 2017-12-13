void main() {
    import std.stdio;
 
    foreach (line; "../file_line_by_line.d".File.byLine)
        line.writeln;
}