// DISABLED: LDC
// EXTRA_OBJC_SOURCES

extern (Objective-C)
class A
{
    void oneTwo(int a, int b) pure @selector("one:two:");
    void test(int a, int b, int c) @selector("test:::");
}

// https://issues.dlang.org/show_bug.cgi?id=19494
extern (Objective-C) class NSObject
{
    extern (Objective-C) class Class {}
}

// https://issues.dlang.org/show_bug.cgi?id=19699
// Declaring a root class with a method with a body
extern(Objective-C) class Test
{
   void foo() {}
}
