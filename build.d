import std;

void main() {
	string[] files = read("index").to!string.splitter(",").array.retro
		.map!(x => "pages".chainPath(x ~ ".adoc").to!string).array;
	File index = File("index.adoc", "w");
	index.write("= Brian's Blog\n\n");
	foreach (path; files) {
		string name = path.baseName.stripExtension.to!string;
		string content = read(path).to!string.splitter("\n\n").take(2).joiner("\n\n").to!string;
		size_t delim = content.countUntil("\n");
		string title = content[2 .. delim];
		string rest = content[delim .. $];
		content = "== link:" ~ name ~ ".html[" ~ title ~ "]" ~ rest;
		index.write(content ~ "\n\n");
	}
	index.close();
	string[] filesToBuild = "index" ~ files.map!(x => x.stripExtension.to!string).array;
	foreach (path; filesToBuild) {
		execute(["asciidoctor", path ~ ".adoc", "-o", "docs".chainPath(path.baseName ~ ".html").to!string]);
	}
}
